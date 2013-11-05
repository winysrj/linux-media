Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38903 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3KEPnm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 10:43:42 -0500
Received: by mail-pd0-f178.google.com with SMTP id x10so8571562pdj.23
        for <linux-media@vger.kernel.org>; Tue, 05 Nov 2013 07:43:41 -0800 (PST)
From: "=?UTF-8?q?=D0=B1=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: hdegoede@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com,
	=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE?=
	<knightrider@are.ma>
Subject: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T) cards
Date: Wed,  6 Nov 2013 00:43:00 +0900
Message-Id: <1383666180-9773-1-git-send-email-knightrider@are.ma>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто <knightrider@are.ma>

A DVB driver for Earthsoft PT3 (ISDB-S/T) receiver PCI Express cards, based on
1. PT3 chardev driver
	https://github.com/knight-rider/ptx/tree/master/pt3_drv
	https://github.com/m-tsudo/pt3
2. PT1/PT2 DVB driver
	./drivers/media/pci/pt1

It behaves similarly as PT1 DVB, plus some tuning enhancements:
1. in addition to the real frequency:
	ISDB-S : freq. channel ID
	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
2. in addition to TSID:
	ISDB-S : slot#

As requested, the following features have been removed:
- DKMS & standalone compile
- verbosity (debug levels), use single level -DDEBUG instead
- FE: SNR (.read_snr), use CNR (.read_signal_strength) instead

The full package (buildable as standalone, DKMS or mainstream embedded module) is available at
https://github.com/knight-rider/ptx/tree/master/pt3_dvb

Mauro Carvalho Chehab asked to put tuner code as an I2C driver, under drivers/media/tuners, frontends at drivers/media/dvb-
However, to keep package integrity & compatibility with PT1/PT2 user apps, FE etc. are still placed in the same directory.

--------------------------------------------------------------------

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 53196f1..2c90c34 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -30,7 +30,6 @@ source "drivers/media/pci/cx88/Kconfig"
 source "drivers/media/pci/bt8xx/Kconfig"
 source "drivers/media/pci/saa7134/Kconfig"
 source "drivers/media/pci/saa7164/Kconfig"
-
 endif
 
 if MEDIA_DIGITAL_TV_SUPPORT
@@ -40,6 +39,7 @@ source "drivers/media/pci/b2c2/Kconfig"
 source "drivers/media/pci/pluto2/Kconfig"
 source "drivers/media/pci/dm1105/Kconfig"
 source "drivers/media/pci/pt1/Kconfig"
+source "drivers/media/pci/pt3_dvb/Kconfig"
 source "drivers/media/pci/mantis/Kconfig"
 source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 35cc578..02c6857 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -7,6 +7,7 @@ obj-y        +=	ttpci/		\
 		pluto2/		\
 		dm1105/		\
 		pt1/		\
+		pt3_dvb/	\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
diff --git a/drivers/media/pci/pt3_dvb/Kconfig b/drivers/media/pci/pt3_dvb/Kconfig
new file mode 100644
index 0000000..f9ba00d
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/Kconfig
@@ -0,0 +1,12 @@
+config PT3_DVB
+	tristate "Earthsoft PT3 cards"
+	depends on DVB_CORE && PCI
+	help
+	  Support for Earthsoft PT3 PCI-Express cards.
+
+	  Since these cards have no MPEG decoder onboard, they transmit
+	  only compressed MPEG data over the PCI bus, so you need
+	  an external software decoder to watch TV on your computer.
+
+	  Say Y or M if you own such a device and want to use it.
+
diff --git a/drivers/media/pci/pt3_dvb/Makefile b/drivers/media/pci/pt3_dvb/Makefile
new file mode 100644
index 0000000..7087c90
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/Makefile
@@ -0,0 +1,6 @@
+pt3_dvb-objs := pt3.o pt3_fe.o pt3_dma.o pt3_tc.o pt3_i2c.o pt3_bus.o
+
+obj-$(CONFIG_PT3_DVB) += pt3_dvb.o
+
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
+
diff --git a/drivers/media/pci/pt3_dvb/pt3.c b/drivers/media/pci/pt3_dvb/pt3.c
new file mode 100644
index 0000000..11c1035
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/pt3.c
@@ -0,0 +1,540 @@
+#include "pt3.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
+MODULE_LICENSE("GPL");
+
+static DEFINE_PCI_DEVICE_TABLE(pt3_id_table) = {
+	{ PCI_DEVICE(0x1172, 0x4c15) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pt3_id_table);
+
+#define DRV_NAME "pt3_dvb"
+
+struct {
+	u32 bits;
+	char *str;
+} pt3_lnb[] = {
+	{0b1100,  "0V"},
+	{0b1101, "11V"},
+	{0b1111, "15V"},
+};
+
+static int pt3_update_lnb(struct pt3_board *pt3)
+{
+	u8 i, lnb_eff = 0;
+
+	if (pt3->reset) {
+		writel(pt3_lnb[0].bits, pt3->reg[0] + REG_SYSTEM_W);
+		pt3->reset = false;
+		pt3->lnb = 0;
+	} else {
+		struct pt3_adapter *adap;
+		mutex_lock(&pt3->lock);
+		for (i = 0; i < PT3_NR_ADAPS; i++) {
+			adap = pt3->adap[i];
+			pr_debug("#%d in_use %d sleep %d\n", adap->idx, adap->in_use, adap->sleep);
+			if ((adap->type == SYS_ISDBS) && (!adap->sleep)) {
+				lnb_eff |= adap->voltage == SEC_VOLTAGE_13 ? 1
+					:  adap->voltage == SEC_VOLTAGE_18 ? 2
+					:  lnb;
+			}
+		}
+		mutex_unlock(&pt3->lock);
+		if (unlikely(lnb_eff < 0 || 2 < lnb_eff)) {
+			pr_err("Inconsistent LNB settings\n");
+			return -EINVAL;
+		}
+		if (pt3->lnb != lnb_eff) {
+			writel(pt3_lnb[lnb_eff].bits, pt3->reg[0] + REG_SYSTEM_W);
+			pt3->lnb = lnb_eff;
+		}
+	}
+	pr_debug("LNB=%s\n", pt3_lnb[lnb_eff].str);
+	return 0;
+}
+
+void pt3_filter(struct pt3_adapter *adap, struct dvb_demux *demux, u8 *buf, size_t count)
+{
+	dvb_dmx_swfilter(demux, buf, count);
+}
+
+int pt3_thread(void *data)
+{
+	size_t ret;
+	struct pt3_adapter *adap = data;
+
+	set_freezable();
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+		while ((ret = pt3_dma_copy(adap->dma, &adap->demux)) > 0)
+			;
+		if (ret < 0) {
+			pr_debug("#%d fail dma_copy\n", adap->idx);
+			msleep_interruptible(1);
+		}
+	}
+	return 0;
+}
+
+static int pt3_start_polling(struct pt3_adapter *adap)
+{
+	int ret = 0;
+
+	mutex_lock(&adap->lock);
+	if (!adap->kthread) {
+		adap->kthread = kthread_run(pt3_thread, adap, DRV_NAME "_%d", adap->idx);
+		if (IS_ERR(adap->kthread)) {
+			ret = PTR_ERR(adap->kthread);
+			adap->kthread = NULL;
+		} else {
+			pt3_dma_set_test_mode(adap->dma, RESET, 0);	/* reset_error_count */
+			pt3_dma_set_enabled(adap->dma, true);
+		}
+	}
+	mutex_unlock(&adap->lock);
+	return ret;
+}
+
+static void pt3_stop_polling(struct pt3_adapter *adap)
+{
+	mutex_lock(&adap->lock);
+	if (adap->kthread) {
+		pt3_dma_set_enabled(adap->dma, false);
+		pr_debug("#%d DMA ts_err packet cnt %d\n",
+			adap->idx, pt3_dma_get_ts_error_packet_count(adap->dma));
+		kthread_stop(adap->kthread);
+		adap->kthread = NULL;
+	}
+	mutex_unlock(&adap->lock);
+}
+
+static int pt3_start_feed(struct dvb_demux_feed *feed)
+{
+	int ret;
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+	if (!adap->users++) {
+		if (adap->in_use) {
+			pr_err("#%d device is already used\n", adap->idx);
+			return -EIO;
+		}
+		pr_debug("#%d %s selected, DMA %s\n",
+			adap->idx, adap->str, pt3_dma_get_status(adap->dma) & 1 ? "ON" : "OFF");
+		adap->in_use = true;
+		ret = pt3_start_polling(adap);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int pt3_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+	if (!--adap->users) {
+		pt3_stop_polling(adap);
+		adap->in_use = false;
+		msleep_interruptible(40);
+	}
+	return 0;
+}
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static struct pt3_adapter *pt3_alloc_adapter(struct pt3_board *pt3)
+{
+	int ret;
+	struct dvb_adapter *dvb;
+	struct dvb_demux *demux;
+	struct dmxdev *dmxdev;
+	struct pt3_adapter *adap = kzalloc(sizeof(struct pt3_adapter), GFP_KERNEL);
+
+	if (!adap) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	adap->pt3 = pt3;
+	adap->voltage = SEC_VOLTAGE_OFF;
+	adap->sleep = true;
+
+	dvb = &adap->dvb;
+	dvb->priv = adap;
+	ret = dvb_register_adapter(dvb, DRV_NAME, THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+	if (ret < 0)
+		goto err_kfree;
+
+	demux = &adap->demux;
+	demux->dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
+	demux->priv = adap;
+	demux->feednum = 256;
+	demux->filternum = 256;
+	demux->start_feed = pt3_start_feed;
+	demux->stop_feed = pt3_stop_feed;
+	demux->write_to_decoder = NULL;
+	ret = dvb_dmx_init(demux);
+	if (ret < 0)
+		goto err_unregister_adapter;
+
+	dmxdev = &adap->dmxdev;
+	dmxdev->filternum = 256;
+	dmxdev->demux = &demux->dmx;
+	dmxdev->capabilities = 0;
+	ret = dvb_dmxdev_init(dmxdev, dvb);
+	if (ret < 0)
+		goto err_dmx_release;
+
+	return adap;
+
+err_dmx_release:
+	dvb_dmx_release(demux);
+err_unregister_adapter:
+	dvb_unregister_adapter(dvb);
+err_kfree:
+	kfree(adap);
+err:
+	return ERR_PTR(ret);
+}
+
+static int pt3_tuner_power_on(struct pt3_board *pt3, struct pt3_bus *bus)
+{
+	int ret, i, j;
+	struct pt3_ts_pins_mode pins;
+
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		ret = pt3_tc_init(pt3->adap[i]);
+		pr_debug("#%d tc_init ret=%d\n", i, ret);
+	}
+	ret = pt3_tc_set_powers(pt3->adap[PT3_NR_ADAPS-1], NULL, true, false);
+	if (ret) {
+		pr_debug("fail set powers.\n");
+		goto last;
+	}
+
+	pins.clock_data = PT3_TS_PIN_MODE_NORMAL;
+	pins.byte       = PT3_TS_PIN_MODE_NORMAL;
+	pins.valid      = PT3_TS_PIN_MODE_NORMAL;
+
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		ret = pt3_tc_set_ts_pins_mode(pt3->adap[i], &pins);
+		if (ret)
+			pr_debug("#%d %s fail set ts pins mode ret=%d\n", i, pt3->adap[i]->str, ret);
+	}
+	msleep_interruptible(1);
+
+	for (i = 0; i < PT3_NR_ADAPS; i++)
+		if (pt3->adap[i]->type == SYS_ISDBS) {
+			for (j = 0; j < 10; j++) {
+				if (j)
+					pr_debug("retry pt3_qm_tuner_init\n");
+				ret = pt3_qm_tuner_init(pt3->i2c, pt3->adap[i]);
+				if (!ret)
+					break;
+				msleep_interruptible(1);
+			}
+			if (ret) {
+				pr_debug("#%d fail pt3_qm_tuner_init ret=0x%x\n", i, ret);
+				goto last;
+			}
+		}
+	if (unlikely(bus->cmd_addr < 4096))
+		pt3_i2c_copy(pt3->i2c, bus);
+
+	bus->cmd_addr = PT3_BUS_CMD_ADDR1;
+	ret = pt3_i2c_run(pt3->i2c, bus, false);
+	if (ret) {
+		pr_debug("failed cmd_addr=0x%x ret=0x%x\n", PT3_BUS_CMD_ADDR1, ret);
+		goto last;
+	}
+	ret = pt3_tc_set_powers(pt3->adap[PT3_NR_ADAPS-1], NULL, true, true);
+	if (ret) {
+		pr_debug("fail tc_set_powers,\n");
+		goto last;
+	}
+last:
+	return ret;
+}
+
+static int pt3_tuner_init_all(struct pt3_board *pt3)
+{
+	int ret, i;
+	struct pt3_i2c *i2c = pt3->i2c;
+	struct pt3_bus *bus = vzalloc(sizeof(struct pt3_bus));
+
+	if (!bus)
+		return -ENOMEM;
+	pt3_bus_end(bus);
+	bus->cmd_addr = PT3_BUS_CMD_ADDR0;
+
+	if (!pt3_i2c_is_clean(i2c)) {
+		pr_debug("cleanup I2C bus\n");
+		ret = pt3_i2c_run(i2c, bus, false);
+		if (ret)
+			goto last;
+		msleep_interruptible(10);
+	}
+	ret = pt3_tuner_power_on(pt3, bus);
+	if (ret)
+		goto last;
+	pr_debug("tuner_power_on\n");
+
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		struct pt3_adapter *adap = pt3->adap[i];
+		ret = pt3_fe_tuner_sleep(adap, false);
+		if (ret)
+			goto last;
+		ret = pt3_fe_set_freq(adap, adap->init_ch, 0);
+		if (ret)
+			pr_debug("fail set_frequency, ret=%d\n", ret);
+		ret = pt3_fe_tuner_sleep(adap, true);
+		if (ret)
+			goto last;
+	}
+last:
+	vfree(bus);
+	return ret;
+}
+
+static void pt3_cleanup_adapter(struct pt3_adapter *adap)
+{
+	if (!adap)
+		return;
+	if (adap->kthread)
+		kthread_stop(adap->kthread);
+	if (adap->fe)
+		dvb_unregister_frontend(adap->fe);
+	if (!adap->sleep)
+		pt3_fe_tuner_sleep(adap, true);
+	if (adap->qm)
+		vfree(adap->qm);
+	if (adap->dma) {
+		if (adap->dma->enabled)
+			pt3_dma_set_enabled(adap->dma, false);
+		pt3_dma_free(adap->dma);
+	}
+	adap->demux.dmx.close(&adap->demux.dmx);
+	dvb_dmxdev_release(&adap->dmxdev);
+	dvb_dmx_release(&adap->demux);
+	dvb_unregister_adapter(&adap->dvb);
+	kfree(adap);
+}
+
+static int pt3_fe_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	adap->voltage = voltage;
+	return (adap->orig_voltage) ? adap->orig_voltage(fe, voltage) : 0;
+}
+
+static int pt3_fe_sleep(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	adap->sleep = true;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_sleep) ? adap->orig_sleep(fe) : 0;
+}
+
+static int pt3_fe_wakeup(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	adap->sleep = false;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_init) ? adap->orig_init(fe) : 0;
+}
+
+static int pt3_init_frontends(struct pt3_board *pt3)
+{
+	struct dvb_frontend *fe[PT3_NR_ADAPS];
+	int i, ret;
+
+	for (i = 0; i < PT3_NR_ADAPS; i++)
+		if (pt3->adap[i]->type == SYS_ISDBS) {
+			fe[i] = pt3_fe_s_attach(pt3->adap[i]);
+			if (!fe[i])
+				break;
+		} else {
+			fe[i] = pt3_fe_t_attach(pt3->adap[i]);
+			if (!fe[i])
+				break;
+		}
+	if (i < PT3_NR_ADAPS) {
+		while (i--)
+			fe[i]->ops.release(fe[i]);
+		return -ENOMEM;
+	}
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		struct pt3_adapter *adap = pt3->adap[i];
+
+		adap->orig_voltage     = fe[i]->ops.set_voltage;
+		adap->orig_sleep       = fe[i]->ops.sleep;
+		adap->orig_init        = fe[i]->ops.init;
+		fe[i]->ops.set_voltage = pt3_fe_set_voltage;
+		fe[i]->ops.sleep       = pt3_fe_sleep;
+		fe[i]->ops.init        = pt3_fe_wakeup;
+
+		ret = dvb_register_frontend(&adap->dvb, fe[i]);
+		if (ret >= 0)
+			adap->fe = fe[i];
+		else {
+			while (i--)
+				dvb_unregister_frontend(fe[i]);
+			for (i = 0; i < PT3_NR_ADAPS; i++)
+				fe[i]->ops.release(fe[i]);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static void pt3_remove(struct pci_dev *pdev)
+{
+	int i;
+	struct pt3_board *pt3 = pci_get_drvdata(pdev);
+
+	if (pt3) {
+		pt3->reset = true;
+		pt3_update_lnb(pt3);
+		if (pt3->i2c) {
+			if (pt3->adap[PT3_NR_ADAPS-1])
+				pt3_tc_set_powers(pt3->adap[PT3_NR_ADAPS-1], NULL, false, false);
+			pt3_i2c_reset(pt3->i2c);
+			vfree(pt3->i2c);
+		}
+		for (i = 0; i < PT3_NR_ADAPS; i++)
+			pt3_cleanup_adapter(pt3->adap[i]);
+		if (pt3->reg[1])
+			iounmap(pt3->reg[1]);
+		if (pt3->reg[0])
+			iounmap(pt3->reg[0]);
+		pci_release_selected_regions(pdev, pt3->bars);
+		kfree(pt3);
+	}
+	pci_disable_device(pdev);
+}
+
+static int pt3_abort(struct pci_dev *pdev, int ret, char *fmt, ...)
+{
+	va_list ap;
+	char *s = NULL;
+	int slen;
+
+	va_start(ap, fmt);
+	slen = vsnprintf(s, 0, fmt, ap);
+	s = vzalloc(slen);
+	if (slen > 0 && s) {
+		vsnprintf(s, slen, fmt, ap);
+		dev_alert(&pdev->dev, "%s", s);
+		vfree(s);
+	}
+	va_end(ap);
+	pt3_remove(pdev);
+	return ret;
+}
+
+struct {
+	fe_delivery_system_t type;
+	u8 addr_tuner, addr_tc;
+	int init_ch;
+	char *str;
+} pt3_config[] = {
+	{SYS_ISDBS, 0x63, 0b00010001,  0, "ISDB-S"},
+	{SYS_ISDBS, 0x60, 0b00010011,  0, "ISDB-S"},
+	{SYS_ISDBT, 0x62, 0b00010000, 70, "ISDB-T"},
+	{SYS_ISDBT, 0x61, 0b00010010, 71, "ISDB-T"},
+};
+
+static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct pt3_board *pt3;
+	struct pt3_adapter *adap;
+	int i, ret, bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	ret = pci_enable_device(pdev);
+	if (ret < 0)
+		return pt3_abort(pdev, ret, "PCI device unusable\n");
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (ret)
+		return pt3_abort(pdev, ret, "DMA mask error\n");
+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+
+	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &i);
+	if ((i & 0xFF) != 1)
+		return pt3_abort(pdev, ret, "Revision 0x%x is not supported\n", i & 0xFF);
+	ret = pci_request_selected_regions(pdev, bars, DRV_NAME);
+	if (ret < 0)
+		return pt3_abort(pdev, ret, "Could not request regions\n");
+
+	pci_set_master(pdev);
+	ret = pci_save_state(pdev);
+	if (ret)
+		return pt3_abort(pdev, ret, "Failed pci_save_state\n");
+	pt3 = kzalloc(sizeof(struct pt3_board), GFP_KERNEL);
+	if (!pt3)
+		return pt3_abort(pdev, -ENOMEM, "struct pt3_board out of memory\n");
+
+	pt3->bars = bars;
+	pt3->pdev = pdev;
+	pci_set_drvdata(pdev, pt3);
+	pt3->reg[0] = pci_ioremap_bar(pdev, 0);
+	pt3->reg[1] = pci_ioremap_bar(pdev, 2);
+	if (!pt3->reg[0] || !pt3->reg[1])
+		return pt3_abort(pdev, -EIO, "Failed pci_ioremap_bar\n");
+
+	ret = readl(pt3->reg[0] + REG_VERSION);
+	i = ((ret >> 24) & 0xFF);
+	if (i != 3)
+		return pt3_abort(pdev, -EIO, "ID=0x%x, not a PT3\n", i);
+	i = ((ret >>  8) & 0xFF);
+	if (i != 4)
+		return pt3_abort(pdev, -EIO, "FPGA version 0x%x is not supported\n", i);
+	mutex_init(&pt3->lock);
+
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		pt3->adap[i] = NULL;
+		adap = pt3_alloc_adapter(pt3);
+		if (IS_ERR(adap))
+			return pt3_abort(pdev, PTR_ERR(adap), "Failed pt3_alloc_adapter\n");
+		adap->idx = i;
+		adap->dma = pt3_dma_create(adap);
+		if (!adap->dma)
+			return pt3_abort(pdev, -ENOMEM, "Failed pt3_dma_create\n");
+		mutex_init(&adap->lock);
+		pt3->adap[i] = adap;
+		adap->type       = pt3_config[i].type;
+		adap->addr_tuner = pt3_config[i].addr_tuner;
+		adap->addr_tc    = pt3_config[i].addr_tc;
+		adap->init_ch    = pt3_config[i].init_ch;
+		adap->str        = pt3_config[i].str;
+		if (adap->type == SYS_ISDBS) {
+			adap->qm = vzalloc(sizeof(struct pt3_qm));
+			if (!adap->qm)
+				return pt3_abort(pdev, -ENOMEM, "QM out of memory\n");
+			adap->qm->adap = adap;
+		}
+		adap->sleep = true;
+	}
+	pt3->reset = true;
+	pt3_update_lnb(pt3);
+
+	pt3->i2c = vzalloc(sizeof(struct pt3_i2c));
+	if (!pt3->i2c)
+		return pt3_abort(pdev, -ENOMEM, "Cannot allocate I2C\n");
+	mutex_init(&pt3->i2c->lock);
+	pt3->i2c->reg[0] = pt3->reg[0];
+	pt3->i2c->reg[1] = pt3->reg[1];
+
+	if (pt3_tuner_init_all(pt3))
+		return pt3_abort(pdev, ret, "Failed pt3_tuner_init_all\n");
+	ret = pt3_init_frontends(pt3);
+	return (ret >= 0) ? ret : pt3_abort(pdev, ret, "Failed pt3_init_frontends\n");
+}
+
+static struct pci_driver pt3_driver = {
+	.name		= DRV_NAME,
+	.probe		= pt3_probe,
+	.remove		= pt3_remove,
+	.id_table	= pt3_id_table,
+};
+
+module_pci_driver(pt3_driver);
+
diff --git a/drivers/media/pci/pt3_dvb/pt3.h b/drivers/media/pci/pt3_dvb/pt3.h
new file mode 100644
index 0000000..c810905
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/pt3.h
@@ -0,0 +1,222 @@
+#ifndef	__PT3_H__
+#define	__PT3_H__
+
+#define pr_fmt(fmt) KBUILD_MODNAME " " fmt
+
+#include <linux/pci.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include "dvb_demux.h"
+#include "dmxdev.h"
+#include "dvb_frontend.h"
+
+#define PT3_NR_ADAPS 4
+#define PT3_SHIFT_MASK(val, shift, mask) (((val) >> (shift)) & (((u64)1<<(mask))-1))
+
+/* register idx */
+#define REG_VERSION	0x00	/*	R	Version		*/
+#define REG_BUS		0x04	/*	R	Bus		*/
+#define REG_SYSTEM_W	0x08	/*	W	System		*/
+#define REG_SYSTEM_R	0x0c	/*	R	System		*/
+#define REG_I2C_W	0x10	/*	W	I2C		*/
+#define REG_I2C_R	0x14	/*	R	I2C		*/
+#define REG_RAM_W	0x18	/*	W	RAM		*/
+#define REG_RAM_R	0x1c	/*	R	RAM		*/
+#define REG_BASE	0x40	/* + 0x18*idx			*/
+#define REG_DMA_DESC_L	0x00	/*	W	DMA		*/
+#define REG_DMA_DESC_H	0x04	/*	W	DMA		*/
+#define REG_DMA_CTL	0x08	/*	W	DMA		*/
+#define REG_TS_CTL	0x0c	/*	W	TS		*/
+#define REG_STATUS	0x10	/*	R	DMA/FIFO/TS	*/
+#define REG_TS_ERR	0x14	/*	R	TS		*/
+
+static int lnb = 2;	/* used if not set by frontend / the value is invalid */
+module_param(lnb, int, 0);
+MODULE_PARM_DESC(lnb, "LNB level (0:OFF 1:+11V 2:+15V)");
+
+/* Transmission and Multiplexing Configuration Control */
+
+enum {
+	LAYER_INDEX_L = 0,
+	LAYER_INDEX_H,
+
+	LAYER_INDEX_A = 0,
+	LAYER_INDEX_B,
+	LAYER_INDEX_C
+};
+
+enum {
+	LAYER_COUNT_S = LAYER_INDEX_H + 1,
+	LAYER_COUNT_T = LAYER_INDEX_C + 1,
+};
+
+struct tmcc_s {
+	u32 indicator;
+	u32 mode[4];
+	u32 slot[4];
+	u32 id[8];
+	u32 emergency;
+	u32 uplink;
+	u32 extflag;
+};
+
+struct tmcc_t {
+	u32 system;
+	u32 indicator;
+	u32 emergency;
+	u32 partial;
+	u32 mode[LAYER_COUNT_T];
+	u32 rate[LAYER_COUNT_T];
+	u32 interleave[LAYER_COUNT_T];
+	u32 segment[LAYER_COUNT_T];
+};
+
+struct pt3_i2c {
+	u8 __iomem *reg[2];
+	struct mutex lock;
+};
+
+struct pt3_dma_page {
+	dma_addr_t addr;
+	u8 *data;
+	u32 size, data_pos;
+};
+
+struct pt3_adapter;
+
+struct pt3_dma {
+	struct pt3_adapter *adap;
+	bool enabled;
+	u32 ts_pos, ts_count, desc_count;
+	struct pt3_dma_page *ts_info, *desc_info;
+	struct mutex lock;
+};
+
+struct pt3_qm {
+	struct pt3_adapter *adap;
+	u8 reg[32];
+
+	bool standby;
+	u32 wait_time_lpf, wait_time_search_fast, wait_time_search_normal;
+	struct tmcc_s tmcc;
+};
+
+struct pt3_board {
+	struct mutex lock;
+	bool reset;
+	int lnb;
+
+	struct pci_dev *pdev;
+	void __iomem *reg[2];
+	int bars;
+	struct pt3_i2c *i2c;
+
+	struct pt3_adapter *adap[PT3_NR_ADAPS];
+};
+
+struct pt3_adapter {
+	struct mutex lock;
+	struct pt3_board *pt3;
+
+	int idx, init_ch;
+	char *str;
+	fe_delivery_system_t type;
+	bool in_use, sleep;
+	u32 channel;
+	s32 offset;
+	u8 addr_tc, addr_tuner;
+	u32 freq;
+	struct pt3_qm *qm;
+	struct pt3_dma *dma;
+	struct task_struct *kthread;
+	int *dec;
+	struct dvb_adapter dvb;
+	struct dvb_demux demux;
+	int users;
+	struct dmxdev dmxdev;
+	struct dvb_frontend *fe;
+	int (*orig_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
+	int (*orig_sleep)  (struct dvb_frontend *fe);
+	int (*orig_init)   (struct dvb_frontend *fe);
+	fe_sec_voltage_t voltage;
+};
+
+enum pt3_ts_pin_mode {
+	PT3_TS_PIN_MODE_NORMAL,
+	PT3_TS_PIN_MODE_LOW,
+	PT3_TS_PIN_MODE_HIGH,
+};
+
+struct pt3_ts_pins_mode {
+	enum pt3_ts_pin_mode clock_data, byte, valid;
+};
+
+#define PT3_BUS_CMD_MAX   4096
+#define PT3_BUS_CMD_ADDR0 4096
+#define PT3_BUS_CMD_ADDR1 (4096 + 2042)
+
+struct pt3_bus {
+	u32 read_addr, cmd_addr, cmd_count, cmd_pos, buf_pos, buf_size;
+	u8 cmd_tmp, cmds[PT3_BUS_CMD_MAX], *buf;
+};
+
+enum pt3_tc_agc {
+	PT3_TC_AGC_AUTO,
+	PT3_TC_AGC_MANUAL,
+};
+
+enum pt3_dma_mode {
+	USE_LFSR = 1 << 16,
+	REVERSE  = 1 << 17,
+	RESET    = 1 << 18,
+};
+
+/* protos */
+u8 pt3_bus_data1(struct pt3_bus *bus, u32 index);
+void pt3_bus_end(struct pt3_bus *bus);
+void pt3_bus_push_read_data(struct pt3_bus *bus, u8 data);
+u32 pt3_bus_read(struct pt3_bus *bus, u8 *data, u32 size);
+void pt3_bus_sleep(struct pt3_bus *bus, u32 ms);
+void pt3_bus_start(struct pt3_bus *bus);
+void pt3_bus_stop(struct pt3_bus *bus);
+void pt3_bus_write(struct pt3_bus *bus, const u8 *data, u32 size);
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux);
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap);
+void pt3_dma_free(struct pt3_dma *dma);
+u32 pt3_dma_get_status(struct pt3_dma *dma);
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma);
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled);
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval);
+int pt3_fe_set_freq(struct pt3_adapter *adap, u32 channel, s32 offset);
+int pt3_fe_tuner_sleep(struct pt3_adapter *adap, bool sleep);
+void pt3_filter(struct pt3_adapter *adap, struct dvb_demux *demux, u8 *buf, size_t count);
+void pt3_i2c_copy(struct pt3_i2c *i2c, struct pt3_bus *bus);
+bool pt3_i2c_is_clean(struct pt3_i2c *i2c);
+void pt3_i2c_reset(struct pt3_i2c *i2c);
+int pt3_i2c_run(struct pt3_i2c *i2c, struct pt3_bus *bus, bool copy);
+u32 pt3_tc_index(struct pt3_adapter *adap);
+int pt3_tc_init(struct pt3_adapter *adap);
+int pt3_tc_read_cn_s(struct pt3_adapter *adap, struct pt3_bus *bus, u32 *cn);
+int pt3_tc_read_cndat_t(struct pt3_adapter *adap, struct pt3_bus *bus, u32 *cn);
+int pt3_tc_read_id_s(struct pt3_adapter *adap, struct pt3_bus *bus, u16 *id);
+int pt3_tc_read_retryov_tmunvld_fulock(struct pt3_adapter *adap, struct pt3_bus *bus, int *retryov, int *tmunvld, int *fulock);
+int pt3_tc_read_tmcc_s(struct pt3_adapter *adap, struct pt3_bus *bus, struct tmcc_s *tmcc);
+int pt3_tc_read_tmcc_t(struct pt3_adapter *adap, struct pt3_bus *bus, struct tmcc_t *tmcc);
+int pt3_tc_read_tuner(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, u8 *data);
+int pt3_tc_read_tuner_without_addr(struct pt3_adapter *adap, struct pt3_bus *bus, u8 *data);
+int pt3_tc_set_agc_s(struct pt3_adapter *adap, enum pt3_tc_agc agc);
+int pt3_tc_set_agc_t(struct pt3_adapter *adap, enum pt3_tc_agc agc);
+int pt3_tc_set_powers(struct pt3_adapter *adap, struct pt3_bus *bus, bool tuner, bool amp);
+int pt3_tc_set_sleep_s(struct pt3_adapter *adap, struct pt3_bus *bus, bool sleep);
+int pt3_tc_set_ts_pins_mode(struct pt3_adapter *adap, struct pt3_ts_pins_mode *mode);
+u32 pt3_tc_time_diff(struct timeval *st, struct timeval *et);
+int pt3_tc_write_id_s(struct pt3_adapter *adap, struct pt3_bus *bus, u16 id);
+int pt3_tc_write_sleep_time(struct pt3_adapter *adap, int sleep);
+int pt3_tc_write_tuner(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, const u8 *data, u32 size);
+int pt3_tc_write_tuner_without_addr(struct pt3_adapter *adap, struct pt3_bus *bus, const u8 *data, u32 size);
+int pt3_qm_tuner_init(struct pt3_i2c *i2c, struct pt3_adapter *adap);
+struct dvb_frontend *pt3_fe_s_attach(struct pt3_adapter *adap);
+struct dvb_frontend *pt3_fe_t_attach(struct pt3_adapter *adap);
+
+#endif
+
diff --git a/drivers/media/pci/pt3_dvb/pt3_bus.c b/drivers/media/pci/pt3_dvb/pt3_bus.c
new file mode 100644
index 0000000..5db7874
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/pt3_bus.c
@@ -0,0 +1,134 @@
+#include "pt3.h"
+
+enum pt3_bus_cmd {
+	I_END,
+	I_ADDRESS,
+	I_CLOCK_L,
+	I_CLOCK_H,
+	I_DATA_L,
+	I_DATA_H,
+	I_RESET,
+	I_SLEEP,
+	I_DATA_L_NOP  = 0x08,
+	I_DATA_H_NOP  = 0x0c,
+	I_DATA_H_READ = 0x0d,
+	I_DATA_H_ACK0 = 0x0e,
+	I_DATA_H_ACK1 = 0x0f,
+};
+
+static void pt3_bus_add_cmd(struct pt3_bus *bus, enum pt3_bus_cmd cmd)
+{
+	if ((bus->cmd_count % 2) == 0)
+		bus->cmd_tmp = cmd;
+	else
+		bus->cmd_tmp |= cmd << 4;
+
+	if (bus->cmd_count % 2) {
+		bus->cmds[bus->cmd_pos] = bus->cmd_tmp;
+		bus->cmd_pos++;
+		if (bus->cmd_pos >= sizeof(bus->cmds)) {
+			pr_debug("bus->cmds is overflow\n");
+			bus->cmd_pos = 0;
+		}
+	}
+	bus->cmd_count++;
+}
+
+u8 pt3_bus_data1(struct pt3_bus *bus, u32 index)
+{
+	if (unlikely(!bus->buf)) {
+		pr_debug("buf is not ready.\n");
+		return 0;
+	}
+	if (unlikely(bus->buf_size < index + 1)) {
+		pr_debug("buf does not have enough size. buf_size=%d\n",
+				bus->buf_size);
+		return 0;
+	}
+	return bus->buf[index];
+}
+
+void pt3_bus_start(struct pt3_bus *bus)
+{
+	pt3_bus_add_cmd(bus, I_DATA_H);
+	pt3_bus_add_cmd(bus, I_CLOCK_H);
+	pt3_bus_add_cmd(bus, I_DATA_L);
+	pt3_bus_add_cmd(bus, I_CLOCK_L);
+}
+
+void pt3_bus_stop(struct pt3_bus *bus)
+{
+	pt3_bus_add_cmd(bus, I_DATA_L);
+	pt3_bus_add_cmd(bus, I_CLOCK_H);
+	pt3_bus_add_cmd(bus, I_DATA_H);
+}
+
+void pt3_bus_write(struct pt3_bus *bus, const u8 *data, u32 size)
+{
+	u32 i, j;
+	u8 byte;
+
+	for (i = 0; i < size; i++) {
+		byte = data[i];
+		for (j = 0; j < 8; j++)
+			pt3_bus_add_cmd(bus, PT3_SHIFT_MASK(byte, 7 - j, 1) ? I_DATA_H_NOP : I_DATA_L_NOP);
+		pt3_bus_add_cmd(bus, I_DATA_H_ACK0);
+	}
+}
+
+u32 pt3_bus_read(struct pt3_bus *bus, u8 *data, u32 size)
+{
+	u32 i, j;
+	u32 index;
+
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < 8; j++)
+			pt3_bus_add_cmd(bus, I_DATA_H_READ);
+		if (i == (size - 1))
+			pt3_bus_add_cmd(bus, I_DATA_H_NOP);
+		else
+			pt3_bus_add_cmd(bus, I_DATA_L_NOP);
+	}
+	index = bus->read_addr;
+	bus->read_addr += size;
+	if (likely(!bus->buf)) {
+		bus->buf = data;
+		bus->buf_pos = 0;
+		bus->buf_size = size;
+	} else
+		pr_debug("bus read buf already exists.\n");
+
+	return index;
+}
+
+void pt3_bus_push_read_data(struct pt3_bus *bus, u8 data)
+{
+	if (unlikely(bus->buf)) {
+		if (bus->buf_pos >= bus->buf_size) {
+			pr_debug("buffer over run. pos=%d\n", bus->buf_pos);
+			bus->buf_pos = 0;
+		}
+		bus->buf[bus->buf_pos] = data;
+		bus->buf_pos++;
+	}
+}
+
+void pt3_bus_sleep(struct pt3_bus *bus, u32 ms)
+{
+	u32 i;
+	for (i = 0; i < ms; i++)
+		pt3_bus_add_cmd(bus, I_SLEEP);
+}
+
+void pt3_bus_end(struct pt3_bus *bus)
+{
+	pt3_bus_add_cmd(bus, I_END);
+	if (bus->cmd_count % 2)
+		pt3_bus_add_cmd(bus, I_END);
+}
+
+void pt3_bus_reset(struct pt3_bus *bus)
+{
+	pt3_bus_add_cmd(bus, I_RESET);
+}
+
diff --git a/drivers/media/pci/pt3_dvb/pt3_dma.c b/drivers/media/pci/pt3_dvb/pt3_dma.c
new file mode 100644
index 0000000..bc4c67b
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/pt3_dma.c
@@ -0,0 +1,316 @@
+#include "pt3.h"
+
+#define PT3_DMA_MAX_DESCS	204
+#define PT3_DMA_PAGE_SIZE	(PT3_DMA_MAX_DESCS * sizeof(struct pt3_dma_desc))
+#define PT3_DMA_BLOCK_COUNT	17
+#define PT3_DMA_BLOCK_SIZE	(PT3_DMA_PAGE_SIZE * 47)
+#define PT3_DMA_TS_BUF_SIZE	(PT3_DMA_BLOCK_SIZE * PT3_DMA_BLOCK_COUNT)
+#define PT3_DMA_NOT_SYNC_BYTE	0x74
+
+struct pt3_dma_desc {
+	u64 page_addr;
+	u32 page_size;
+	u64 next_desc;
+} __packed;
+
+void pt3_dma_build_page_descriptor(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *desc_info, *ts_info;
+	u64 ts_addr, desc_addr;
+	u32 i, j, ts_size, desc_remain, ts_info_pos, desc_info_pos;
+	struct pt3_dma_desc *prev, *curr;
+
+	pr_debug("#%d build page descriptor ts_count=%d ts_size=%d desc_count=%d desc_size=%d\n",
+		dma->adap->idx, dma->ts_count, dma->ts_info[0].size, dma->desc_count, dma->desc_info[0].size);
+	desc_info_pos = ts_info_pos = 0;
+	desc_info = &dma->desc_info[desc_info_pos];
+	desc_addr   = desc_info->addr;
+	desc_remain = desc_info->size;
+	desc_info->data_pos = 0;
+	prev = NULL;
+	curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+	desc_info_pos++;
+
+	for (i = 0; i < dma->ts_count; i++) {
+		if (unlikely(ts_info_pos >= dma->ts_count)) {
+			pr_debug("#%d ts_info overflow max=%d curr=%d\n", dma->adap->idx, dma->ts_count, ts_info_pos);
+			return;
+		}
+		ts_info = &dma->ts_info[ts_info_pos];
+		ts_addr = ts_info->addr;
+		ts_size = ts_info->size;
+		ts_info_pos++;
+		pr_debug("#%d i=%d, ts_info addr=0x%llx ts_size=%d\n", dma->adap->idx, i, ts_addr, ts_size);
+		for (j = 0; j < ts_size / PT3_DMA_PAGE_SIZE; j++) {
+			if (desc_remain < sizeof(struct pt3_dma_desc)) {
+				if (unlikely(desc_info_pos >= dma->desc_count)) {
+					pr_debug("#%d desc_info overflow max=%d curr=%d\n",
+						dma->adap->idx, dma->desc_count, desc_info_pos);
+					return;
+				}
+				desc_info = &dma->desc_info[desc_info_pos];
+				desc_info->data_pos = 0;
+				curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+				pr_debug("#%d desc_info_pos=%d ts_addr=0x%llx remain=%d\n",
+					dma->adap->idx, desc_info_pos, ts_addr, desc_remain);
+				desc_addr = desc_info->addr;
+				desc_remain = desc_info->size;
+				desc_info_pos++;
+			}
+			if (prev)
+				prev->next_desc = desc_addr | 0b10;
+			curr->page_addr = ts_addr           | 0b111;
+			curr->page_size = PT3_DMA_PAGE_SIZE | 0b111;
+			curr->next_desc = 0b10;
+			pr_debug("#%d j=%d dma write desc ts_addr=0x%llx desc_info_pos=%d desc_remain=%d\n",
+				dma->adap->idx, j, ts_addr, desc_info_pos, desc_remain);
+			ts_addr += PT3_DMA_PAGE_SIZE;
+
+			prev = curr;
+			desc_info->data_pos += sizeof(struct pt3_dma_desc);
+			if (unlikely(desc_info->data_pos > desc_info->size)) {
+				pr_debug("#%d dma desc_info data overflow max=%d curr=%d\n",
+					dma->adap->idx, desc_info->size, desc_info->data_pos);
+				return;
+			}
+			curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+			desc_addr += sizeof(struct pt3_dma_desc);
+			desc_remain -= sizeof(struct pt3_dma_desc);
+		}
+	}
+	if (prev)
+		prev->next_desc = dma->desc_info->addr | 0b10;
+}
+
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap)
+{
+	struct pt3_dma_page *page;
+	u32 i;
+
+	struct pt3_dma *dma = kzalloc(sizeof(struct pt3_dma), GFP_KERNEL);
+	if (!dma) {
+		pr_debug("#%d fail allocate PT3_DMA\n", adap->idx);
+		goto fail;
+	}
+	dma->adap = adap;
+	dma->enabled = false;
+	mutex_init(&dma->lock);
+
+	dma->ts_count = PT3_DMA_BLOCK_COUNT;
+	dma->ts_info = kzalloc(sizeof(struct pt3_dma_page) * dma->ts_count, GFP_KERNEL);
+	if (!dma->ts_info) {
+		pr_debug("#%d fail allocate TS DMA page\n", adap->idx);
+		goto fail;
+	}
+	pr_debug("#%d Alloc TS buf (ts_count %d)\n", adap->idx, dma->ts_count);
+	for (i = 0; i < dma->ts_count; i++) {
+		page = &dma->ts_info[i];
+		page->size = PT3_DMA_BLOCK_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			pr_debug("#%d fail alloc_consistent. %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
+
+	dma->desc_count = 1 + (PT3_DMA_TS_BUF_SIZE / PT3_DMA_PAGE_SIZE - 1) / PT3_DMA_MAX_DESCS;
+	dma->desc_info = kzalloc(sizeof(struct pt3_dma_page) * dma->desc_count, GFP_KERNEL);
+	if (!dma->desc_info) {
+		pr_debug("#%d fail allocate Desc DMA page\n", adap->idx);
+		goto fail;
+	}
+	pr_debug("#%d Alloc Descriptor buf (desc_count %d)\n", adap->idx, dma->desc_count);
+	for (i = 0; i < dma->desc_count; i++) {
+		page = &dma->desc_info[i];
+		page->size = PT3_DMA_PAGE_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			pr_debug("#%d fail alloc_consistent %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
+
+	pr_debug("#%d build page descriptor\n", adap->idx);
+	pt3_dma_build_page_descriptor(dma);
+	return dma;
+fail:
+	if (dma)
+		pt3_dma_free(dma);
+	return NULL;
+}
+
+void pt3_dma_free(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *page;
+	u32 i;
+
+	if (dma->ts_info) {
+		for (i = 0; i < dma->ts_count; i++) {
+			page = &dma->ts_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->ts_info);
+	}
+	if (dma->desc_info) {
+		for (i = 0; i < dma->desc_count; i++) {
+			page = &dma->desc_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->desc_info);
+	}
+	kfree(dma);
+}
+
+void __iomem *pt3_dma_get_base_addr(struct pt3_dma *dma)
+{
+	return dma->adap->pt3->i2c->reg[0] + REG_BASE + (0x18 * dma->adap->idx);
+}
+
+void pt3_dma_reset(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u32 i;
+
+	for (i = 0; i < dma->ts_count; i++) {
+		ts = &dma->ts_info[i];
+		memset(ts->data, 0, ts->size);
+		ts->data_pos = 0;
+		*ts->data = PT3_DMA_NOT_SYNC_BYTE;
+	}
+	dma->ts_pos = 0;
+}
+
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u64 start_addr = dma->desc_info->addr;
+
+	if (enabled) {
+		pr_debug("#%d DMA enable start_addr=%llx\n", dma->adap->idx, start_addr);
+		pt3_dma_reset(dma);
+		writel(1 << 1, base + REG_DMA_CTL);	/* stop DMA */
+		writel(PT3_SHIFT_MASK(start_addr,  0, 32), base + REG_DMA_DESC_L);
+		writel(PT3_SHIFT_MASK(start_addr, 32, 32), base + REG_DMA_DESC_H);
+		pr_debug("set descriptor address low %llx\n",  PT3_SHIFT_MASK(start_addr,  0, 32));
+		pr_debug("set descriptor address high %llx\n", PT3_SHIFT_MASK(start_addr, 32, 32));
+		writel(1 << 0, base + REG_DMA_CTL);	/* start DMA */
+	} else {
+		pr_debug("#%d DMA disable\n", dma->adap->idx);
+		writel(1 << 1, base + REG_DMA_CTL);	/* stop DMA */
+		while (1) {
+			if (!PT3_SHIFT_MASK(readl(base + REG_STATUS), 0, 1))
+				break;
+			msleep_interruptible(1);
+		}
+	}
+	dma->enabled = enabled;
+}
+
+/* convert Gray code to binary, e.g. 1001 -> 1110 */
+static u32 pt3_dma_gray2binary(u32 gray, u32 bit)
+{
+	u32 binary = 0, i, j, k;
+
+	for (i = 0; i < bit; i++) {
+		k = 0;
+		for (j = i; j < bit; j++)
+			k = k ^ PT3_SHIFT_MASK(gray, j, 1);
+		binary |= k << i;
+	}
+	return binary;
+}
+
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma)
+{
+	return pt3_dma_gray2binary(readl(pt3_dma_get_base_addr(dma) + REG_TS_ERR), 32);
+}
+
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u32 data = mode | initval;
+	pr_debug("set_test_mode base=%p data=0x%04x\n", base, data);
+	writel(data, base + REG_TS_CTL);
+}
+
+bool pt3_dma_ready(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u8 *p;
+
+	u32 next = dma->ts_pos + 1;
+	if (next >= dma->ts_count)
+		next = 0;
+	ts = &dma->ts_info[next];
+	p = &ts->data[ts->data_pos];
+
+	if (*p == 0x47)
+		return true;
+	if (*p == PT3_DMA_NOT_SYNC_BYTE)
+		return false;
+
+	pr_debug("#%d invalid sync byte value=0x%02x ts_pos=%d data_pos=%d curr=0x%02x\n",
+		dma->adap->idx, *p, next, ts->data_pos, dma->ts_info[dma->ts_pos].data[0]);
+	return false;
+}
+
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux)
+{
+	bool ready;
+	struct pt3_dma_page *ts;
+	u32 i, prev;
+	size_t csize, remain = dma->ts_info[dma->ts_pos].size;
+
+	mutex_lock(&dma->lock);
+	pr_debug("#%d dma_copy ts_pos=0x%x data_pos=0x%x\n",
+		   dma->adap->idx, dma->ts_pos, dma->ts_info[dma->ts_pos].data_pos);
+	for (;;) {
+		for (i = 0; i < 20; i++) {
+			ready = pt3_dma_ready(dma);
+			if (ready)
+				break;
+			msleep_interruptible(30);
+		}
+		if (!ready) {
+			pr_debug("#%d dma_copy NOT READY\n", dma->adap->idx);
+			goto last;
+		}
+		prev = dma->ts_pos - 1;
+		if (prev < 0 || dma->ts_count <= prev)
+			prev = dma->ts_count - 1;
+		if (dma->ts_info[prev].data[0] != PT3_DMA_NOT_SYNC_BYTE)
+			pr_debug("#%d DMA buffer overflow. prev=%d data=0x%x\n",
+					dma->adap->idx, prev, dma->ts_info[prev].data[0]);
+		ts = &dma->ts_info[dma->ts_pos];
+		for (;;) {
+			csize = (remain < (ts->size - ts->data_pos)) ?
+				 remain : (ts->size - ts->data_pos);
+			pt3_filter(dma->adap, demux, &ts->data[ts->data_pos], csize);
+			remain -= csize;
+			ts->data_pos += csize;
+			if (ts->data_pos >= ts->size) {
+				ts->data_pos = 0;
+				ts->data[ts->data_pos] = PT3_DMA_NOT_SYNC_BYTE;
+				dma->ts_pos++;
+				if (dma->ts_pos >= dma->ts_count)
+					dma->ts_pos = 0;
+				break;
+			}
+			if (remain <= 0)
+				goto last;
+		}
+	}
+last:
+	mutex_unlock(&dma->lock);
+	return dma->ts_info[dma->ts_pos].size - remain;
+}
+
+u32 pt3_dma_get_status(struct pt3_dma *dma)
+{
+	return readl(pt3_dma_get_base_addr(dma) + REG_STATUS);
+}
+
diff --git a/drivers/media/pci/pt3_dvb/pt3_fe.c b/drivers/media/pci/pt3_dvb/pt3_fe.c
new file mode 100644
index 0000000..111a696
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/pt3_fe.c
@@ -0,0 +1,1186 @@
+#include "dvb_math.h"
+#include "pt3.h"
+
+static u8 pt3_qm_reg_rw[] = {
+	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
+	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
+	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00,
+};
+
+void pt3_qm_init_reg_param(struct pt3_qm *qm)
+{
+	memcpy(qm->reg, pt3_qm_reg_rw, sizeof(pt3_qm_reg_rw));
+
+	qm->adap->freq = 0;
+	qm->standby = false;
+	qm->wait_time_lpf = 20;
+	qm->wait_time_search_fast = 4;
+	qm->wait_time_search_normal = 15;
+}
+
+static int pt3_qm_write(struct pt3_qm *qm, struct pt3_bus *bus, u8 addr, u8 data)
+{
+	int ret = pt3_tc_write_tuner(qm->adap, bus, addr, &data, sizeof(data));
+	qm->reg[addr] = data;
+	return ret;
+}
+
+#define PT3_QM_INIT_DUMMY_RESET 0x0c
+
+void pt3_qm_dummy_reset(struct pt3_qm *qm, struct pt3_bus *bus)
+{
+	pt3_qm_write(qm, bus, 0x01, PT3_QM_INIT_DUMMY_RESET);
+	pt3_qm_write(qm, bus, 0x01, PT3_QM_INIT_DUMMY_RESET);
+}
+
+static void pt3_qm_sleep(struct pt3_bus *bus, u32 ms)
+{
+	if (bus)
+		pt3_bus_sleep(bus, ms);
+	else
+		msleep_interruptible(ms);
+}
+
+static int pt3_qm_read(struct pt3_qm *qm, struct pt3_bus *bus, u8 addr, u8 *data)
+{
+	int ret = 0;
+	if ((addr == 0x00) || (addr == 0x0d))
+		ret = pt3_tc_read_tuner(qm->adap, bus, addr, data);
+	return ret;
+}
+
+static u8 pt3_qm_flag[32] = {
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
+};
+
+static int pt3_qm_set_sleep_mode(struct pt3_qm *qm, struct pt3_bus *bus)
+{
+	int ret;
+
+	if (qm->standby) {
+		qm->reg[0x01] &= (~(1 << 3)) & 0xff;
+		qm->reg[0x01] |= 1 << 0;
+		qm->reg[0x05] |= 1 << 3;
+
+		ret = pt3_qm_write(qm, bus, 0x05, qm->reg[0x05]);
+		if (ret)
+			return ret;
+		ret = pt3_qm_write(qm, bus, 0x01, qm->reg[0x01]);
+		if (ret)
+			return ret;
+	} else {
+		qm->reg[0x01] |= 1 << 3;
+		qm->reg[0x01] &= (~(1 << 0)) & 0xff;
+		qm->reg[0x05] &= (~(1 << 3)) & 0xff;
+
+		ret = pt3_qm_write(qm, bus, 0x01, qm->reg[0x01]);
+		if (ret)
+			return ret;
+		ret = pt3_qm_write(qm, bus, 0x05, qm->reg[0x05]);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int pt3_qm_set_search_mode(struct pt3_qm *qm, struct pt3_bus *bus)
+{
+	qm->reg[3] &= 0xfe;
+	return pt3_qm_write(qm, bus, 0x03, qm->reg[3]);
+}
+
+int pt3_qm_init(struct pt3_qm *qm, struct pt3_bus *bus)
+{
+	u8 i_data;
+	u32 i;
+	int ret;
+
+	/* soft reset on */
+	ret = pt3_qm_write(qm, bus, 0x01, PT3_QM_INIT_DUMMY_RESET);
+	if (ret)
+		return ret;
+
+	pt3_qm_sleep(bus, 1);
+
+	/* soft reset off */
+	i_data = qm->reg[0x01] | 0x10;
+	ret = pt3_qm_write(qm, bus, 0x01, i_data);
+	if (ret)
+		return ret;
+
+	/* ID check */
+	ret = pt3_qm_read(qm, bus, 0x00, &i_data);
+	if (ret)
+		return ret;
+
+	if ((bus == NULL) && (i_data != 0x48))
+		return -EINVAL;
+
+	/* LPF tuning on */
+	pt3_qm_sleep(bus, 1);
+	qm->reg[0x0c] |= 0x40;
+	ret = pt3_qm_write(qm, bus, 0x0c, qm->reg[0x0c]);
+	if (ret)
+		return ret;
+	pt3_qm_sleep(bus, qm->wait_time_lpf);
+
+	for (i = 0; i < sizeof(pt3_qm_flag); i++)
+		if (pt3_qm_flag[i] == 1) {
+			ret = pt3_qm_write(qm, bus, i, qm->reg[i]);
+			if (ret)
+				return ret;
+		}
+	ret = pt3_qm_set_sleep_mode(qm, bus);
+	if (ret)
+		return ret;
+	return pt3_qm_set_search_mode(qm, bus);
+}
+
+int pt3_qm_tuner_init(struct pt3_i2c *i2c, struct pt3_adapter *adap)
+{
+	int ret;
+	struct pt3_bus *bus = vzalloc(sizeof(struct pt3_bus));
+
+	if (!bus)
+		return -ENOMEM;
+	pt3_qm_init_reg_param(adap->qm);
+	pt3_qm_dummy_reset(adap->qm, bus);
+	pt3_bus_end(bus);
+	ret = pt3_i2c_run(i2c, bus, true);
+	vfree(bus);
+	if (ret) {
+		pr_debug("fail pt3_qm_tuner_init dummy reset ret=%d\n", ret);
+		return ret;
+	}
+
+	bus = vzalloc(sizeof(struct pt3_bus));
+	if (!bus)
+		return -ENOMEM;
+	ret = pt3_qm_init(adap->qm, bus);
+	if (ret) {
+		vfree(bus);
+		return ret;
+	}
+	pt3_bus_end(bus);
+	ret = pt3_i2c_run(i2c, bus, true);
+	vfree(bus);
+	if (ret) {
+		pr_debug("fail pt3_qm_tuner_init qm init ret=%d\n", ret);
+		return ret;
+	}
+	return ret;
+}
+
+int pt3_qm_set_sleep(struct pt3_qm *qm, bool sleep)
+{
+	qm->standby = sleep;
+	if (sleep) {
+		int ret = pt3_tc_set_agc_s(qm->adap, PT3_TC_AGC_MANUAL);
+		if (ret)
+			return ret;
+		pt3_qm_set_sleep_mode(qm, NULL);
+		pt3_tc_set_sleep_s(qm->adap, NULL, sleep);
+	} else {
+		pt3_tc_set_sleep_s(qm->adap, NULL, sleep);
+		pt3_qm_set_sleep_mode(qm, NULL);
+	}
+	qm->adap->sleep = sleep;
+	return 0;
+}
+
+void pt3_qm_get_channel_freq(u32 channel, u32 *number, u32 *freq)
+{
+	if (channel < 12) {
+		*number = 1 + 2 * channel;
+		*freq = 104948 + 3836 * channel;
+	} else if (channel < 24) {
+		channel -= 12;
+		*number = 2 + 2 * channel;
+		*freq = 161300 + 4000 * channel;
+	} else {
+		channel -= 24;
+		*number = 1 + 2 * channel;
+		*freq = 159300 + 4000 * channel;
+	}
+}
+
+static u32 PT3_QM_FREQ_TABLE[9][3] = {
+	{ 2151000, 1, 7 },
+	{ 1950000, 1, 6 },
+	{ 1800000, 1, 5 },
+	{ 1600000, 1, 4 },
+	{ 1450000, 1, 3 },
+	{ 1250000, 1, 2 },
+	{ 1200000, 0, 7 },
+	{  975000, 0, 6 },
+	{  950000, 0, 0 }
+};
+
+static u32 SD_TABLE[24][2][3] = {
+	{{0x38fae1, 0x0d, 0x5}, {0x39fae1, 0x0d, 0x5},},
+	{{0x3f570a, 0x0e, 0x3}, {0x00570a, 0x0e, 0x3},},
+	{{0x05b333, 0x0e, 0x5}, {0x06b333, 0x0e, 0x5},},
+	{{0x3c0f5c, 0x0f, 0x4}, {0x3d0f5c, 0x0f, 0x4},},
+	{{0x026b85, 0x0f, 0x6}, {0x036b85, 0x0f, 0x6},},
+	{{0x38c7ae, 0x10, 0x5}, {0x39c7ae, 0x10, 0x5},},
+	{{0x3f23d7, 0x11, 0x3}, {0x0023d7, 0x11, 0x3},},
+	{{0x058000, 0x11, 0x5}, {0x068000, 0x11, 0x5},},
+	{{0x3bdc28, 0x12, 0x4}, {0x3cdc28, 0x12, 0x4},},
+	{{0x023851, 0x12, 0x6}, {0x033851, 0x12, 0x6},},
+	{{0x38947a, 0x13, 0x5}, {0x39947a, 0x13, 0x5},},
+	{{0x3ef0a3, 0x14, 0x3}, {0x3ff0a3, 0x14, 0x3},},
+	{{0x3c8000, 0x16, 0x4}, {0x3d8000, 0x16, 0x4},},
+	{{0x048000, 0x16, 0x6}, {0x058000, 0x16, 0x6},},
+	{{0x3c8000, 0x17, 0x5}, {0x3d8000, 0x17, 0x5},},
+	{{0x048000, 0x18, 0x3}, {0x058000, 0x18, 0x3},},
+	{{0x3c8000, 0x18, 0x6}, {0x3d8000, 0x18, 0x6},},
+	{{0x048000, 0x19, 0x4}, {0x058000, 0x19, 0x4},},
+	{{0x3c8000, 0x1a, 0x3}, {0x3d8000, 0x1a, 0x3},},
+	{{0x048000, 0x1a, 0x5}, {0x058000, 0x1a, 0x5},},
+	{{0x3c8000, 0x1b, 0x4}, {0x3d8000, 0x1b, 0x4},},
+	{{0x048000, 0x1b, 0x6}, {0x058000, 0x1b, 0x6},},
+	{{0x3c8000, 0x1c, 0x5}, {0x3d8000, 0x1c, 0x5},},
+	{{0x048000, 0x1d, 0x3}, {0x058000, 0x1d, 0x3},},
+};
+
+static int pt3_qm_tuning(struct pt3_qm *qm, struct pt3_bus *bus, u32 *sd, u32 channel)
+{
+	int ret;
+	struct pt3_adapter *adap = qm->adap;
+	u8 i_data;
+	u32 index, i, N, A;
+
+	qm->reg[0x08] &= 0xf0;
+	qm->reg[0x08] |= 0x09;
+
+	qm->reg[0x13] &= 0x9f;
+	qm->reg[0x13] |= 0x20;
+
+	for (i = 0; i < 8; i++) {
+		if ((PT3_QM_FREQ_TABLE[i+1][0] <= adap->freq) && (adap->freq < PT3_QM_FREQ_TABLE[i][0])) {
+			i_data = qm->reg[0x02];
+			i_data &= 0x0f;
+			i_data |= PT3_QM_FREQ_TABLE[i][1] << 7;
+			i_data |= PT3_QM_FREQ_TABLE[i][2] << 4;
+			pt3_qm_write(qm, bus, 0x02, i_data);
+		}
+	}
+
+	index = pt3_tc_index(qm->adap);
+	*sd = SD_TABLE[channel][index][0];
+	N = SD_TABLE[channel][index][1];
+	A = SD_TABLE[channel][index][2];
+
+	qm->reg[0x06] &= 0x40;
+	qm->reg[0x06] |= N;
+	ret = pt3_qm_write(qm, bus, 0x06, qm->reg[0x06]);
+	if (ret)
+		return ret;
+
+	qm->reg[0x07] &= 0xf0;
+	qm->reg[0x07] |= A & 0x0f;
+	return pt3_qm_write(qm, bus, 0x07, qm->reg[0x07]);
+}
+
+static int pt3_qm_local_lpf_tuning(struct pt3_qm *qm, struct pt3_bus *bus, int lpf, u32 channel)
+{
+	u8 i_data;
+	u32 sd = 0;
+	int ret = pt3_qm_tuning(qm, bus, &sd, channel);
+
+	if (ret)
+		return ret;
+	if (lpf) {
+		i_data = qm->reg[0x08] & 0xf0;
+		i_data |= 2;
+		ret = pt3_qm_write(qm, bus, 0x08, i_data);
+	} else
+		ret = pt3_qm_write(qm, bus, 0x08, qm->reg[0x08]);
+	if (ret)
+		return ret;
+
+	qm->reg[0x09] &= 0xc0;
+	qm->reg[0x09] |= (sd >> 16) & 0x3f;
+	qm->reg[0x0a] = (sd >> 8) & 0xff;
+	qm->reg[0x0b] = (sd >> 0) & 0xff;
+	ret = pt3_qm_write(qm, bus, 0x09, qm->reg[0x09]);
+	if (ret)
+		return ret;
+	ret = pt3_qm_write(qm, bus, 0x0a, qm->reg[0x0a]);
+	if (ret)
+		return ret;
+	ret = pt3_qm_write(qm, bus, 0x0b, qm->reg[0x0b]);
+	if (ret)
+		return ret;
+
+	if (lpf) {
+		i_data = qm->reg[0x0c];
+		i_data &= 0x3f;
+		ret = pt3_qm_write(qm, bus, 0x0c, i_data);
+		if (ret)
+			return ret;
+		pt3_qm_sleep(bus, 1);
+
+		i_data = qm->reg[0x0c];
+		i_data |= 0xc0;
+		ret = pt3_qm_write(qm, bus, 0x0c, i_data);
+		if (ret)
+			return ret;
+		pt3_qm_sleep(bus, qm->wait_time_lpf);
+		ret = pt3_qm_write(qm, bus, 0x08, 0x09);
+		if (ret)
+			return ret;
+		ret = pt3_qm_write(qm, bus, 0x13, qm->reg[0x13]);
+		if (ret)
+			return ret;
+	} else {
+		ret = pt3_qm_write(qm, bus, 0x13, qm->reg[0x13]);
+		if (ret)
+			return ret;
+		i_data = qm->reg[0x0c];
+		i_data &= 0x7f;
+		ret = pt3_qm_write(qm, bus, 0x0c, i_data);
+		if (ret)
+			return ret;
+		pt3_qm_sleep(bus, 2);
+
+		i_data = qm->reg[0x0c];
+		i_data |= 0x80;
+		ret = pt3_qm_write(qm, bus, 0x0c, i_data);
+		if (ret)
+			return ret;
+		if (qm->reg[0x03] & 0x01)
+			pt3_qm_sleep(bus, qm->wait_time_search_fast);
+		else
+			pt3_qm_sleep(bus, qm->wait_time_search_normal);
+	}
+	return ret;
+}
+
+int pt3_qm_get_locked(struct pt3_qm *qm, bool *locked)
+{
+	int ret = pt3_qm_read(qm, NULL, 0x0d, &qm->reg[0x0d]);
+	if (ret)
+		return ret;
+	if (qm->reg[0x0d] & 0x40)
+		*locked = true;
+	else
+		*locked = false;
+	return ret;
+}
+
+int pt3_qm_set_frequency(struct pt3_qm *qm, u32 channel)
+{
+	u32 number, freq, freq_kHz;
+	struct timeval begin, now;
+	bool locked;
+	int ret = pt3_tc_set_agc_s(qm->adap, PT3_TC_AGC_MANUAL);
+	if (ret)
+		return ret;
+
+	pt3_qm_get_channel_freq(channel, &number, &freq);
+	freq_kHz = freq * 10;
+	if (pt3_tc_index(qm->adap) == 0)
+		freq_kHz -= 500;
+	else
+		freq_kHz += 500;
+	qm->adap->freq = freq_kHz;
+	pr_debug("#%d ch %d freq %d kHz\n", qm->adap->idx, channel, freq_kHz);
+
+	ret = pt3_qm_local_lpf_tuning(qm, NULL, 1, channel);
+	if (ret)
+		return ret;
+	do_gettimeofday(&begin);
+	while (1) {
+		do_gettimeofday(&now);
+		ret = pt3_qm_get_locked(qm, &locked);
+		if (ret)
+			return ret;
+		if (locked)
+			break;
+		if (pt3_tc_time_diff(&begin, &now) >= 100)
+			break;
+		msleep_interruptible(1);
+	}
+	pr_debug("#%d qm_get_locked %d ret=0x%x\n", qm->adap->idx, locked, ret);
+	if (!locked)
+		return -ETIMEDOUT;
+
+	ret = pt3_tc_set_agc_s(qm->adap, PT3_TC_AGC_AUTO);
+	if (!ret) {
+		qm->adap->channel = channel;
+		qm->adap->offset = 0;
+	}
+	return ret;
+}
+
+static struct {
+	u32	freq;		/* Channel center frequency @ kHz	*/
+	u32	freq_th;	/* Offset frequency threshold @ kHz	*/
+	u8	shf_val;	/* Spur shift value			*/
+	u8	shf_dir;	/* Spur shift direction			*/
+} SHF_DVBT_TAB[] = {
+	{  64500, 500, 0x92, 0x07 },
+	{ 191500, 300, 0xE2, 0x07 },
+	{ 205500, 500, 0x2C, 0x04 },
+	{ 212500, 500, 0x1E, 0x04 },
+	{ 226500, 500, 0xD4, 0x07 },
+	{  99143, 500, 0x9C, 0x07 },
+	{ 173143, 500, 0xD4, 0x07 },
+	{ 191143, 300, 0xD4, 0x07 },
+	{ 207143, 500, 0xCE, 0x07 },
+	{ 225143, 500, 0xCE, 0x07 },
+	{ 243143, 500, 0xD4, 0x07 },
+	{ 261143, 500, 0xD4, 0x07 },
+	{ 291143, 500, 0xD4, 0x07 },
+	{ 339143, 500, 0x2C, 0x04 },
+	{ 117143, 500, 0x7A, 0x07 },
+	{ 135143, 300, 0x7A, 0x07 },
+	{ 153143, 500, 0x01, 0x07 }
+};
+
+static void pt3_mx_rftune(u8 *data, u32 *size, u32 freq)
+{
+	u32 dig_rf_freq, tmp, frac_divider, kHz, MHz, i;
+	u8 rf_data[] = {
+		0x13, 0x00,	/* abort tune			*/
+		0x3B, 0xC0,
+		0x3B, 0x80,
+		0x10, 0x95,	/* BW				*/
+		0x1A, 0x05,
+		0x61, 0x00,
+		0x62, 0xA0,
+		0x11, 0x40,	/* 2 bytes to store RF freq.	*/
+		0x12, 0x0E,	/* 2 bytes to store RF freq.	*/
+		0x13, 0x01	/* start tune			*/
+	};
+
+	dig_rf_freq = 0;
+	tmp = 0;
+	frac_divider = 1000000;
+	kHz = 1000;
+	MHz = 1000000;
+
+	dig_rf_freq = freq / MHz;
+	tmp = freq % MHz;
+
+	for (i = 0; i < 6; i++) {
+		dig_rf_freq <<= 1;
+		frac_divider /= 2;
+		if (tmp > frac_divider) {
+			tmp -= frac_divider;
+			dig_rf_freq++;
+		}
+	}
+	if (tmp > 7812)
+		dig_rf_freq++;
+
+	rf_data[2 * (7) + 1] = (u8)(dig_rf_freq);
+	rf_data[2 * (8) + 1] = (u8)(dig_rf_freq >> 8);
+
+	for (i = 0; i < sizeof(SHF_DVBT_TAB)/sizeof(*SHF_DVBT_TAB); i++) {
+		if ((freq >= (SHF_DVBT_TAB[i].freq - SHF_DVBT_TAB[i].freq_th) * kHz) &&
+				(freq <= (SHF_DVBT_TAB[i].freq + SHF_DVBT_TAB[i].freq_th) * kHz)) {
+			rf_data[2 * (5) + 1] = SHF_DVBT_TAB[i].shf_val;
+			rf_data[2 * (6) + 1] = 0xa0 | SHF_DVBT_TAB[i].shf_dir;
+			break;
+		}
+	}
+	memcpy(data, rf_data, sizeof(rf_data));
+	*size = sizeof(rf_data);
+
+	pr_debug("mx_rftune freq=%d\n", freq);
+}
+
+static void pt3_mx_write(struct pt3_adapter *adap, struct pt3_bus *bus, u8 *data, size_t size)
+{
+	pt3_tc_write_tuner_without_addr(adap, bus, data, size);
+}
+
+static void pt3_mx_standby(struct pt3_adapter *adap)
+{
+	u8 data[4] = {0x01, 0x00, 0x13, 0x00};
+	pt3_mx_write(adap, NULL, data, sizeof(data));
+}
+
+static void pt3_mx_set_register(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, u8 value)
+{
+	u8 data[2] = {addr, value};
+	pt3_mx_write(adap, bus, data, sizeof(data));
+}
+
+static void pt3_mx_idac_setting(struct pt3_adapter *adap, struct pt3_bus *bus)
+{
+	u8 data[] = {
+		0x0D, 0x00,
+		0x0C, 0x67,
+		0x6F, 0x89,
+		0x70, 0x0C,
+		0x6F, 0x8A,
+		0x70, 0x0E,
+		0x6F, 0x8B,
+		0x70, 0x10+12,
+	};
+	pt3_mx_write(adap, bus, data, sizeof(data));
+}
+
+static void pt3_mx_tuner_rftune(struct pt3_adapter *adap, struct pt3_bus *bus, u32 freq)
+{
+	u8 data[100];
+	u32 size;
+
+	size = 0;
+	adap->freq = freq;
+	pt3_mx_rftune(data, &size, freq);
+	if (size != 20) {
+		pr_debug("fail mx_rftune size = %d\n", size);
+		return;
+	}
+	pt3_mx_write(adap, bus, data, 14);
+	msleep_interruptible(1);
+	pt3_mx_write(adap, bus, data + 14, 6);
+	msleep_interruptible(1);
+	pt3_mx_set_register(adap, bus, 0x1a, 0x0d);
+	pt3_mx_idac_setting(adap, bus);
+}
+
+static void pt3_mx_wakeup(struct pt3_adapter *adap)
+{
+	u8 data[2] = {0x01, 0x01};
+
+	pt3_mx_write(adap, NULL, data, sizeof(data));
+	pt3_mx_tuner_rftune(adap, NULL, adap->freq);
+}
+
+static void pt3_mx_set_sleep_mode(struct pt3_adapter *adap, bool sleep)
+{
+	if (sleep)
+		pt3_mx_standby(adap);
+	else
+		pt3_mx_wakeup(adap);
+}
+
+int pt3_mx_set_sleep(struct pt3_adapter *adap, bool sleep)
+{
+	int ret;
+
+	if (sleep) {
+		ret = pt3_tc_set_agc_t(adap, PT3_TC_AGC_MANUAL);
+		if (ret)
+			return ret;
+		pt3_mx_set_sleep_mode(adap, sleep);
+		pt3_tc_write_sleep_time(adap, sleep);
+	} else {
+		pt3_tc_write_sleep_time(adap, sleep);
+		pt3_mx_set_sleep_mode(adap, sleep);
+	}
+	adap->sleep = sleep;
+	return 0;
+}
+
+static u8 PT3_MX_FREQ_TABLE[][3] = {
+	{   2, 0,  3 },
+	{  12, 1, 22 },
+	{  21, 0, 12 },
+	{  62, 1, 63 },
+	{ 112, 0, 62 }
+};
+
+void pt3_mx_get_channel_frequency(struct pt3_adapter *adap, u32 channel, bool *catv, u32 *number, u32 *freq)
+{
+	u32 i;
+	s32 freq_offset = 0;
+
+	if (12 <= channel)
+		freq_offset += 2;
+	if (17 <= channel)
+		freq_offset -= 2;
+	if (63 <= channel)
+		freq_offset += 2;
+	*freq = 93 + channel * 6 + freq_offset;
+
+	for (i = 0; i < sizeof(PT3_MX_FREQ_TABLE) / sizeof(*PT3_MX_FREQ_TABLE); i++) {
+		if (channel <= PT3_MX_FREQ_TABLE[i][0]) {
+			*catv = PT3_MX_FREQ_TABLE[i][1] ? true : false;
+			*number = channel + PT3_MX_FREQ_TABLE[i][2] - PT3_MX_FREQ_TABLE[i][0];
+			break;
+		}
+	}
+}
+
+static u32 RF_TABLE[112] = {
+	0x058d3f49, 0x05e8ccc9, 0x06445a49, 0x069fe7c9, 0x06fb7549,
+	0x075702c9, 0x07b29049, 0x080e1dc9, 0x0869ab49, 0x08c538c9,
+	0x0920c649, 0x097c53c9, 0x09f665c9, 0x0a51f349, 0x0aad80c9,
+	0x0b090e49, 0x0b649bc9, 0x0ba1a4c9, 0x0bfd3249, 0x0c58bfc9,
+	0x0cb44d49, 0x0d0fdac9, 0x0d6b6849, 0x0dc6f5c9, 0x0e228349,
+	0x0e7e10c9, 0x0ed99e49, 0x0f352bc9, 0x0f90b949, 0x0fec46c9,
+	0x1047d449, 0x10a361c9, 0x10feef49, 0x115a7cc9, 0x11b60a49,
+	0x121197c9, 0x126d2549, 0x12c8b2c9, 0x13244049, 0x137fcdc9,
+	0x13db5b49, 0x1436e8c9, 0x14927649, 0x14ee03c9, 0x15499149,
+	0x15a51ec9, 0x1600ac49, 0x165c39c9, 0x16b7c749, 0x171354c9,
+	0x176ee249, 0x17ca6fc9, 0x1825fd49, 0x18818ac9, 0x18dd1849,
+	0x1938a5c9, 0x19943349, 0x19efc0c9, 0x1a4b4e49, 0x1aa6dbc9,
+	0x1b026949, 0x1b5df6c9, 0x1bb98449, 0x1c339649, 0x1c8f23c9,
+	0x1ceab149, 0x1d463ec9, 0x1da1cc49, 0x1dfd59c9, 0x1e58e749,
+	0x1eb474c9, 0x1f100249, 0x1f6b8fc9, 0x1fc71d49, 0x2022aac9,
+	0x207e3849, 0x20d9c5c9, 0x21355349, 0x2190e0c9, 0x21ec6e49,
+	0x2247fbc9, 0x22a38949, 0x22ff16c9, 0x235aa449, 0x23b631c9,
+	0x2411bf49, 0x246d4cc9, 0x24c8da49, 0x252467c9, 0x257ff549,
+	0x25db82c9, 0x26371049, 0x26929dc9, 0x26ee2b49, 0x2749b8c9,
+	0x27a54649, 0x2800d3c9, 0x285c6149, 0x28b7eec9, 0x29137c49,
+	0x296f09c9, 0x29ca9749, 0x2a2624c9, 0x2a81b249, 0x2add3fc9,
+	0x2b38cd49, 0x2b945ac9, 0x2befe849, 0x2c4b75c9, 0x2ca70349,
+	0x2d0290c9, 0x2d5e1e49,
+};
+
+static void pt3_mx_read(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, u8 *data)
+{
+	u8 write[2] = {0xfb, addr};
+
+	pt3_tc_write_tuner_without_addr(adap, bus, write, sizeof(write));
+	pt3_tc_read_tuner_without_addr(adap, bus, data);
+}
+
+static void pt3_mx_rfsynth_lock_status(struct pt3_adapter *adap, struct pt3_bus *bus, bool *locked)
+{
+	u8 data;
+
+	*locked = false;
+	pt3_mx_read(adap, bus, 0x16, &data);
+	data &= 0x0c;
+	if (data == 0x0c)
+		*locked = true;
+}
+
+static void pt3_mx_refsynth_lock_status(struct pt3_adapter *adap, struct pt3_bus *bus, bool *locked)
+{
+	u8 data;
+
+	*locked = false;
+	pt3_mx_read(adap, bus, 0x16, &data);
+	data &= 0x03;
+	if (data == 0x03)
+		*locked = true;
+}
+
+bool pt3_mx_locked(struct pt3_adapter *adap)
+{
+	bool locked1 = false, locked2 = false;
+	struct timeval begin, now;
+
+	do_gettimeofday(&begin);
+	while (1) {
+		do_gettimeofday(&now);
+		pt3_mx_rfsynth_lock_status(adap, NULL, &locked1);
+		pt3_mx_refsynth_lock_status(adap, NULL, &locked2);
+		if (locked1 && locked2)
+			break;
+		if (pt3_tc_time_diff(&begin, &now) > 1000)
+			break;
+		msleep_interruptible(1);
+	}
+	pr_debug("#%d mx locked1=%d locked2=%d\n", adap->idx, locked1, locked2);
+	return locked1 && locked2;
+}
+
+int pt3_mx_set_frequency(struct pt3_adapter *adap, u32 channel, s32 offset)
+{
+	bool catv;
+	u32 number, freq, real_freq;
+	int ret = pt3_tc_set_agc_t(adap, PT3_TC_AGC_MANUAL);
+
+	if (ret)
+		return ret;
+	pt3_mx_get_channel_frequency(adap, channel, &catv, &number, &freq);
+	pr_debug("#%d ch%d%s no%d %dHz\n", adap->idx, channel, catv ? " CATV" : "", number, freq);
+	/* real_freq = (7 * freq + 1 + offset) * 1000000.0/7.0; */
+	real_freq = RF_TABLE[channel];
+
+	pt3_mx_tuner_rftune(adap, NULL, real_freq);
+
+	return (!pt3_mx_locked(adap)) ? -ETIMEDOUT : pt3_tc_set_agc_t(adap, PT3_TC_AGC_AUTO);
+}
+
+int pt3_fe_set_freq(struct pt3_adapter *adap, u32 channel, s32 offset)
+{
+	int ret;
+
+	pr_debug("#%d %s set_freq channel=%d offset=%d\n", adap->idx, adap->str, channel, offset);
+
+	if (adap->type == SYS_ISDBS)
+		ret = pt3_qm_set_frequency(adap->qm, channel);
+	else
+		ret = pt3_mx_set_frequency(adap, channel, offset);
+	return ret;
+}
+
+int pt3_fe_tuner_sleep(struct pt3_adapter *adap, bool sleep)
+{
+	int ret;
+
+	pr_debug("#%d %p %s %s\n", adap->idx, adap, adap->str, sleep ? "Sleep" : "Wakeup");
+
+	if (adap->type == SYS_ISDBS)
+		ret = pt3_qm_set_sleep(adap->qm, sleep);
+	else
+		ret = pt3_mx_set_sleep(adap, sleep);
+	msleep_interruptible(10);
+	return ret;
+}
+
+/**** ISDB-S ****/
+
+enum pt3_fe_s_tune_state {
+	PT3S_IDLE,
+	PT3S_SET_FREQUENCY,
+	PT3S_SET_MODULATION,
+	PT3S_CHECK_MODULATION,
+	PT3S_SET_TS_ID,
+	PT3S_CHECK_TS_ID,
+	PT3S_TRACK,
+};
+
+struct pt3_fe_s_state {
+	struct pt3_adapter *adap;
+	struct dvb_frontend fe;
+	enum pt3_fe_s_tune_state tune_state;
+};
+
+static int pt3_fe_s_read_signal_strength(struct dvb_frontend *fe, u16 *cn)
+{
+	struct pt3_fe_s_state *state = fe->demodulator_priv;
+	return pt3_tc_read_cn_s(state->adap, NULL, (u32 *)cn);
+}
+
+static int pt3_fe_s_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static void pt3_fe_s_release(struct dvb_frontend *fe)
+{
+	kfree(fe->demodulator_priv);
+}
+
+static int pt3_fe_s_init(struct dvb_frontend *fe)
+{
+	struct pt3_fe_s_state *state = fe->demodulator_priv;
+	state->tune_state = PT3S_IDLE;
+	return pt3_qm_set_sleep(state->adap->qm, false);
+}
+
+static int pt3_fe_s_sleep(struct dvb_frontend *fe)
+{
+	struct pt3_fe_s_state *state = fe->demodulator_priv;
+	return pt3_qm_set_sleep(state->adap->qm, true);
+}
+
+u32 pt3_fe_s_get_channel(u32 frequency)
+{
+	u32 freq = frequency / 10,
+	    ch0 = (freq - 104948) / 3836, diff0 = freq - (104948 + 3836 * ch0),
+	    ch1 = (freq - 161300) / 4000, diff1 = freq - (161300 + 4000 * ch1),
+	    ch2 = (freq - 159300) / 4000, diff2 = freq - (159300 + 4000 * ch2),
+	    min = diff0 < diff1 ? diff0 : diff1;
+
+	if (diff2 < min)
+		return ch2 + 24;
+	else if (min == diff1)
+		return ch1 + 12;
+	else
+		return ch0;
+}
+
+static int pt3_fe_s_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct pt3_fe_s_state *state = fe->demodulator_priv;
+
+	switch (state->tune_state) {
+	case PT3S_IDLE:
+	case PT3S_SET_FREQUENCY:
+		*status = 0;
+		return 0;
+
+	case PT3S_SET_MODULATION:
+	case PT3S_CHECK_MODULATION:
+		*status |= FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3S_SET_TS_ID:
+	case PT3S_CHECK_TS_ID:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		return 0;
+
+	case PT3S_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+	BUG();
+}
+
+static int pt3_fe_s_tune(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
+	struct pt3_fe_s_state *state = fe->demodulator_priv;
+	struct pt3_adapter *adap = state->adap;
+	struct tmcc_s *tmcc = &adap->qm->tmcc;
+	int i, ret,
+	    freq = state->fe.dtv_property_cache.frequency,
+	    tsid = state->fe.dtv_property_cache.stream_id,
+	    ch = (freq < 1024) ? freq : pt3_fe_s_get_channel(freq);	/* consider as channel ID if low */
+
+	if (re_tune)
+		state->tune_state = PT3S_SET_FREQUENCY;
+
+	switch (state->tune_state) {
+	case PT3S_IDLE:
+		*delay = 3 * HZ;
+		*status = 0;
+		return 0;
+
+	case PT3S_SET_FREQUENCY:
+		pr_debug("#%d freq %d tsid 0x%x ch %d\n", adap->idx, freq, tsid, ch);
+		ret = pt3_qm_set_frequency(adap->qm, ch);
+		if (ret)
+			return ret;
+		adap->channel = ch;
+		state->tune_state = PT3S_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3S_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			ret = pt3_tc_read_tmcc_s(adap, NULL, tmcc);
+			if (!ret)
+				break;
+			msleep_interruptible(1);
+		}
+		if (ret) {
+			pr_debug("fail tc_read_tmcc_s ret=0x%x\n", ret);
+			return ret;
+		}
+		pr_debug("slots=%d,%d,%d,%d mode=%d,%d,%d,%d\n",
+				tmcc->slot[0], tmcc->slot[1], tmcc->slot[2], tmcc->slot[3],
+				tmcc->mode[0], tmcc->mode[1], tmcc->mode[2], tmcc->mode[3]);
+		state->tune_state = PT3S_CHECK_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3S_CHECK_MODULATION:
+		pr_debug("tmcc->id=0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x\n",
+				tmcc->id[0], tmcc->id[1], tmcc->id[2], tmcc->id[3],
+				tmcc->id[4], tmcc->id[5], tmcc->id[6], tmcc->id[7]);
+		for (i = 0; i < sizeof(tmcc->id)/sizeof(tmcc->id[0]); i++) {
+			pr_debug("tsid %x i %d tmcc->id %x\n", tsid, i, tmcc->id[i]);
+			if (tmcc->id[i] == tsid)
+				break;
+		}
+		if (tsid < sizeof(tmcc->id)/sizeof(tmcc->id[0]))	/* consider as slot# */
+			i = tsid;
+		if (i == sizeof(tmcc->id)/sizeof(tmcc->id[0])) {
+			pr_debug("#%d i%d tsid 0x%x not found\n", adap->idx, i, tsid);
+			return -EINVAL;
+		}
+		adap->offset = i;
+		pr_debug("#%d found tsid 0x%x on slot %d\n", adap->idx, tsid, i);
+		state->tune_state = PT3S_SET_TS_ID;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		return 0;
+
+	case PT3S_SET_TS_ID:
+		ret = pt3_tc_write_id_s(adap, NULL, (u16)tmcc->id[adap->offset]);
+		if (ret) {
+			pr_debug("fail set_tmcc_s ret=%d\n", ret);
+			return ret;
+		}
+		state->tune_state = PT3S_CHECK_TS_ID;
+		return 0;
+
+	case PT3S_CHECK_TS_ID:
+		for (i = 0; i < 1000; i++) {
+			u16 short_id;
+			ret = pt3_tc_read_id_s(adap, NULL, &short_id);
+			if (ret) {
+				pr_debug("fail get_id_s ret=%d\n", ret);
+				return ret;
+			}
+			tsid = short_id;
+			pr_debug("#%d tsid=0x%x\n", adap->idx, tsid);
+			if ((tsid & 0xffff) == tmcc->id[adap->offset])
+				break;
+			msleep_interruptible(1);
+		}
+		state->tune_state = PT3S_TRACK;
+
+	case PT3S_TRACK:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+	BUG();
+}
+
+static struct dvb_frontend_ops pt3_fe_s_ops = {
+	.delsys = { SYS_ISDBS },
+	.info = {
+		.name = "PT3 ISDB-S",
+		.frequency_min = 1,
+		.frequency_max = 2150000,
+		.frequency_stepsize = 1000,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_MULTISTREAM |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+	.read_signal_strength = pt3_fe_s_read_signal_strength,
+	.read_status = pt3_fe_s_read_status,
+	.get_frontend_algo = pt3_fe_s_get_frontend_algo,
+	.release = pt3_fe_s_release,
+	.init = pt3_fe_s_init,
+	.sleep = pt3_fe_s_sleep,
+	.tune = pt3_fe_s_tune,
+};
+
+struct dvb_frontend *pt3_fe_s_attach(struct pt3_adapter *adap)
+{
+	struct dvb_frontend *fe;
+	struct pt3_fe_s_state *state = kzalloc(sizeof(struct pt3_fe_s_state), GFP_KERNEL);
+
+	if (!state)
+		return NULL;
+	state->adap = adap;
+	fe = &state->fe;
+	memcpy(&fe->ops, &pt3_fe_s_ops, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = state;
+	return fe;
+}
+
+/**** ISDB-T ****/
+
+enum pt3_fe_t_tune_state {
+	PT3T_IDLE,
+	PT3T_SET_FREQUENCY,
+	PT3T_CHECK_FREQUENCY,
+	PT3T_SET_MODULATION,
+	PT3T_CHECK_MODULATION,
+	PT3T_TRACK,
+	PT3T_ABORT,
+};
+
+struct pt3_fe_t_state {
+	struct pt3_adapter *adap;
+	struct dvb_frontend fe;
+	enum pt3_fe_t_tune_state tune_state;
+};
+
+static int pt3_fe_t_read_signal_strength(struct dvb_frontend *fe, u16 *cn)
+{
+	struct pt3_fe_t_state *state = fe->demodulator_priv;
+	return pt3_tc_read_cndat_t(state->adap, NULL, (u32 *)cn);
+}
+
+static int pt3_fe_t_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static void pt3_fe_t_release(struct dvb_frontend *fe)
+{
+	kfree(fe->demodulator_priv);
+}
+
+static int pt3_fe_t_init(struct dvb_frontend *fe)
+{
+	struct pt3_fe_t_state *state = fe->demodulator_priv;
+	state->tune_state = PT3T_IDLE;
+	return pt3_mx_set_sleep(state->adap, false);
+}
+
+static int pt3_fe_t_sleep(struct dvb_frontend *fe)
+{
+	struct pt3_fe_t_state *state = fe->demodulator_priv;
+	return pt3_mx_set_sleep(state->adap, true);
+}
+
+static int pt3_fe_t_get_tmcc(struct pt3_adapter *adap, struct tmcc_t *tmcc)
+{
+	int b = 0, retryov, tmunvld, fulock;
+
+	if (unlikely(!tmcc))
+		return -EINVAL;
+	while (1) {
+		pt3_tc_read_retryov_tmunvld_fulock(adap, NULL, &retryov, &tmunvld, &fulock);
+		if (!fulock) {
+			b = 1;
+			break;
+		} else {
+			if (retryov)
+				break;
+		}
+		msleep_interruptible(1);
+	}
+	if (likely(b))
+		pt3_tc_read_tmcc_t(adap, NULL, tmcc);
+	return b ? 0 : -EBADMSG;
+}
+
+static int pt3_fe_t_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct pt3_fe_t_state *state = fe->demodulator_priv;
+
+	switch (state->tune_state) {
+	case PT3T_IDLE:
+	case PT3T_SET_FREQUENCY:
+	case PT3T_CHECK_FREQUENCY:
+		*status = 0;
+		return 0;
+
+	case PT3T_SET_MODULATION:
+	case PT3T_CHECK_MODULATION:
+	case PT3T_ABORT:
+		*status |= FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3T_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+	BUG();
+}
+
+#define NHK (RF_TABLE[77])
+int pt3_fe_t_freq(int freq)
+{
+	if (freq >= 90000000)
+		return freq;				/* real_freq	*/
+	if (freq > 255)
+		return NHK;
+	if (freq > 127)
+		return RF_TABLE[freq - 128];		/* freqno (IO#)	*/
+	if (freq > 63) {				/* CATV		*/
+		freq -= 64;
+		if (freq > 22)
+			return RF_TABLE[freq - 1];	/* C23-C62	*/
+		if (freq > 12)
+			return RF_TABLE[freq - 10];	/* C13-C22	*/
+		return NHK;
+	}
+	if (freq > 62)
+		return NHK;
+	if (freq > 12)
+		return RF_TABLE[freq + 50];		/* 13-62	*/
+	if (freq >  3)
+		return RF_TABLE[freq +  9];		/*  4-12	*/
+	if (freq)
+		return RF_TABLE[freq -  1];		/*  1-3		*/
+	return NHK;
+}
+
+static int pt3_fe_t_tune(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
+	struct pt3_fe_t_state *state = fe->demodulator_priv;
+	struct tmcc_t tmcc_t;
+	int ret, i;
+
+	if (re_tune)
+		state->tune_state = PT3T_SET_FREQUENCY;
+
+	switch (state->tune_state) {
+	case PT3T_IDLE:
+		*delay = 3 * HZ;
+		*status = 0;
+		return 0;
+
+	case PT3T_SET_FREQUENCY:
+		ret = pt3_tc_set_agc_t(state->adap, PT3_TC_AGC_MANUAL);
+		if (ret)
+			return ret;
+		pt3_mx_tuner_rftune(state->adap, NULL, pt3_fe_t_freq(state->fe.dtv_property_cache.frequency));
+		state->tune_state = PT3T_CHECK_FREQUENCY;
+		*delay = 0;
+		*status = 0;
+		return 0;
+
+	case PT3T_CHECK_FREQUENCY:
+		if (!pt3_mx_locked(state->adap)) {
+			*delay = HZ;
+			*status = 0;
+			return 0;
+		}
+		state->tune_state = PT3T_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3T_SET_MODULATION:
+		ret = pt3_tc_set_agc_t(state->adap, PT3_TC_AGC_AUTO);
+		if (ret)
+			return ret;
+		state->tune_state = PT3T_CHECK_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3T_CHECK_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			ret = pt3_fe_t_get_tmcc(state->adap, &tmcc_t);
+			if (!ret)
+				break;
+			msleep_interruptible(2);
+		}
+		if (ret) {
+			pr_debug("#%d fail get_tmcc_t ret=%d\n", state->adap->idx, ret);
+				state->tune_state = PT3T_ABORT;
+				*delay = HZ;
+				return 0;
+		}
+		state->tune_state = PT3T_TRACK;
+
+	case PT3T_TRACK:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
+	case PT3T_ABORT:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	BUG();
+}
+
+static struct dvb_frontend_ops pt3_fe_t_ops = {
+	.delsys = { SYS_ISDBT },
+	.info = {
+		.name = "PT3 ISDB-T",
+		.frequency_min = 1,
+		.frequency_max = 770000000,
+		.frequency_stepsize = 142857,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+	.read_signal_strength = pt3_fe_t_read_signal_strength,
+	.read_status = pt3_fe_t_read_status,
+	.get_frontend_algo = pt3_fe_t_get_frontend_algo,
+	.release = pt3_fe_t_release,
+	.init = pt3_fe_t_init,
+	.sleep = pt3_fe_t_sleep,
+	.tune = pt3_fe_t_tune,
+};
+
+struct dvb_frontend *pt3_fe_t_attach(struct pt3_adapter *adap)
+{
+	struct dvb_frontend *fe;
+	struct pt3_fe_t_state *state = kzalloc(sizeof(struct pt3_fe_t_state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+	state->adap = adap;
+	fe = &state->fe;
+	memcpy(&fe->ops, &pt3_fe_t_ops, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = state;
+	return fe;
+}
+
diff --git a/drivers/media/pci/pt3_dvb/pt3_i2c.c b/drivers/media/pci/pt3_dvb/pt3_i2c.c
new file mode 100644
index 0000000..d320b70
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/pt3_i2c.c
@@ -0,0 +1,64 @@
+#include "pt3.h"
+
+#define PT3_I2C_DATA_OFFSET 2048
+
+bool pt3_i2c_is_clean(struct pt3_i2c *i2c)
+{
+	return PT3_SHIFT_MASK(readl(i2c->reg[0] + REG_I2C_R), 3, 1);
+}
+
+void pt3_i2c_reset(struct pt3_i2c *i2c)
+{
+	writel(1 << 17, i2c->reg[0] + REG_I2C_W);	/* 0x00020000 */
+}
+
+static void pt3_i2c_wait(struct pt3_i2c *i2c, u32 *data)
+{
+	u32 val;
+
+	while (1) {
+		val = readl(i2c->reg[0] + REG_I2C_R);
+		if (!PT3_SHIFT_MASK(val, 0, 1))
+			break;
+		msleep_interruptible(1);
+	}
+	if (data)
+		*data = val;
+}
+
+void pt3_i2c_copy(struct pt3_i2c *i2c, struct pt3_bus *bus)
+{
+	u32 i;
+	u8 *src = &bus->cmds[0];
+	void __iomem *dst = i2c->reg[1] + PT3_I2C_DATA_OFFSET + (bus->cmd_addr / 2);
+
+	for (i = 0; i < bus->cmd_pos; i++)
+		writeb(src[i], dst + i);
+}
+
+int pt3_i2c_run(struct pt3_i2c *i2c, struct pt3_bus *bus, bool copy)
+{
+	int ret = 0;
+	u32 data, a, i, start_addr = bus->cmd_addr;
+
+	mutex_lock(&i2c->lock);
+	if (copy)
+		pt3_i2c_copy(i2c, bus);
+
+	pt3_i2c_wait(i2c, &data);
+	if (unlikely(start_addr >= (1 << 13)))
+		pr_debug("start address is over.\n");
+	writel(1 << 16 | start_addr, i2c->reg[0] + REG_I2C_W);
+	pt3_i2c_wait(i2c, &data);
+
+	a = PT3_SHIFT_MASK(data, 1, 2);
+	if (a) {
+		pr_debug("fail i2c run_code ret=0x%x\n", data);
+		ret = -EIO;
+	}
+	for (i = 0; i < bus->read_addr; i++)
+		pt3_bus_push_read_data(bus, readb(i2c->reg[1] + PT3_I2C_DATA_OFFSET + i));
+	mutex_unlock(&i2c->lock);
+	return ret;
+}
+
diff --git a/drivers/media/pci/pt3_dvb/pt3_tc.c b/drivers/media/pci/pt3_dvb/pt3_tc.c
new file mode 100644
index 0000000..a5fddd9
--- /dev/null
+++ b/drivers/media/pci/pt3_dvb/pt3_tc.c
@@ -0,0 +1,458 @@
+#include "pt3.h"
+
+int pt3_tc_write(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, const u8 *data, u32 size)
+{
+	int ret = 0;
+	u8 buf;
+	struct pt3_bus *p = bus ? bus : vzalloc(sizeof(struct pt3_bus));
+
+	if (!p) {
+		pr_debug("out of memory.\n");
+		return -ENOMEM;
+	}
+
+	pt3_bus_start(p);
+	buf = adap->addr_tc << 1;
+	pt3_bus_write(p, &buf, 1);
+	pt3_bus_write(p, &addr, 1);
+	pt3_bus_write(p, data, size);
+	pt3_bus_stop(p);
+
+	if (!bus) {
+		pt3_bus_end(p);
+		ret = pt3_i2c_run(adap->pt3->i2c, p, true);
+		vfree(p);
+	}
+	return ret;
+}
+
+static int pt3_tc_write_pskmsrst(struct pt3_adapter *adap)
+{
+	u8 buf = 0x01;
+	return pt3_tc_write(adap, NULL, 0x03, &buf, 1);
+}
+
+static int pt3_tc_write_imsrst(struct pt3_adapter *adap)
+{
+	u8 buf = 0x01 << 6;
+	return pt3_tc_write(adap, NULL, 0x01, &buf, 1);
+}
+
+int pt3_tc_init(struct pt3_adapter *adap)
+{
+	u8 buf = 0x10;
+
+	pr_debug("#%d %s tuner=0x%x tc=0x%x\n", adap->idx, adap->str, adap->addr_tuner, adap->addr_tc);
+	if (adap->type == SYS_ISDBS) {
+		int ret = pt3_tc_write_pskmsrst(adap);
+		return ret ? ret : pt3_tc_write(adap, NULL, 0x1e, &buf, 1);
+	} else {
+		int ret = pt3_tc_write_imsrst(adap);
+		return ret ? ret : pt3_tc_write(adap, NULL, 0x1c, &buf, 1);
+	}
+}
+
+int pt3_tc_set_powers(struct pt3_adapter *adap, struct pt3_bus *bus, bool tuner, bool amp)
+{
+	u8	tuner_power = tuner ? 0x03 : 0x02,
+		amp_power = amp ? 0x03 : 0x02,
+		data = (tuner_power << 6) | (0x01 << 4) | (amp_power << 2) | 0x01 << 0;
+	pr_debug("#%d tuner %s amp %s\n", adap->idx, tuner ? "ON" : "OFF", amp ? "ON" : "OFF");
+	return pt3_tc_write(adap, bus, 0x1e, &data, 1);
+}
+
+int pt3_tc_set_ts_pins_mode(struct pt3_adapter *adap, struct pt3_ts_pins_mode *mode)
+{
+	u32	clock_data = mode->clock_data,
+		byte = mode->byte,
+		valid = mode->valid;
+
+	if (clock_data)
+		clock_data++;
+	if (byte)
+		byte++;
+	if (valid)
+		valid++;
+	if (adap->type == SYS_ISDBS) {
+		u8 data[2];
+		int ret;
+		data[0] = 0x15 | (valid << 6);
+		data[1] = 0x04 | (clock_data << 4) | byte;
+		return (ret = pt3_tc_write(adap, NULL, 0x1c, &data[0], 1)) ?
+			ret : pt3_tc_write(adap, NULL, 0x1f, &data[1], 1);
+	} else {
+		u8 data = (u8)(0x01 | (clock_data << 6) | (byte << 4) | (valid << 2));
+		return pt3_tc_write(adap, NULL, 0x1d, &data, 1);
+	}
+}
+
+#define PT3_TC_THROUGH 0xfe
+int pt3_tc_write_tuner(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, const u8 *data, u32 size)
+{
+	int ret = 0;
+	u8 buf;
+	struct pt3_bus *p = bus ? bus : vzalloc(sizeof(struct pt3_bus));
+
+	if (!p) {
+		pr_debug("out of memory.\n");
+		return -ENOMEM;
+	}
+
+	pt3_bus_start(p);
+	buf = adap->addr_tc << 1;
+	pt3_bus_write(p, &buf, 1);
+	buf = PT3_TC_THROUGH;
+	pt3_bus_write(p, &buf, 1);
+	buf = adap->addr_tuner << 1;
+	pt3_bus_write(p, &buf, 1);
+	pt3_bus_write(p, &addr, 1);
+	pt3_bus_write(p, data, size);
+	pt3_bus_stop(p);
+
+	if (!bus) {
+		pt3_bus_end(p);
+		ret = pt3_i2c_run(adap->pt3->i2c, p, true);
+		vfree(p);
+	}
+	return ret;
+}
+
+int pt3_tc_read_tuner(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, u8 *data)
+{
+	int ret = 0;
+	u8 buf;
+	size_t rindex;
+
+	struct pt3_bus *p = bus ? bus : vzalloc(sizeof(struct pt3_bus));
+	if (!p) {
+		pr_debug("#%d tc_read_tuner out of memory\n", adap->idx);
+		return -ENOMEM;
+	}
+
+	pt3_bus_start(p);
+	buf = adap->addr_tc << 1;
+	pt3_bus_write(p, &buf, 1);
+	buf = PT3_TC_THROUGH;
+	pt3_bus_write(p, &buf, 1);
+	buf = adap->addr_tuner << 1;
+	pt3_bus_write(p, &buf, 1);
+	pt3_bus_write(p, &addr, 1);
+
+	pt3_bus_start(p);
+	buf = adap->addr_tc << 1;
+	pt3_bus_write(p, &buf, 1);
+	buf = PT3_TC_THROUGH;
+	pt3_bus_write(p, &buf, 1);
+	buf = (adap->addr_tuner << 1) | 1;
+	pt3_bus_write(p, &buf, 1);
+
+	pt3_bus_start(p);
+	buf = (adap->addr_tc << 1) | 1;
+	pt3_bus_write(p, &buf, 1);
+	rindex = pt3_bus_read(p, &buf, 1);
+	pt3_bus_stop(p);
+
+	if (!bus) {
+		pt3_bus_end(p);
+		ret = pt3_i2c_run(adap->pt3->i2c, p, true);
+		data[0] = pt3_bus_data1(p, rindex);
+		vfree(p);
+	}
+	pr_debug("#%d read_tuner addr_tc=0x%x addr_tuner=0x%x\n",
+		   adap->idx, adap->addr_tc, adap->addr_tuner);
+	return ret;
+}
+
+static u8 agc_data_s[2] = { 0xb0, 0x30 };
+
+u32 pt3_tc_index(struct pt3_adapter *adap)
+{
+	return PT3_SHIFT_MASK(adap->addr_tc, 1, 1);
+}
+
+int pt3_tc_set_agc_s(struct pt3_adapter *adap, enum pt3_tc_agc agc)
+{
+	u8 data = (agc == PT3_TC_AGC_AUTO) ? 0xff : 0x00;
+	int ret = pt3_tc_write(adap, NULL, 0x0a, &data, 1);
+	if (ret)
+		return ret;
+
+	data = agc_data_s[pt3_tc_index(adap)];
+	data |= (agc == PT3_TC_AGC_AUTO) ? 0x01 : 0x00;
+	ret = pt3_tc_write(adap, NULL, 0x10, &data, 1);
+	if (ret)
+		return ret;
+
+	data = (agc == PT3_TC_AGC_AUTO) ? 0x40 : 0x00;
+	return (ret = pt3_tc_write(adap, NULL, 0x11, &data, 1)) ? ret : pt3_tc_write_pskmsrst(adap);
+}
+
+int pt3_tc_set_sleep_s(struct pt3_adapter *adap, struct pt3_bus *bus, bool sleep)
+{
+	u8 buf = sleep ? 1 : 0;
+	return pt3_tc_write(adap, bus, 0x17, &buf, 1);
+}
+
+int pt3_tc_set_agc_t(struct pt3_adapter *adap, enum pt3_tc_agc agc)
+{
+	u8 data = (agc == PT3_TC_AGC_AUTO) ? 0x40 : 0x00;
+	int ret = pt3_tc_write(adap, NULL, 0x25, &data, 1);
+	if (ret)
+		return ret;
+
+	data = 0x4c | ((agc == PT3_TC_AGC_AUTO) ? 0x00 : 0x01);
+	return (ret = pt3_tc_write(adap, NULL, 0x23, &data, 1)) ? ret : pt3_tc_write_imsrst(adap);
+}
+
+int pt3_tc_write_tuner_without_addr(struct pt3_adapter *adap, struct pt3_bus *bus, const u8 *data, u32 size)
+{
+	int ret = 0;
+	u8 buf;
+	struct pt3_bus *p = bus ? bus : vzalloc(sizeof(struct pt3_bus));
+	if (!p) {
+		pr_debug("out of memory.\n");
+		return -ENOMEM;
+	}
+
+	pt3_bus_start(p);
+	buf = adap->addr_tc << 1;
+	pt3_bus_write(p, &buf, 1);
+	buf = PT3_TC_THROUGH;
+	pt3_bus_write(p, &buf, 1);
+	buf = adap->addr_tuner << 1;
+	pt3_bus_write(p, &buf, 1);
+	pt3_bus_write(p, data, size);
+	pt3_bus_stop(p);
+
+	if (!bus) {
+		pt3_bus_end(p);
+		ret = pt3_i2c_run(adap->pt3->i2c, p, true);
+		vfree(p);
+	}
+	return ret;
+}
+
+int pt3_tc_write_sleep_time(struct pt3_adapter *adap, int sleep)
+{
+	u8 data = (1 << 7) | ((sleep ? 1 : 0) << 4);
+	return pt3_tc_write(adap, NULL, 0x03, &data, 1);
+}
+
+u32 pt3_tc_time_diff(struct timeval *st, struct timeval *et)
+{
+	u32 diff = ((et->tv_sec - st->tv_sec) * 1000000 + (et->tv_usec - st->tv_usec)) / 1000;
+	pr_debug("time diff = %d\n", diff);
+	return diff;
+}
+
+int pt3_tc_read_tuner_without_addr(struct pt3_adapter *adap, struct pt3_bus *bus, u8 *data)
+{
+	int ret = 0;
+	u8 buf;
+	u32 rindex;
+	struct pt3_bus *p = bus ? bus : vzalloc(sizeof(struct pt3_bus));
+
+	if (!p) {
+		pr_debug("out of memory.\n");
+		return -ENOMEM;
+	}
+
+	pt3_bus_start(p);
+	buf = adap->addr_tc << 1;
+	pt3_bus_write(p, &buf, 1);
+	buf = PT3_TC_THROUGH;
+	pt3_bus_write(p, &buf, 1);
+	buf = (adap->addr_tuner << 1) | 0x01;
+	pt3_bus_write(p, &buf, 1);
+
+	pt3_bus_start(p);
+	buf = (adap->addr_tc << 1) | 0x01;
+	pt3_bus_write(p, &buf, 1);
+	rindex = pt3_bus_read(p, &buf, 1);
+	pt3_bus_stop(p);
+
+	if (!bus) {
+		pt3_bus_end(p);
+		ret = pt3_i2c_run(adap->pt3->i2c, p, true);
+		data[0] = pt3_bus_data1(p, rindex);
+		vfree(p);
+	}
+	pr_debug("#%d read_tuner_without addr_tc=0x%x addr_tuner=0x%x\n",
+		adap->idx, adap->addr_tc, adap->addr_tuner);
+	return ret;
+}
+
+static int pt3_tc_read(struct pt3_adapter *adap, struct pt3_bus *bus, u8 addr, u8 *data, u32 size)
+{
+	int ret = 0;
+	u8 buf[size];
+	u32 i, rindex;
+	struct pt3_bus *p = bus ? bus : vzalloc(sizeof(struct pt3_bus));
+	if (!p) {
+		pr_debug("out of memory.\n");
+		return -ENOMEM;
+	}
+
+	pt3_bus_start(p);
+	buf[0] = adap->addr_tc << 1;
+	pt3_bus_write(p, &buf[0], 1);
+	pt3_bus_write(p, &addr, 1);
+
+	pt3_bus_start(p);
+	buf[0] = adap->addr_tc << 1 | 1;
+	pt3_bus_write(p, &buf[0], 1);
+	rindex = pt3_bus_read(p, &buf[0], size);
+	pt3_bus_stop(p);
+
+	if (!bus) {
+		pt3_bus_end(p);
+		ret = pt3_i2c_run(adap->pt3->i2c, p, true);
+		for (i = 0; i < size; i++)
+			data[i] = pt3_bus_data1(p, rindex + i);
+		vfree(p);
+	}
+	return ret;
+}
+
+static u32 pt3_tc_byten(const u8 *data, u32 n)
+{
+	u32 i, value = 0;
+
+	for (i = 0; i < n; i++) {
+		value <<= 8;
+		value |= data[i];
+	}
+	return value;
+}
+
+int pt3_tc_read_cn_s(struct pt3_adapter *adap, struct pt3_bus *bus, u32 *cn)
+{
+	u8 data[2];
+	int ret = pt3_tc_read(adap, bus, 0xbc, data, sizeof(data));
+	if (!ret)
+		*cn = pt3_tc_byten(data, 2);
+	return ret;
+}
+
+int pt3_tc_read_cndat_t(struct pt3_adapter *adap, struct pt3_bus *bus, u32 *cn)
+{
+	u8 data[3];
+	int ret = pt3_tc_read(adap, bus, 0x8b, data, sizeof(data));
+	if (!ret)
+		*cn = pt3_tc_byten(data, 3);
+	return ret;
+}
+
+int pt3_tc_read_retryov_tmunvld_fulock(struct pt3_adapter *adap, struct pt3_bus *bus, int *retryov, int *tmunvld, int *fulock)
+{
+	u8 data;
+	int ret = pt3_tc_read(adap, bus, 0x80, &data, 1);
+	if (!ret) {
+		*retryov = PT3_SHIFT_MASK(data, 7, 1) ? 1 : 0;
+		*tmunvld = PT3_SHIFT_MASK(data, 5, 1) ? 1 : 0;
+		*fulock  = PT3_SHIFT_MASK(data, 3, 1) ? 1 : 0;
+	}
+	return ret;
+}
+
+int pt3_tc_read_tmcc_t(struct pt3_adapter *adap, struct pt3_bus *bus, struct tmcc_t *tmcc)
+{
+	u32 interleave0h, interleave0l, segment1h, segment1l;
+	u8 data[8];
+
+	int ret = pt3_tc_read(adap, bus, 0xb2+0, &data[0], 4);
+	if (ret)
+		return ret;
+	ret = pt3_tc_read(adap, bus, 0xb2+4, &data[4], 4);
+	if (ret)
+		return ret;
+
+	tmcc->system    = PT3_SHIFT_MASK(data[0], 6, 2);
+	tmcc->indicator = PT3_SHIFT_MASK(data[0], 2, 4);
+	tmcc->emergency = PT3_SHIFT_MASK(data[0], 1, 1);
+	tmcc->partial   = PT3_SHIFT_MASK(data[0], 0, 1);
+
+	tmcc->mode[0] = PT3_SHIFT_MASK(data[1], 5, 3);
+	tmcc->mode[1] = PT3_SHIFT_MASK(data[2], 0, 3);
+	tmcc->mode[2] = PT3_SHIFT_MASK(data[4], 3, 3);
+
+	tmcc->rate[0] = PT3_SHIFT_MASK(data[1], 2, 3);
+	tmcc->rate[1] = PT3_SHIFT_MASK(data[3], 5, 3);
+	tmcc->rate[2] = PT3_SHIFT_MASK(data[4], 0, 3);
+
+	interleave0h = PT3_SHIFT_MASK(data[1], 0, 2);
+	interleave0l = PT3_SHIFT_MASK(data[2], 7, 1);
+
+	tmcc->interleave[0] = interleave0h << 1 | interleave0l << 0;
+	tmcc->interleave[1] = PT3_SHIFT_MASK(data[3], 2, 3);
+	tmcc->interleave[2] = PT3_SHIFT_MASK(data[5], 5, 3);
+
+	segment1h = PT3_SHIFT_MASK(data[3], 0, 2);
+	segment1l = PT3_SHIFT_MASK(data[4], 6, 2);
+
+	tmcc->segment[0] = PT3_SHIFT_MASK(data[2], 3, 4);
+	tmcc->segment[1] = segment1h << 2 | segment1l << 0;
+	tmcc->segment[2] = PT3_SHIFT_MASK(data[5], 1, 4);
+
+	return ret;
+}
+
+int pt3_tc_read_tmcc_s(struct pt3_adapter *adap, struct pt3_bus *bus, struct tmcc_s *tmcc)
+{
+	enum {
+		BASE = 0xc5,
+		SIZE = 0xe5 - BASE + 1
+	};
+	u8 data[SIZE];
+	u32 i, byte_offset, bit_offset;
+
+	int ret = pt3_tc_read(adap, bus, 0xc3, data, 1);
+	if (ret)
+		return ret;
+	if (PT3_SHIFT_MASK(data[0], 4, 1))
+		return -EBADMSG;
+
+	ret = pt3_tc_read(adap, bus, 0xce, data, 2);
+	if (ret)
+		return ret;
+	if (pt3_tc_byten(data, 2) == 0)
+		return -EBADMSG;
+
+	ret = pt3_tc_read(adap, bus, 0xc3, data, 1);
+	if (ret)
+		return ret;
+	tmcc->emergency = PT3_SHIFT_MASK(data[0], 2, 1);
+	tmcc->extflag   = PT3_SHIFT_MASK(data[0], 1, 1);
+
+	ret = pt3_tc_read(adap, bus, 0xc5, data, SIZE);
+	if (ret)
+		return ret;
+	tmcc->indicator = PT3_SHIFT_MASK(data[0xc5 - BASE], 3, 5);
+	tmcc->uplink    = PT3_SHIFT_MASK(data[0xc7 - BASE], 0, 4);
+
+	for (i = 0; i < 4; i++) {
+		byte_offset = i / 2;
+		bit_offset = (i % 2) ? 0 : 4;
+		tmcc->mode[i] = PT3_SHIFT_MASK(data[0xc8 + byte_offset - BASE], bit_offset, 4);
+		tmcc->slot[i] = PT3_SHIFT_MASK(data[0xca + i - BASE], 0, 6);
+	}
+	for (i = 0; i < 8; i++)
+		tmcc->id[i] = pt3_tc_byten(data + 0xce + i * 2 - BASE, 2);
+	return ret;
+}
+
+int pt3_tc_write_id_s(struct pt3_adapter *adap, struct pt3_bus *bus, u16 id)
+{
+	u8 data[2] = { id >> 8, (u8)id };
+	return pt3_tc_write(adap, bus, 0x8f, data, sizeof(data));
+}
+
+int pt3_tc_read_id_s(struct pt3_adapter *adap, struct pt3_bus *bus, u16 *id)
+{
+	u8 data[2];
+	int ret = pt3_tc_read(adap, bus, 0xe6, data, sizeof(data));
+	if (!ret)
+		*id = pt3_tc_byten(data, 2);
+	return ret;
+}
+
