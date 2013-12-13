Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53938 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab3LMPO6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:14:58 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 04/11] media: rc: img-ir: add hardware decoder driver
Date: Fri, 13 Dec 2013 15:12:52 +0000
Message-ID: <1386947579-26703-5-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add remote control input driver for the ImgTec Infrared block hardware
decoder, which is set up with timings for a specific protocol and
supports mask/value filtering and wake events.

The hardware decoder timing values, raw data to scan code conversion
function and scan code filter to raw data filter conversion function are
provided as separate modules for each protocol which this part of the
driver can use. The scan code filter value and mask (and the same again
for wake from sleep) are specified via sysfs files in
/sys/class/rc/rcX/.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/img-ir-hw.c | 1277 +++++++++++++++++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir-hw.h |  284 ++++++++
 2 files changed, 1561 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.h

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
new file mode 100644
index 000000000000..917d9a076a8c
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -0,0 +1,1277 @@
+/*
+ * ImgTec IR Hardware Decoder found in PowerDown Controller.
+ *
+ * Copyright 2010-2013 Imagination Technologies Ltd.
+ *
+ * This ties into the input subsystem using the RC-core. Protocol support is
+ * provided in separate modules which provide the parameters and scancode
+ * translation functions to set up the hardware decoder and interpret the
+ * resulting input.
+ */
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <media/rc-core.h>
+#include "img-ir.h"
+
+/* Decoder list */
+static DEFINE_SPINLOCK(img_ir_decoders_lock);
+static struct img_ir_decoder *img_ir_decoders;
+static struct img_ir_priv *img_ir_privs;
+
+#define IMG_IR_F_FILTER		0x00000001	/* enable filtering */
+#define IMG_IR_F_WAKE		0x00000002	/* enable waking */
+
+/* code type quirks */
+
+#define IMG_IR_QUIRK_CODE_BROKEN	0x1	/* Decode is broken */
+#define IMG_IR_QUIRK_CODE_LEN_INCR	0x2	/* Bit length needs increment */
+
+/* functions for preprocessing timings, ensuring max is set */
+
+static void img_ir_timing_preprocess(struct img_ir_timing_range *range,
+				     unsigned int unit)
+{
+	if (range->max < range->min)
+		range->max = range->min;
+	if (unit) {
+		/* multiply by unit and convert to microseconds */
+		range->min = (range->min*unit)/1000;
+		range->max = (range->max*unit + 999)/1000; /* round up */
+	}
+}
+
+static void img_ir_symbol_timing_preprocess(struct img_ir_symbol_timing *timing,
+					    unsigned int unit)
+{
+	img_ir_timing_preprocess(&timing->pulse, unit);
+	img_ir_timing_preprocess(&timing->space, unit);
+}
+
+static void img_ir_timings_preprocess(struct img_ir_timings *timings,
+				      unsigned int unit)
+{
+	img_ir_symbol_timing_preprocess(&timings->ldr, unit);
+	img_ir_symbol_timing_preprocess(&timings->s00, unit);
+	img_ir_symbol_timing_preprocess(&timings->s01, unit);
+	img_ir_symbol_timing_preprocess(&timings->s10, unit);
+	img_ir_symbol_timing_preprocess(&timings->s11, unit);
+	/* default s10 and s11 to s00 and s01 if no leader */
+	if (unit)
+		/* multiply by unit and convert to microseconds (round up) */
+		timings->ft.ft_min = (timings->ft.ft_min*unit + 999)/1000;
+}
+
+/* functions for filling empty fields with defaults */
+
+static void img_ir_timing_defaults(struct img_ir_timing_range *range,
+				   struct img_ir_timing_range *defaults)
+{
+	if (!range->min)
+		range->min = defaults->min;
+	if (!range->max)
+		range->max = defaults->max;
+}
+
+static void img_ir_symbol_timing_defaults(struct img_ir_symbol_timing *timing,
+					  struct img_ir_symbol_timing *defaults)
+{
+	img_ir_timing_defaults(&timing->pulse, &defaults->pulse);
+	img_ir_timing_defaults(&timing->space, &defaults->space);
+}
+
+static void img_ir_timings_defaults(struct img_ir_timings *timings,
+				    struct img_ir_timings *defaults)
+{
+	img_ir_symbol_timing_defaults(&timings->ldr, &defaults->ldr);
+	img_ir_symbol_timing_defaults(&timings->s00, &defaults->s00);
+	img_ir_symbol_timing_defaults(&timings->s01, &defaults->s01);
+	img_ir_symbol_timing_defaults(&timings->s10, &defaults->s10);
+	img_ir_symbol_timing_defaults(&timings->s11, &defaults->s11);
+	if (!timings->ft.ft_min)
+		timings->ft.ft_min = defaults->ft.ft_min;
+}
+
+/* functions for converting timings to register values */
+
+/**
+ * img_ir_control() - Convert control struct to control register value.
+ * @control:	Control data
+ *
+ * Returns:	The control register value equivalent of @control.
+ */
+static u32 img_ir_control(struct img_ir_control *control)
+{
+	u32 ctrl = control->code_type << IMG_IR_CODETYPE_SHIFT;
+	if (control->decoden)
+		ctrl |= IMG_IR_DECODEN;
+	if (control->hdrtog)
+		ctrl |= IMG_IR_HDRTOG;
+	if (control->ldrdec)
+		ctrl |= IMG_IR_LDRDEC;
+	if (control->decodinpol)
+		ctrl |= IMG_IR_DECODINPOL;
+	if (control->bitorien)
+		ctrl |= IMG_IR_BITORIEN;
+	if (control->d1validsel)
+		ctrl |= IMG_IR_D1VALIDSEL;
+	if (control->bitinv)
+		ctrl |= IMG_IR_BITINV;
+	if (control->decodend2)
+		ctrl |= IMG_IR_DECODEND2;
+	if (control->bitoriend2)
+		ctrl |= IMG_IR_BITORIEND2;
+	if (control->bitinvd2)
+		ctrl |= IMG_IR_BITINVD2;
+	return ctrl;
+}
+
+/**
+ * img_ir_timing_range_convert() - Convert microsecond range.
+ * @out:	Output timing range in clock cycles with a shift.
+ * @in:		Input timing range in microseconds.
+ * @tolerance:	Tolerance as a fraction of 128 (roughly percent).
+ * @clock_hz:	IR clock rate in Hz.
+ * @shift:	Shift of output units.
+ *
+ * Converts min and max from microseconds to IR clock cycles, applies a
+ * tolerance, and shifts for the register, rounding in the right direction.
+ * Note that in and out can safely be the same object.
+ */
+static void img_ir_timing_range_convert(struct img_ir_timing_range *out,
+					const struct img_ir_timing_range *in,
+					unsigned int tolerance,
+					unsigned long clock_hz,
+					unsigned int shift)
+{
+	unsigned int min = in->min;
+	unsigned int max = in->max;
+	/* add a tolerance */
+	min = min - (min*tolerance >> 7);
+	max = max + (max*tolerance >> 7);
+	/* convert from microseconds into clock cycles */
+	min = min*clock_hz / 1000000;
+	max = (max*clock_hz + 999999) / 1000000; /* round up */
+	/* apply shift and copy to output */
+	out->min = min >> shift;
+	out->max = (max + ((1 << shift) - 1)) >> shift; /* round up */
+}
+
+/**
+ * img_ir_symbol_timing() - Convert symbol timing struct to register value.
+ * @timing:	Symbol timing data
+ * @tolerance:	Timing tolerance where 0-128 represents 0-100%
+ * @clock_hz:	Frequency of source clock in Hz
+ * @pd_shift:	Shift to apply to symbol period
+ * @w_shift:	Shift to apply to symbol width
+ *
+ * Returns:	Symbol timing register value based on arguments.
+ */
+static u32 img_ir_symbol_timing(const struct img_ir_symbol_timing *timing,
+				unsigned int tolerance,
+				unsigned long clock_hz,
+				unsigned int pd_shift,
+				unsigned int w_shift)
+{
+	struct img_ir_timing_range hw_pulse, hw_period;
+	/* we calculate period in hw_period, then convert in place */
+	hw_period.min = timing->pulse.min + timing->space.min;
+	hw_period.max = timing->pulse.max + timing->space.max;
+	img_ir_timing_range_convert(&hw_period, &hw_period,
+			tolerance, clock_hz, pd_shift);
+	img_ir_timing_range_convert(&hw_pulse, &timing->pulse,
+			tolerance, clock_hz, w_shift);
+	/* construct register value */
+	return	(hw_period.max	<< IMG_IR_PD_MAX_SHIFT)	|
+		(hw_period.min	<< IMG_IR_PD_MIN_SHIFT)	|
+		(hw_pulse.max	<< IMG_IR_W_MAX_SHIFT)	|
+		(hw_pulse.min	<< IMG_IR_W_MIN_SHIFT);
+}
+
+/**
+ * img_ir_free_timing() - Convert free time timing struct to register value.
+ * @timing:	Free symbol timing data
+ * @clock_hz:	Source clock frequency in Hz
+ *
+ * Returns:	Free symbol timing register value.
+ */
+static u32 img_ir_free_timing(const struct img_ir_free_timing *timing,
+			      unsigned long clock_hz)
+{
+	unsigned int minlen, maxlen, ft_min;
+	/* minlen is only 5 bits, and round minlen to multiple of 2 */
+	if (timing->minlen < 30)
+		minlen = timing->minlen & -2;
+	else
+		minlen = 30;
+	/* maxlen has maximum value of 48, and round maxlen to multiple of 2 */
+	if (timing->maxlen < 48)
+		maxlen = (timing->maxlen + 1) & -2;
+	else
+		maxlen = 48;
+	/* convert and shift ft_min, rounding upwards */
+	ft_min = (timing->ft_min*clock_hz + 999999) / 1000000;
+	ft_min = (ft_min + 7) >> 3;
+	/* construct register value */
+	return	(timing->maxlen	<< IMG_IR_MAXLEN_SHIFT)	|
+		(timing->minlen	<< IMG_IR_MINLEN_SHIFT)	|
+		(ft_min		<< IMG_IR_FT_MIN_SHIFT);
+}
+
+/**
+ * img_ir_free_timing_dynamic() - Update free time register value.
+ * @st_ft:	Static free time register value from img_ir_free_timing.
+ * @filter:	Current filter which may additionally restrict min/max len.
+ *
+ * Returns:	Updated free time register value based on the current filter.
+ */
+static u32 img_ir_free_timing_dynamic(u32 st_ft, struct img_ir_filter *filter)
+{
+	unsigned int minlen, maxlen, newminlen, newmaxlen;
+
+	/* round minlen, maxlen to multiple of 2 */
+	newminlen = filter->minlen & -2;
+	newmaxlen = (filter->maxlen + 1) & -2;
+	/* extract min/max len from register */
+	minlen = (st_ft & IMG_IR_MINLEN) >> IMG_IR_MINLEN_SHIFT;
+	maxlen = (st_ft & IMG_IR_MAXLEN) >> IMG_IR_MAXLEN_SHIFT;
+	/* if the new values are more restrictive, update the register value */
+	if (newminlen > minlen) {
+		st_ft &= ~IMG_IR_MINLEN;
+		st_ft |= newminlen << IMG_IR_MINLEN_SHIFT;
+	}
+	if (newmaxlen < maxlen) {
+		st_ft &= ~IMG_IR_MAXLEN;
+		st_ft |= newmaxlen << IMG_IR_MAXLEN_SHIFT;
+	}
+	return st_ft;
+}
+
+/**
+ * img_ir_timings_convert() - Convert timings to register values
+ * @regs:	Output timing register values
+ * @timings:	Input timing data
+ * @tolerance:	Timing tolerance where 0-128 represents 0-100%
+ * @clock_hz:	Source clock frequency in Hz
+ */
+static void img_ir_timings_convert(struct img_ir_timing_regvals *regs,
+				   const struct img_ir_timings *timings,
+				   unsigned int tolerance,
+				   unsigned int clock_hz)
+{
+	/* leader symbol timings are divided by 16 */
+	regs->ldr = img_ir_symbol_timing(&timings->ldr, tolerance, clock_hz,
+			4, 4);
+	/* other symbol timings, pd fields only are divided by 2 */
+	regs->s00 = img_ir_symbol_timing(&timings->s00, tolerance, clock_hz,
+			1, 0);
+	regs->s01 = img_ir_symbol_timing(&timings->s01, tolerance, clock_hz,
+			1, 0);
+	regs->s10 = img_ir_symbol_timing(&timings->s10, tolerance, clock_hz,
+			1, 0);
+	regs->s11 = img_ir_symbol_timing(&timings->s11, tolerance, clock_hz,
+			1, 0);
+	regs->ft = img_ir_free_timing(&timings->ft, clock_hz);
+}
+
+/**
+ * img_ir_decoder_preprocess() - Preprocess timings in decoder.
+ * @decoder:	Decoder to be preprocessed.
+ *
+ * Ensures that the symbol timing ranges are valid with respect to ordering, and
+ * does some fixed conversion on them.
+ */
+static void img_ir_decoder_preprocess(struct img_ir_decoder *decoder)
+{
+	/* fill in implicit fields */
+	img_ir_timings_preprocess(&decoder->timings, decoder->unit);
+
+	/* do the same for repeat timings if applicable */
+	if (decoder->repeat) {
+		img_ir_timings_preprocess(&decoder->rtimings, decoder->unit);
+		img_ir_timings_defaults(&decoder->rtimings, &decoder->timings);
+	}
+
+	/* calculate control value */
+	decoder->reg_ctrl = img_ir_control(&decoder->control);
+}
+
+/**
+ * img_ir_decoder_convert() - Generate internal timings in decoder.
+ * @decoder:	Decoder to be converted to internal timings.
+ * @tolerance:	Tolerance as percent.
+ * @clock_hz:	IR clock rate in Hz.
+ *
+ * Fills out the repeat timings and timing register values for a specific
+ * tolerance and clock rate.
+ */
+static void img_ir_decoder_convert(struct img_ir_decoder *decoder,
+				   unsigned int tolerance,
+				   unsigned int clock_hz)
+{
+	tolerance = tolerance * 128 / 100;
+
+	/* record clock rate in case timings need recalculating */
+	decoder->clk_hz = clock_hz;
+
+	/* fill in implicit fields and calculate register values */
+	img_ir_timings_convert(&decoder->reg_timings, &decoder->timings,
+			       tolerance, clock_hz);
+
+	/* do the same for repeat timings if applicable */
+	if (decoder->repeat)
+		img_ir_timings_convert(&decoder->reg_rtimings,
+				       &decoder->rtimings, tolerance, clock_hz);
+}
+
+/**
+ * img_ir_decoder_check_timings() - Check if decoder timings need updating.
+ * @priv:	IR private data.
+ */
+static void img_ir_check_timings(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct img_ir_decoder *dec = hw->decoder;
+	if (dec->clk_hz != hw->clk_hz) {
+		dev_dbg(priv->dev, "converting tolerance=%d%%, clk=%lu\n",
+			10, hw->clk_hz);
+		img_ir_decoder_convert(dec, 10, hw->clk_hz);
+	}
+}
+
+/**
+ * img_ir_write_timings() - Write timings to the hardware now
+ * @priv:	IR private data
+ * @regs:	Timing register values to write
+ * @filter:	Current filter data or NULL
+ *
+ * Write timing register values @regs to the hardware, taking into account the
+ * current filter pointed to by @filter which may impose restrictions on the
+ * length of the expected data.
+ */
+static void img_ir_write_timings(struct img_ir_priv *priv,
+				 struct img_ir_timing_regvals *regs,
+				 struct img_ir_filter *filter)
+{
+	/* filter may be more restrictive to minlen, maxlen */
+	u32 ft = regs->ft;
+	if (filter)
+		ft = img_ir_free_timing_dynamic(regs->ft, filter);
+	/* write to registers */
+	img_ir_write(priv, IMG_IR_LEAD_SYMB_TIMING, regs->ldr);
+	img_ir_write(priv, IMG_IR_S00_SYMB_TIMING, regs->s00);
+	img_ir_write(priv, IMG_IR_S01_SYMB_TIMING, regs->s01);
+	img_ir_write(priv, IMG_IR_S10_SYMB_TIMING, regs->s10);
+	img_ir_write(priv, IMG_IR_S11_SYMB_TIMING, regs->s11);
+	img_ir_write(priv, IMG_IR_FREE_SYMB_TIMING, ft);
+	dev_dbg(priv->dev, "timings: ldr=%#x, s=[%#x, %#x, %#x, %#x], ft=%#x\n",
+		regs->ldr, regs->s00, regs->s01, regs->s10, regs->s11, ft);
+}
+
+/**
+ * img_ir_write_timings_normal() - Write normal timings to the hardware now
+ * @priv:	IR private data
+ * @regs:	Normal timing register values to write
+ *
+ * Write the normal (non-wake) timing register values @regs to the hardware,
+ * taking into account the current filter.
+ */
+static void img_ir_write_timings_normal(struct img_ir_priv *priv,
+					struct img_ir_timing_regvals *regs)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct img_ir_filter *filter = NULL;
+	if (hw->flags & IMG_IR_F_FILTER)
+		filter = &hw->filter;
+	img_ir_write_timings(priv, regs, filter);
+}
+
+#ifdef CONFIG_PM_SLEEP
+/**
+ * img_ir_write_timings_wake() - Write wake timings to the hardware now
+ * @priv:	IR private data
+ * @regs:	Wake timing register values to write
+ *
+ * Write the wake timing register values @regs to the hardware, taking into
+ * account the current wake filter.
+ */
+static void img_ir_write_timings_wake(struct img_ir_priv *priv,
+				      struct img_ir_timing_regvals *regs)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct img_ir_filter *filter = NULL;
+	if (hw->flags & IMG_IR_F_WAKE)
+		filter = &hw->wake_filter;
+	img_ir_write_timings(priv, regs, filter);
+}
+#endif
+
+static void img_ir_write_filter(struct img_ir_priv *priv,
+				struct img_ir_filter *filter)
+{
+	if (filter) {
+		dev_dbg(priv->dev, "IR filter=%016llx & %016llx\n",
+			(unsigned long long)filter->data,
+			(unsigned long long)filter->mask);
+		img_ir_write(priv, IMG_IR_IRQ_MSG_DATA_LW, (u32)filter->data);
+		img_ir_write(priv, IMG_IR_IRQ_MSG_DATA_UP, (u32)(filter->data
+									>> 32));
+		img_ir_write(priv, IMG_IR_IRQ_MSG_MASK_LW, (u32)filter->mask);
+		img_ir_write(priv, IMG_IR_IRQ_MSG_MASK_UP, (u32)(filter->mask
+									>> 32));
+	} else {
+		dev_dbg(priv->dev, "IR clearing filter\n");
+		img_ir_write(priv, IMG_IR_IRQ_MSG_MASK_LW, 0);
+		img_ir_write(priv, IMG_IR_IRQ_MSG_MASK_UP, 0);
+	}
+}
+
+/* caller must have lock */
+static void _img_ir_set_filter(struct img_ir_priv *priv,
+			       struct img_ir_filter *filter)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	u32 irq_en, irq_on;
+
+	irq_en = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+	if (filter) {
+		/* Only use the match interrupt */
+		hw->filter = *filter;
+		hw->flags |= IMG_IR_F_FILTER;
+		irq_on = IMG_IR_IRQ_DATA_MATCH;
+		irq_en &= ~(IMG_IR_IRQ_DATA_VALID | IMG_IR_IRQ_DATA2_VALID);
+	} else {
+		/* Only use the valid interrupt */
+		hw->flags &= ~IMG_IR_F_FILTER;
+		irq_en &= ~IMG_IR_IRQ_DATA_MATCH;
+		irq_on = IMG_IR_IRQ_DATA_VALID | IMG_IR_IRQ_DATA2_VALID;
+	}
+	irq_en |= irq_on;
+
+	img_ir_write_filter(priv, filter);
+	/* clear any interrupts we're enabling so we don't handle old ones */
+	img_ir_write(priv, IMG_IR_IRQ_CLEAR, irq_on);
+	img_ir_write(priv, IMG_IR_IRQ_ENABLE, irq_en);
+}
+
+/* caller must have lock */
+static void _img_ir_set_wake_filter(struct img_ir_priv *priv,
+				    struct img_ir_filter *filter)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	if (filter) {
+		/* Enable wake, and copy filter for later */
+		hw->wake_filter = *filter;
+		hw->flags |= IMG_IR_F_WAKE;
+	} else {
+		/* Disable wake */
+		hw->flags &= ~IMG_IR_F_WAKE;
+	}
+}
+
+/* caller must have lock */
+static void _img_ir_update_filters(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct img_ir_filter filter;
+	int ret1 = -1, ret2 = -1;
+
+	/* clear raw filters */
+	_img_ir_set_filter(priv, NULL);
+	_img_ir_set_wake_filter(priv, NULL);
+
+	/* convert scancode filters to raw filters and try to set them */
+	if (hw->decoder && hw->decoder->filter) {
+		if (hw->sc_filter.mask) {
+			filter.minlen = 0;
+			filter.maxlen = ~0;
+			dev_dbg(priv->dev, "IR scancode filter=%08x & %08x\n",
+				hw->sc_filter.data,
+				hw->sc_filter.mask);
+			ret1 = hw->decoder->filter(&hw->sc_filter, &filter,
+						     hw->enabled_protocols);
+			if (!ret1) {
+				dev_dbg(priv->dev, "IR raw filter=%016llx & %016llx\n",
+					(unsigned long long)filter.data,
+					(unsigned long long)filter.mask);
+				_img_ir_set_filter(priv, &filter);
+			}
+		}
+		if (hw->sc_wake_filter.mask) {
+			filter.minlen = 0;
+			filter.maxlen = ~0;
+			dev_dbg(priv->dev, "IR scancode wake filter=%08x & %08x\n",
+				hw->sc_wake_filter.data,
+				hw->sc_wake_filter.mask);
+			ret2 = hw->decoder->filter(&hw->sc_wake_filter,
+						     &filter,
+						     hw->enabled_protocols);
+			if (!ret2) {
+				dev_dbg(priv->dev, "IR raw wake filter=%016llx & %016llx\n",
+					(unsigned long long)filter.data,
+					(unsigned long long)filter.mask);
+				_img_ir_set_wake_filter(priv, &filter);
+			}
+		}
+	}
+
+	/*
+	 * if either of the filters couldn't get set, clear the corresponding
+	 * scancode filter mask.
+	 */
+	if (ret1)
+		hw->sc_filter.mask = 0;
+	if (ret2)
+		hw->sc_wake_filter.mask = 0;
+}
+
+static void img_ir_update_filters(struct img_ir_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	_img_ir_update_filters(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+/**
+ * img_ir_set_decoder() - Set the current decoder.
+ * @priv:	IR private data.
+ * @decoder:	Decoder to use with immediate effect.
+ * @proto:	Protocol bitmap (or 0 to use decoder->type).
+ */
+static void img_ir_set_decoder(struct img_ir_priv *priv,
+			       struct img_ir_decoder *decoder,
+			       u64 proto)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	unsigned long flags;
+	u32 ir_status, irq_en;
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* switch off and disable interrupts */
+	img_ir_write(priv, IMG_IR_CONTROL, 0);
+	irq_en = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+	img_ir_write(priv, IMG_IR_IRQ_ENABLE, irq_en & IMG_IR_IRQ_EDGE);
+	img_ir_write(priv, IMG_IR_IRQ_CLEAR, IMG_IR_IRQ_ALL & ~IMG_IR_IRQ_EDGE);
+
+	/* ack any data already detected */
+	ir_status = img_ir_read(priv, IMG_IR_STATUS);
+	if (ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)) {
+		ir_status &= ~(IMG_IR_RXDVAL | IMG_IR_RXDVALD2);
+		img_ir_write(priv, IMG_IR_STATUS, ir_status);
+		img_ir_read(priv, IMG_IR_DATA_LW);
+		img_ir_read(priv, IMG_IR_DATA_UP);
+	}
+
+	/* clear the scancode filters */
+	hw->sc_filter.data = 0;
+	hw->sc_filter.mask = 0;
+	hw->sc_wake_filter.data = 0;
+	hw->sc_wake_filter.mask = 0;
+
+	/* update (clear) the raw filters */
+	_img_ir_update_filters(priv);
+
+	/* clear the enabled protocols */
+	hw->enabled_protocols = 0;
+
+	/* switch decoder */
+	hw->decoder = decoder;
+	if (!decoder)
+		goto unlock;
+
+	hw->mode = IMG_IR_M_NORMAL;
+
+	/* set the enabled protocols */
+	if (!proto)
+		proto = decoder->type;
+	hw->enabled_protocols = proto;
+
+	/* write the new timings */
+	img_ir_check_timings(priv);
+	img_ir_write_timings_normal(priv, &decoder->reg_timings);
+
+	/* set up and enable */
+	img_ir_write(priv, IMG_IR_CONTROL, decoder->reg_ctrl);
+
+
+unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+/**
+ * img_ir_decoder_compatable() - Find whether a decoder will work with a device.
+ * @priv:	IR private data.
+ * @dec:	Decoder to check.
+ *
+ * Returns:	true if @dec is compatible with the device @priv refers to.
+ */
+static bool img_ir_decoder_compatible(struct img_ir_priv *priv,
+				      struct img_ir_decoder *dec)
+{
+	unsigned int ct;
+
+	/* don't accept decoders using code types which aren't supported */
+	ct = dec->control.code_type;
+	if (priv->hw.ct_quirks[ct] & IMG_IR_QUIRK_CODE_BROKEN)
+		return false;
+
+	return true;
+}
+
+/**
+ * img_ir_allowed_protos() - Get allowed protocols from global decoder list.
+ * @priv:	IR private data.
+ *
+ * img_ir_decoders_lock must be locked by caller.
+ *
+ * Returns:	Mask of protocols supported by the device @priv refers to.
+ */
+static unsigned long img_ir_allowed_protos(struct img_ir_priv *priv)
+{
+	unsigned long protos = 0;
+	struct img_ir_decoder *dec;
+
+	for (dec = img_ir_decoders; dec; dec = dec->next)
+		if (img_ir_decoder_compatible(priv, dec))
+			protos |= dec->type;
+	return protos;
+}
+
+/**
+ * img_ir_update_allowed_protos() - Update devices with allowed protocols.
+ *
+ * img_ir_decoders_lock must be locked by caller.
+ */
+static void img_ir_update_allowed_protos(void)
+{
+	struct img_ir_priv *priv;
+
+	for (priv = img_ir_privs; priv; priv = priv->next)
+		priv->hw.rdev->allowed_protos = img_ir_allowed_protos(priv);
+}
+
+/* Callback for changing protocol using sysfs */
+static int img_ir_change_protocol(struct rc_dev *data, u64 *ir_type)
+{
+	struct img_ir_priv *priv;
+	struct img_ir_decoder *dec;
+	int ret = -EINVAL;
+	priv = data->priv;
+
+	spin_lock(&img_ir_decoders_lock);
+	for (dec = img_ir_decoders; dec; dec = dec->next) {
+		if (!img_ir_decoder_compatible(priv, dec))
+			continue;
+		if (*ir_type & dec->type) {
+			*ir_type &= dec->type;
+			img_ir_set_decoder(priv, dec, *ir_type);
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock(&img_ir_decoders_lock);
+	return ret;
+}
+
+/* Changes ir-core protocol device attribute */
+static void img_ir_set_protocol(struct img_ir_priv *priv, u64 proto)
+{
+	struct rc_dev *ir_dev = priv->hw.rdev;
+
+	unsigned long flags;
+
+	spin_lock_irqsave(&ir_dev->rc_map.lock, flags);
+	ir_dev->rc_map.rc_type = proto;
+	spin_unlock_irqrestore(&ir_dev->rc_map.lock, flags);
+}
+
+/* Register an ir decoder */
+int img_ir_register_decoder(struct img_ir_decoder *dec)
+{
+	struct img_ir_priv *priv;
+
+	/* first preprocess decoder timings */
+	img_ir_decoder_preprocess(dec);
+
+	spin_lock(&img_ir_decoders_lock);
+	/* add to list */
+	dec->next = img_ir_decoders;
+	img_ir_decoders = dec;
+	img_ir_update_allowed_protos();
+	/* if it's the first decoder, start using it */
+	for (priv = img_ir_privs; priv; priv = priv->next) {
+		if (!priv->hw.decoder && img_ir_decoder_compatible(priv, dec)) {
+			img_ir_set_protocol(priv, dec->type);
+			img_ir_set_decoder(priv, dec, 0);
+		}
+	}
+	spin_unlock(&img_ir_decoders_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(img_ir_register_decoder);
+
+/* Unregister an ir decoder */
+void img_ir_unregister_decoder(struct img_ir_decoder *dec)
+{
+	struct img_ir_priv *priv;
+
+	spin_lock(&img_ir_decoders_lock);
+	/* If the decoder is in use, stop it now */
+	for (priv = img_ir_privs; priv; priv = priv->next)
+		if (priv->hw.decoder == dec) {
+			img_ir_set_protocol(priv, 0);
+			img_ir_set_decoder(priv, NULL, 0);
+		}
+	/* Remove from list of decoders */
+	if (img_ir_decoders == dec) {
+		img_ir_decoders = dec->next;
+	} else {
+		struct img_ir_decoder *cur;
+		for (cur = img_ir_decoders; cur; cur = cur->next)
+			if (dec == cur->next) {
+				cur->next = dec->next;
+				dec->next = NULL;
+				break;
+			}
+	}
+	img_ir_update_allowed_protos();
+	spin_unlock(&img_ir_decoders_lock);
+}
+EXPORT_SYMBOL_GPL(img_ir_unregister_decoder);
+
+static void img_ir_register_device(struct img_ir_priv *priv)
+{
+	spin_lock(&img_ir_decoders_lock);
+	priv->next = img_ir_privs;
+	img_ir_privs = priv;
+	priv->hw.rdev->allowed_protos = img_ir_allowed_protos(priv);
+	spin_unlock(&img_ir_decoders_lock);
+}
+
+static void img_ir_unregister_device(struct img_ir_priv *priv)
+{
+	struct img_ir_priv *cur;
+
+	spin_lock(&img_ir_decoders_lock);
+	if (img_ir_privs == priv)
+		img_ir_privs = priv->next;
+	else
+		for (cur = img_ir_privs; cur; cur = cur->next)
+			if (cur->next == priv) {
+				cur->next = priv->next;
+				break;
+			}
+	img_ir_set_decoder(priv, NULL, 0);
+	spin_unlock(&img_ir_decoders_lock);
+}
+
+#ifdef CONFIG_PM_SLEEP
+/**
+ * img_ir_enable_wake() - Switch to wake mode.
+ * @priv:	IR private data.
+ *
+ * Returns:	non-zero if the IR can wake the system.
+ */
+static int img_ir_enable_wake(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (hw->flags & IMG_IR_F_WAKE) {
+		/* interrupt only on a match */
+		hw->suspend_irqen = img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+		img_ir_write(priv, IMG_IR_IRQ_ENABLE, IMG_IR_IRQ_DATA_MATCH);
+		img_ir_write_filter(priv, &hw->wake_filter);
+		img_ir_write_timings_wake(priv, &hw->decoder->reg_timings);
+		hw->mode = IMG_IR_M_WAKE;
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+
+/**
+ * img_ir_disable_wake() - Switch out of wake mode.
+ * @priv:	IR private data
+ *
+ * Returns:	1 if the hardware should be allowed to wake from a sleep state.
+ *		0 otherwise.
+ */
+static int img_ir_disable_wake(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (hw->flags & IMG_IR_F_WAKE) {
+		/* restore normal filtering */
+		if (hw->flags & IMG_IR_F_FILTER) {
+			img_ir_write(priv, IMG_IR_IRQ_ENABLE,
+				     (hw->suspend_irqen & IMG_IR_IRQ_EDGE) |
+				     IMG_IR_IRQ_DATA_MATCH);
+			img_ir_write_filter(priv, &hw->filter);
+		} else {
+			img_ir_write(priv, IMG_IR_IRQ_ENABLE,
+				     (hw->suspend_irqen & IMG_IR_IRQ_EDGE) |
+				     IMG_IR_IRQ_DATA_VALID |
+				     IMG_IR_IRQ_DATA2_VALID);
+			img_ir_write_filter(priv, NULL);
+		}
+		img_ir_write_timings_normal(priv, &hw->decoder->reg_timings);
+		hw->mode = IMG_IR_M_NORMAL;
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+/* lock must be held */
+static void img_ir_begin_repeat(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	if (hw->mode == IMG_IR_M_NORMAL) {
+		struct img_ir_decoder *dec = hw->decoder;
+
+		/* switch to repeat timings */
+		img_ir_write(priv, IMG_IR_CONTROL, 0);
+		hw->mode = IMG_IR_M_REPEATING;
+		img_ir_write_timings_normal(priv, &dec->reg_rtimings);
+		img_ir_write(priv, IMG_IR_CONTROL, dec->reg_ctrl);
+	}
+}
+
+/* lock must be held */
+static void img_ir_end_repeat(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	if (hw->mode == IMG_IR_M_REPEATING) {
+		struct img_ir_decoder *dec = hw->decoder;
+
+		/* switch to normal timings */
+		img_ir_write(priv, IMG_IR_CONTROL, 0);
+		hw->mode = IMG_IR_M_NORMAL;
+		img_ir_write_timings_normal(priv, &dec->reg_timings);
+		img_ir_write(priv, IMG_IR_CONTROL, dec->reg_ctrl);
+	}
+}
+
+/* lock must be held */
+static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct img_ir_decoder *dec = hw->decoder;
+	int scancode = IMG_IR_ERR_INVALID;
+	if (dec->scancode)
+		scancode = dec->scancode(len, raw, hw->enabled_protocols);
+	else if (len >= 32)
+		scancode = (u32)raw;
+	else if (len < 32)
+		scancode = (u32)raw & ((1 << len)-1);
+	dev_dbg(priv->dev, "data (%u bits) = %#llx\n",
+		len, (unsigned long long)raw);
+	if (scancode >= 0) {
+		dev_dbg(priv->dev, "decoded scan code %#x\n", scancode);
+		rc_keydown(hw->rdev, scancode, 0);
+		img_ir_end_repeat(priv);
+	} else if (scancode == IMG_IR_REPEATCODE) {
+		if (hw->mode == IMG_IR_M_REPEATING) {
+			dev_dbg(priv->dev, "decoded repeat code\n");
+			rc_repeat(hw->rdev);
+		} else {
+			dev_dbg(priv->dev, "decoded unexpected repeat code, ignoring\n");
+		}
+	} else {
+		return;
+	}
+
+
+	if (dec->repeat) {
+		unsigned long interval;
+
+		img_ir_begin_repeat(priv);
+
+		/* update timer, but allowing for 1/8th tolerance */
+		interval = dec->repeat + (dec->repeat >> 3);
+		mod_timer(&hw->end_timer,
+			  jiffies + msecs_to_jiffies(interval));
+	}
+}
+
+/* timer function to end waiting for repeat. */
+static void img_ir_end_timer(unsigned long arg)
+{
+	unsigned long flags;
+	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	img_ir_end_repeat(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+/* Kernel interface */
+
+static ssize_t img_ir_filter_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+
+	return sprintf(buf, "%#x\n", priv->hw.sc_filter.data);
+}
+static ssize_t img_ir_filter_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+	int ret;
+	unsigned long val;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+	priv->hw.sc_filter.data = val;
+	img_ir_update_filters(priv);
+	return count;
+}
+static DEVICE_ATTR(filter, S_IRUGO|S_IWUSR,
+		   img_ir_filter_show,
+		   img_ir_filter_store);
+
+static ssize_t img_ir_filter_mask_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+
+	return sprintf(buf, "%#x\n", priv->hw.sc_filter.mask);
+}
+static ssize_t img_ir_filter_mask_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+	int ret;
+	unsigned long val;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+	priv->hw.sc_filter.mask = val;
+	img_ir_update_filters(priv);
+	return count;
+}
+static DEVICE_ATTR(filter_mask, S_IRUGO|S_IWUSR,
+		   img_ir_filter_mask_show,
+		   img_ir_filter_mask_store);
+
+static ssize_t img_ir_wakeup_filter_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+
+	return sprintf(buf, "%#x\n", priv->hw.sc_wake_filter.data);
+}
+static ssize_t img_ir_wakeup_filter_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+	int ret;
+	unsigned long val;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+	priv->hw.sc_wake_filter.data = val;
+	img_ir_update_filters(priv);
+	return count;
+}
+static DEVICE_ATTR(wakeup_filter, S_IRUGO|S_IWUSR,
+		   img_ir_wakeup_filter_show,
+		   img_ir_wakeup_filter_store);
+
+static ssize_t img_ir_wakeup_filter_mask_show(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+
+	return sprintf(buf, "%#x\n", priv->hw.sc_wake_filter.mask);
+}
+static ssize_t img_ir_wakeup_filter_mask_store(struct device *dev,
+					       struct device_attribute *attr,
+					       const char *buf, size_t count)
+{
+	struct rc_dev *rdev = container_of(dev, struct rc_dev, dev);
+	struct img_ir_priv *priv = rdev->priv;
+	int ret;
+	unsigned long val;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+	priv->hw.sc_wake_filter.mask = val;
+	img_ir_update_filters(priv);
+	return count;
+}
+static DEVICE_ATTR(wakeup_filter_mask, S_IRUGO|S_IWUSR,
+		   img_ir_wakeup_filter_mask_show,
+		   img_ir_wakeup_filter_mask_store);
+
+static void img_ir_attr_create(struct device *dev)
+{
+	device_create_file(dev, &dev_attr_filter);
+	device_create_file(dev, &dev_attr_filter_mask);
+	device_create_file(dev, &dev_attr_wakeup_filter);
+	device_create_file(dev, &dev_attr_wakeup_filter_mask);
+}
+
+static void img_ir_attr_remove(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_filter);
+	device_remove_file(dev, &dev_attr_filter_mask);
+	device_remove_file(dev, &dev_attr_wakeup_filter);
+	device_remove_file(dev, &dev_attr_wakeup_filter_mask);
+}
+
+#ifdef CONFIG_COMMON_CLK
+static void img_ir_change_frequency(struct img_ir_priv *priv,
+				    struct clk_notifier_data *change)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct img_ir_decoder *dec;
+	unsigned long flags;
+
+	dev_dbg(priv->dev, "clk changed %lu HZ -> %lu HZ\n",
+		change->old_rate, change->new_rate);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	dec = hw->decoder;
+	hw->clk_hz = change->new_rate;
+	/* refresh current timings */
+	if (hw->decoder) {
+		img_ir_check_timings(priv);
+		switch (hw->mode) {
+		case IMG_IR_M_NORMAL:
+			img_ir_write_timings_normal(priv, &dec->reg_timings);
+			break;
+		case IMG_IR_M_REPEATING:
+			img_ir_write_timings_normal(priv, &dec->reg_rtimings);
+			break;
+#ifdef CONFIG_PM_SLEEP
+		case IMG_IR_M_WAKE:
+			img_ir_write_timings_wake(priv, &dec->reg_timings);
+			break;
+#endif
+		}
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static int img_ir_clk_notify(struct notifier_block *self, unsigned long action,
+			     void *data)
+{
+	struct img_ir_priv *priv = container_of(self, struct img_ir_priv,
+						hw.clk_nb);
+	switch (action) {
+	case POST_RATE_CHANGE:
+		img_ir_change_frequency(priv, data);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+#endif /* CONFIG_COMMON_CLK */
+
+void img_ir_isr_hw(struct img_ir_priv *priv, u32 irq_status)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	u32 ir_status, len, lw, up;
+	unsigned int ct;
+
+	/* use the current decoder */
+	if (!hw->decoder)
+		return;
+
+	ir_status = img_ir_read(priv, IMG_IR_STATUS);
+	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)))
+		return;
+	ir_status &= ~(IMG_IR_RXDVAL | IMG_IR_RXDVALD2);
+	img_ir_write(priv, IMG_IR_STATUS, ir_status);
+
+	len = (ir_status & IMG_IR_RXDLEN) >> IMG_IR_RXDLEN_SHIFT;
+	/* some versions report wrong length for certain code types */
+	ct = hw->decoder->control.code_type;
+	if (hw->ct_quirks[ct] & IMG_IR_QUIRK_CODE_LEN_INCR)
+		++len;
+
+	lw = img_ir_read(priv, IMG_IR_DATA_LW);
+	up = img_ir_read(priv, IMG_IR_DATA_UP);
+	img_ir_handle_data(priv, len, (u64)up << 32 | lw);
+}
+
+void img_ir_setup_hw(struct img_ir_priv *priv)
+{
+	struct img_ir_decoder *dec;
+
+	if (!priv->hw.rdev)
+		return;
+
+	spin_lock(&img_ir_decoders_lock);
+	/* Use the first available decoder (or disable stuff if NULL) */
+	for (dec = img_ir_decoders; dec; dec = dec->next) {
+		if (img_ir_decoder_compatible(priv, dec)) {
+			img_ir_set_protocol(priv, dec->type);
+			img_ir_set_decoder(priv, dec, 0);
+			goto unlock;
+		}
+	}
+	img_ir_set_decoder(priv, NULL, 0);
+unlock:
+	spin_unlock(&img_ir_decoders_lock);
+}
+
+/**
+ * img_ir_probe_hw_caps() - Probe capabilities of the hardware.
+ * @priv:	IR private data.
+ */
+static void img_ir_probe_hw_caps(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	/*
+	 * When a version of the block becomes available without these quirks,
+	 * they'll have to depend on the core revision.
+	 */
+	hw->ct_quirks[IMG_IR_CODETYPE_PULSELEN]
+		|= IMG_IR_QUIRK_CODE_LEN_INCR;
+	hw->ct_quirks[IMG_IR_CODETYPE_BIPHASE]
+		|= IMG_IR_QUIRK_CODE_BROKEN;
+	hw->ct_quirks[IMG_IR_CODETYPE_2BITPULSEPOS]
+		|= IMG_IR_QUIRK_CODE_BROKEN;
+}
+
+int img_ir_probe_hw(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct rc_dev *rdev;
+	int error;
+
+	/* Probe hardware capabilities */
+	img_ir_probe_hw_caps(priv);
+
+	/* Set up the end timer */
+	init_timer(&hw->end_timer);
+	hw->end_timer.function = img_ir_end_timer;
+	hw->end_timer.data = (unsigned long)priv;
+
+	/* Register a clock notifier */
+	if (!IS_ERR(priv->clk)) {
+		hw->clk_hz = clk_get_rate(priv->clk);
+#ifdef CONFIG_COMMON_CLK
+		hw->clk_nb.notifier_call = img_ir_clk_notify;
+		error = clk_notifier_register(priv->clk, &hw->clk_nb);
+		if (error)
+			dev_warn(priv->dev,
+				 "failed to register clock notifier\n");
+#endif
+	} else {
+		hw->clk_hz = 32768;
+	}
+
+	/* Allocate hardware decoder */
+	hw->rdev = rdev = rc_allocate_device();
+	if (!rdev) {
+		dev_err(priv->dev, "cannot allocate input device\n");
+		error = -ENOMEM;
+		goto err_alloc_rc;
+	}
+	rdev->priv = priv;
+	rdev->map_name = RC_MAP_EMPTY;
+	rdev->input_name = "IMG Infrared Decoder";
+	/* img_ir_register_device sets rdev->allowed_protos. */
+	img_ir_register_device(priv);
+
+	/* Register hardware decoder */
+	error = rc_register_device(rdev);
+	if (error) {
+		dev_err(priv->dev, "failed to register IR input device\n");
+		goto err_register_rc;
+	}
+
+	/*
+	 * Set this after rc_register_device as no protocols have been
+	 * registered yet.
+	 */
+	rdev->change_protocol = img_ir_change_protocol;
+
+	device_init_wakeup(priv->dev, 1);
+
+	/* Create custom sysfs attributes */
+	img_ir_attr_create(&rdev->dev);
+
+	return 0;
+
+err_register_rc:
+	img_ir_unregister_device(priv);
+	hw->rdev = NULL;
+	rc_free_device(rdev);
+err_alloc_rc:
+#ifdef CONFIG_COMMON_CLK
+	if (!IS_ERR(priv->clk))
+		clk_notifier_unregister(priv->clk, &hw->clk_nb);
+#endif
+	return error;
+}
+
+void img_ir_remove_hw(struct img_ir_priv *priv)
+{
+	struct img_ir_priv_hw *hw = &priv->hw;
+	struct rc_dev *rdev = hw->rdev;
+	if (!rdev)
+		return;
+	img_ir_attr_remove(&rdev->dev);
+	img_ir_unregister_device(priv);
+	hw->rdev = NULL;
+	rc_unregister_device(rdev);
+#ifdef CONFIG_COMMON_CLK
+	if (!IS_ERR(priv->clk))
+		clk_notifier_unregister(priv->clk, &hw->clk_nb);
+#endif
+}
+
+#ifdef CONFIG_PM_SLEEP
+int img_ir_suspend(struct device *dev)
+{
+	struct img_ir_priv *priv = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev) && img_ir_enable_wake(priv))
+		enable_irq_wake(priv->irq);
+	return 0;
+}
+
+int img_ir_resume(struct device *dev)
+{
+	struct img_ir_priv *priv = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev) && img_ir_disable_wake(priv))
+		disable_irq_wake(priv->irq);
+	return 0;
+}
+#endif	/* CONFIG_PM_SLEEP */
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
new file mode 100644
index 000000000000..0fb8e48fda3a
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -0,0 +1,284 @@
+/*
+ * ImgTec IR Hardware Decoder found in PowerDown Controller.
+ *
+ * Copyright 2010-2013 Imagination Technologies Ltd.
+ */
+
+#ifndef _IMG_IR_HW_H_
+#define _IMG_IR_HW_H_
+
+#include <linux/kernel.h>
+#include <media/rc-core.h>
+
+/* constants */
+
+#define IMG_IR_CODETYPE_PULSELEN	0x0	/* Sony */
+#define IMG_IR_CODETYPE_PULSEDIST	0x1	/* NEC, Toshiba, Micom, Sharp */
+#define IMG_IR_CODETYPE_BIPHASE		0x2	/* RC-5/6 */
+#define IMG_IR_CODETYPE_2BITPULSEPOS	0x3	/* RC-MM */
+
+
+/* Timing information */
+
+/**
+ * struct img_ir_control - Decoder control settings
+ * @decoden:	Primary decoder enable
+ * @code_type:	Decode type (see IMG_IR_CODETYPE_*)
+ * @hdrtog:	Detect header toggle symbol after leader symbol
+ * @ldrdec:	Don't discard leader if maximum width reached
+ * @decodinpol:	Decoder input polarity (1=active high)
+ * @bitorien:	Bit orientation (1=MSB first)
+ * @d1validsel:	Decoder 2 takes over if it detects valid data
+ * @bitinv:	Bit inversion switch (1=don't invert)
+ * @decodend2:	Secondary decoder enable (no leader symbol)
+ * @bitoriend2:	Bit orientation (1=MSB first)
+ * @bitinvd2:	Secondary decoder bit inversion switch (1=don't invert)
+ */
+struct img_ir_control {
+	unsigned decoden:1;
+	unsigned code_type:2;
+	unsigned hdrtog:1;
+	unsigned ldrdec:1;
+	unsigned decodinpol:1;
+	unsigned bitorien:1;
+	unsigned d1validsel:1;
+	unsigned bitinv:1;
+	unsigned decodend2:1;
+	unsigned bitoriend2:1;
+	unsigned bitinvd2:1;
+};
+
+/**
+ * struct img_ir_timing_range - range of timing values
+ * @min:	Minimum timing value
+ * @max:	Maximum timing value (if < @min, this will be set to @min during
+ *		preprocessing step, so it is normally not explicitly initialised
+ *		and is taken care of by the tolerance)
+ */
+struct img_ir_timing_range {
+	u16 min;
+	u16 max;
+};
+
+/**
+ * struct img_ir_symbol_timing - timing data for a symbol
+ * @pulse:	Timing range for the length of the pulse in this symbol
+ * @space:	Timing range for the length of the space in this symbol
+ */
+struct img_ir_symbol_timing {
+	struct img_ir_timing_range pulse;
+	struct img_ir_timing_range space;
+};
+
+/**
+ * struct img_ir_free_timing - timing data for free time symbol
+ * @minlen:	Minimum number of bits of data
+ * @maxlen:	Maximum number of bits of data
+ * @ft_min:	Minimum free time after message
+ */
+struct img_ir_free_timing {
+	/* measured in bits */
+	u8 minlen;
+	u8 maxlen;
+	u16 ft_min;
+};
+
+/**
+ * struct img_ir_timings - Timing values.
+ * @ldr:	Leader symbol timing data
+ * @s00:	Zero symbol timing data for primary decoder
+ * @s01:	One symbol timing data for primary decoder
+ * @s10:	Zero symbol timing data for secondary (no leader symbol) decoder
+ * @s11:	One symbol timing data for secondary (no leader symbol) decoder
+ * @ft:		Free time symbol timing data
+ */
+struct img_ir_timings {
+	struct img_ir_symbol_timing ldr, s00, s01, s10, s11;
+	struct img_ir_free_timing ft;
+};
+
+/**
+ * struct img_ir_sc_filter - Filter scan codes.
+ * @data:	Data to match.
+ * @mask:	Mask of bits to compare.
+ */
+struct img_ir_sc_filter {
+	unsigned int data;
+	unsigned int mask;
+};
+
+/**
+ * struct img_ir_filter - Filter IR events.
+ * @data:	Data to match.
+ * @mask:	Mask of bits to compare.
+ * @minlen:	Additional minimum number of bits.
+ * @maxlen:	Additional maximum number of bits.
+ */
+struct img_ir_filter {
+	u64 data;
+	u64 mask;
+	u8 minlen;
+	u8 maxlen;
+};
+
+/**
+ * struct img_ir_timing_regvals - Calculated timing register values.
+ * @ldr:	Leader symbol timing register value
+ * @s00:	Zero symbol timing register value for primary decoder
+ * @s01:	One symbol timing register value for primary decoder
+ * @s10:	Zero symbol timing register value for secondary decoder
+ * @s11:	One symbol timing register value for secondary decoder
+ * @ft:		Free time symbol timing register value
+ */
+struct img_ir_timing_regvals {
+	u32 ldr, s00, s01, s10, s11, ft;
+};
+
+#define IMG_IR_REPEATCODE	(-1)	/* repeat the previous code */
+#define IMG_IR_ERR_INVALID	(-2)	/* not a valid code */
+
+/**
+ * struct img_ir_decoder - Decoder settings for an IR protocol.
+ * @type:		Protocol types bitmap.
+ * @unit:		Unit of timings in nanoseconds (default 1 us).
+ * @timings:		Primary timings
+ * @rtimings:		Additional override timings while waiting for repeats.
+ * @repeat:		Maximum repeat interval (always in milliseconds).
+ * @control:		Control flags.
+ *
+ * @scancode:		Pointer to function to convert the IR data into a
+ *			scancode (it must be safe to execute in interrupt
+ *			context).
+ *			Returns IMG_IR_REPEATCODE to repeat previous code.
+ *			Returns IMG_IR_ERR_* on error.
+ * @filter:		Pointer to function to convert scancode filter to raw
+ *			hardware filter. The minlen and maxlen fields will have
+ *			been initialised to the maximum range.
+ *
+ * @reg_ctrl:		Processed control register value.
+ * @clk_hz:		Assumed clock rate in Hz for processed timings.
+ * @reg_timings:	Processed primary timings.
+ * @reg_rtimings:	Processed repeat timings.
+ * @next:		Next IR decoder (to form a linked list).
+ */
+struct img_ir_decoder {
+	/* core description */
+	u64				type;
+	unsigned int			unit;
+	struct img_ir_timings		timings;
+	struct img_ir_timings		rtimings;
+	unsigned int			repeat;
+	struct img_ir_control		control;
+
+	/* scancode logic */
+	int (*scancode)(int len, u64 raw, u64 protocols);
+	int (*filter)(const struct img_ir_sc_filter *in,
+		      struct img_ir_filter *out, u64 protocols);
+
+	/* for internal use only */
+	u32				reg_ctrl;
+	unsigned long			clk_hz;
+	struct img_ir_timing_regvals	reg_timings;
+	struct img_ir_timing_regvals	reg_rtimings;
+	struct img_ir_decoder		*next;
+};
+
+int img_ir_register_decoder(struct img_ir_decoder *dec);
+void img_ir_unregister_decoder(struct img_ir_decoder *dec);
+
+struct img_ir_priv;
+
+#ifdef CONFIG_IR_IMG_HW
+
+enum img_ir_mode {
+	IMG_IR_M_NORMAL,
+	IMG_IR_M_REPEATING,
+#ifdef CONFIG_PM_SLEEP
+	IMG_IR_M_WAKE,
+#endif
+};
+
+/**
+ * struct img_ir_priv_hw - Private driver data for hardware decoder.
+ * @ct_quirks:		Quirk bits for each code type.
+ * @rdev:		Remote control device
+ * @clk_nb:		Notifier block for clock notify events.
+ * @end_timer:		Timer until repeat timeout.
+ * @decoder:		Current decoder settings.
+ * @enabled_protocols:	Currently enabled protocols.
+ * @clk_hz:		Current clock rate in Hz.
+ * @flags:		IMG_IR_F_*.
+ * @filter:		HW filter for normal events (derived from sc_filter).
+ * @wake_filter:	HW filter for wake event (derived from sc_wake_filter).
+ * @sc_filter:		Current scancode filter.
+ * @sc_wake_filter:	Current scancode filter for wake events.
+ * @mode:		Current decode mode.
+ * @suspend_irqen:	Saved IRQ enable mask over suspend.
+ */
+struct img_ir_priv_hw {
+	unsigned int		ct_quirks[4];
+	struct rc_dev		*rdev;
+	struct notifier_block	clk_nb;
+	struct timer_list	end_timer;
+	struct img_ir_decoder	*decoder;
+	u64			enabled_protocols;
+	unsigned long		clk_hz;
+	unsigned int		flags;
+	struct img_ir_filter	filter;
+	struct img_ir_filter	wake_filter;
+
+	/* filters in terms of scancodes */
+	struct img_ir_sc_filter	sc_filter;
+	struct img_ir_sc_filter	sc_wake_filter;
+
+	enum img_ir_mode	mode;
+	u32			suspend_irqen;
+};
+
+static inline bool img_ir_hw_enabled(struct img_ir_priv_hw *hw)
+{
+	return hw->rdev;
+};
+
+void img_ir_isr_hw(struct img_ir_priv *priv, u32 irq_status);
+void img_ir_setup_hw(struct img_ir_priv *priv);
+int img_ir_probe_hw(struct img_ir_priv *priv);
+void img_ir_remove_hw(struct img_ir_priv *priv);
+
+#ifdef CONFIG_PM_SLEEP
+int img_ir_suspend(struct device *dev);
+int img_ir_resume(struct device *dev);
+#else
+#define img_ir_suspend NULL
+#define img_ir_resume NULL
+#endif
+
+#else
+
+struct img_ir_priv_hw {
+};
+
+static inline bool img_ir_hw_enabled(struct img_ir_priv_hw *hw)
+{
+	return false;
+};
+static inline void img_ir_isr_hw(struct img_ir_priv *priv, u32 irq_status)
+{
+}
+static inline void img_ir_setup_hw(struct img_ir_priv *priv)
+{
+}
+static inline int img_ir_probe_hw(struct img_ir_priv *priv)
+{
+	return -ENODEV;
+}
+static inline void img_ir_remove_hw(struct img_ir_priv *priv)
+{
+}
+
+#define img_ir_suspend NULL
+#define img_ir_resume NULL
+
+#endif /* CONFIG_IR_IMG_HW */
+
+#endif /* _IMG_IR_HW_H_ */
-- 
1.8.1.2


