Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:51118 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdILRjm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 13:39:42 -0400
Date: Tue, 12 Sep 2017 20:39:35 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 1/3] drm: add support for DisplayPort
 CEC-Tunneling-over-AUX
Message-ID: <20170912173935.GB4914@intel.com>
References: <20170911112547.7133-1-hverkuil@xs4all.nl>
 <20170911112547.7133-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170911112547.7133-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 11, 2017 at 01:25:45PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This adds support for the DisplayPort CEC-Tunneling-over-AUX
> feature that is part of the DisplayPort 1.3 standard.
> 
> Unfortunately, not all DisplayPort/USB-C to HDMI adapters with a
> chip that has this capability actually hook up the CEC pin, so
> even though a CEC device is created, it may not actually work.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Carlos Santa <carlos.santa@intel.com>
> ---
>  drivers/gpu/drm/Kconfig      |  10 ++
>  drivers/gpu/drm/Makefile     |   1 +
>  drivers/gpu/drm/drm_dp_cec.c | 301 +++++++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_dp_helper.h  |  24 ++++
>  4 files changed, 336 insertions(+)
>  create mode 100644 drivers/gpu/drm/drm_dp_cec.c
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index 83cb2a88c204..1f2708df5c4e 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -120,6 +120,16 @@ config DRM_LOAD_EDID_FIRMWARE
>  	  default case is N. Details and instructions how to build your own
>  	  EDID data are given in Documentation/EDID/HOWTO.txt.
>  
> +config DRM_DP_CEC
> +	bool "Enable DisplayPort CEC-Tunneling-over-AUX HDMI support"
> +	select CEC_CORE
> +	help
> +	  Choose this option if you want to enable HDMI CEC support for
> +	  DisplayPort/USB-C to HDMI adapters.
> +
> +	  Note: not all adapters support this feature, and even for those
> +	  that do support this they often do not hook up the CEC pin.
> +
>  config DRM_TTM
>  	tristate
>  	depends on DRM && MMU
> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
> index 24a066e1841c..c6552c62049e 100644
> --- a/drivers/gpu/drm/Makefile
> +++ b/drivers/gpu/drm/Makefile
> @@ -40,6 +40,7 @@ drm_kms_helper-$(CONFIG_DRM_LOAD_EDID_FIRMWARE) += drm_edid_load.o
>  drm_kms_helper-$(CONFIG_DRM_FBDEV_EMULATION) += drm_fb_helper.o
>  drm_kms_helper-$(CONFIG_DRM_KMS_CMA_HELPER) += drm_fb_cma_helper.o
>  drm_kms_helper-$(CONFIG_DRM_DP_AUX_CHARDEV) += drm_dp_aux_dev.o
> +drm_kms_helper-$(CONFIG_DRM_DP_CEC) += drm_dp_cec.o
>  
>  obj-$(CONFIG_DRM_KMS_HELPER) += drm_kms_helper.o
>  obj-$(CONFIG_DRM_DEBUG_MM_SELFTEST) += selftests/
> diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
> new file mode 100644
> index 000000000000..b831bb72c932
> --- /dev/null
> +++ b/drivers/gpu/drm/drm_dp_cec.c
> @@ -0,0 +1,301 @@
> +/*
> + * DisplayPort CEC-Tunneling-over-AUX support
> + *
> + * Copyright 2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <drm/drm_dp_helper.h>
> +#include <media/cec.h>
> +
> +/*
> + * Unfortunately it turns out that we have a chicken-and-egg situation
> + * here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
> + * have a converter chip that supports CEC-Tunneling-over-AUX (usually the
> + * Parade PS176), but they do not wire up the CEC pin, thus making CEC
> + * useless.
> + *
> + * Sadly there is no way for this driver to know this. What happens is
> + * that a /dev/cecX device is created that is isolated and unable to see
> + * any of the other CEC devices. Quite literally the CEC wire is cut
> + * (or in this case, never connected in the first place).
> + *
> + * I suspect that the reason so few adapters support this is that this
> + * tunneling protocol was never supported by any OS. So there was no
> + * easy way of testing it, and no incentive to correctly wire up the
> + * CEC pin.
> + *
> + * Hopefully by creating this driver it will be easier for vendors to
> + * finally fix their adapters and test the CEC functionality.
> + *
> + * I keep a list of known working adapters here:
> + *
> + * https://hverkuil.home.xs4all.nl/cec-status.txt
> + *
> + * Please mail me (hverkuil@xs4all.nl) if you find an adapter that works
> + * and is not yet listed there.
> + */
> +
> +/**
> + * DOC: dp cec helpers
> + *
> + * These functions take care of supporting the CEC-Tunneling-over-AUX
> + * feature of DisplayPort-to-HDMI adapters.
> + */
> +
> +static int drm_dp_cec_adap_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	u32 val = enable ? DP_CEC_TUNNELING_ENABLE : 0;
> +	ssize_t err = 0;
> +
> +	err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
> +	return (enable && err < 0) ? err : 0;
> +}
> +
> +static int drm_dp_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	/* Bit 15 (logical address 15) should always be set */
> +	u16 la_mask = 1 << CEC_LOG_ADDR_BROADCAST;
> +	u8 mask[2];
> +	ssize_t err;
> +
> +	if (addr != CEC_LOG_ADDR_INVALID)
> +		la_mask |= adap->log_addrs.log_addr_mask | (1 << addr);
> +	mask[0] = la_mask & 0xff;
> +	mask[1] = la_mask >> 8;
> +	err = drm_dp_dpcd_write(aux, DP_CEC_LOGICAL_ADDRESS_MASK, mask, 2);
> +	return (addr != CEC_LOG_ADDR_INVALID && err < 0) ? err : 0;
> +}
> +
> +static int drm_dp_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
> +				    u32 signal_free_time, struct cec_msg *msg)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	unsigned int retries = min(5, attempts - 1);
> +	ssize_t err;
> +
> +	err = drm_dp_dpcd_write(aux, DP_CEC_TX_MESSAGE_BUFFER,
> +				msg->msg, msg->len);
> +	if (err < 0)
> +		return err;

What happens if we managed to write the data only partially?

Looking at our code, I *think* we can't actally return 0 ever, so the 
_writeb() variant seem safe with the <0 checks. But the full _write()
could certainly return something between 1 and the total size.

> +
> +	err = drm_dp_dpcd_writeb(aux, DP_CEC_TX_MESSAGE_INFO,
> +				 (msg->len - 1) | (retries << 4) |
> +				 DP_CEC_TX_MESSAGE_SEND);
> +	return err < 0 ? err : 0;
> +}
> +
> +static int drm_dp_cec_adap_monitor_all_enable(struct cec_adapter *adap,
> +					      bool enable)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	ssize_t err;
> +	u8 val;
> +
> +	if (!(adap->capabilities & CEC_CAP_MONITOR_ALL))
> +		return 0;
> +
> +	err = drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CONTROL, &val);
> +	if (err >= 0) {
> +		if (enable)
> +			val |= DP_CEC_SNOOPING_ENABLE;
> +		else
> +			val &= ~DP_CEC_SNOOPING_ENABLE;
> +		err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
> +	}
> +	return (enable && err < 0) ? err : 0;
> +}
> +
> +static void drm_dp_cec_adap_status(struct cec_adapter *adap,
> +				   struct seq_file *file)
> +{
> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
> +	u8 buf[DP_AUX_MAX_PAYLOAD_BYTES];
> +	u8 hw_rev;
> +
> +	if (drm_dp_dpcd_read(aux, DP_BRANCH_OUI,
> +			     buf, sizeof(buf)) != sizeof(buf))
> +		return;
> +	hw_rev = buf[9];
> +	buf[9] = 0;
> +	seq_printf(file, "OUI: %02x-%02x-%02x\n",
> +		   buf[0], buf[1], buf[2]);
> +	seq_printf(file, "ID: %s\n", buf + 3);
> +	seq_printf(file, "HW Rev: %d.%d\n", hw_rev >> 4, hw_rev & 0xf);
> +	/*
> +	 * Show this both in decimal and hex: at least one vendor
> +	 * always reports this in hex.
> +	 */
> +	seq_printf(file, "FW/SW Rev: %d.%d (0x%02x.0x%02x)\n",
> +		   buf[10], buf[11], buf[10], buf[11]);

I believe struct drm_dp_dpcd_ident provides a slightly easier way to
parse these registers.

> +}
> +
> +static const struct cec_adap_ops drm_dp_cec_adap_ops = {
> +	.adap_enable = drm_dp_cec_adap_enable,
> +	.adap_log_addr = drm_dp_cec_adap_log_addr,
> +	.adap_transmit = drm_dp_cec_adap_transmit,
> +	.adap_monitor_all_enable = drm_dp_cec_adap_monitor_all_enable,
> +	.adap_status = drm_dp_cec_adap_status,
> +};
> +
> +static int drm_dp_cec_received(struct drm_dp_aux *aux)
> +{
> +	struct cec_adapter *adap = aux->cec_adap;
> +	struct cec_msg msg;
> +	u8 rx_msg_info;
> +	ssize_t err;
> +
> +	err = drm_dp_dpcd_readb(aux, DP_CEC_RX_MESSAGE_INFO, &rx_msg_info);
> +	if (err < 0)
> +		return err;
> +	if (!(rx_msg_info & DP_CEC_RX_MESSAGE_ENDED))
> +		return 0;
> +	msg.len = (rx_msg_info & DP_CEC_RX_MESSAGE_LEN_MASK) + 1;
> +	err = drm_dp_dpcd_read(aux, DP_CEC_RX_MESSAGE_BUFFER, msg.msg, msg.len);
> +	if (err < 0)
> +		return err;
> +	cec_received_msg(adap, &msg);
> +	return 0;

nit: The code in general feels a bit crowded. Could use a few more
empty lines IMO.

> +}
> +
> +static int drm_dp_cec_handle_irq(struct drm_dp_aux *aux)
> +{
> +	struct cec_adapter *adap = aux->cec_adap;
> +	u8 flags;
> +	ssize_t err;
> +
> +	err = drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, &flags);
> +	if (err < 0)
> +		return err;
> +
> +	if (flags & DP_CEC_RX_MESSAGE_INFO_VALID)
> +		drm_dp_cec_received(aux);
> +
> +	if (flags & DP_CEC_TX_MESSAGE_SENT)
> +		cec_transmit_attempt_done(adap, CEC_TX_STATUS_OK);
> +	else if (flags & DP_CEC_TX_LINE_ERROR)
> +		cec_transmit_attempt_done(adap, CEC_TX_STATUS_ERROR |
> +						CEC_TX_STATUS_MAX_RETRIES);
> +	else if (flags &
> +		 (DP_CEC_TX_ADDRESS_NACK_ERROR | DP_CEC_TX_DATA_NACK_ERROR))
> +		cec_transmit_attempt_done(adap, CEC_TX_STATUS_NACK |
> +						CEC_TX_STATUS_MAX_RETRIES);
> +	drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_IRQ_FLAGS, flags);
> +	return 0;
> +}
> +
> +/**
> + * drm_dp_cec_irq() - handle CEC interrupt, if any
> + * @aux: DisplayPort AUX channel
> + *
> + * Should be called when handling an IRQ_HPD request. If CEC-tunneling-over-AUX
> + * is present, then it will check for a CEC_IRQ and handle it accordingly.
> + *
> + * Returns true if an interrupt was handled successfully or false otherwise.
> + */
> +bool drm_dp_cec_irq(struct drm_dp_aux *aux)
> +{
> +	bool handled = false;
> +	int attempts;
> +
> +	if (!aux->cec_adap)
> +		return false;
> +
> +	for (attempts = 0; attempts < 4; attempts++) {

What's the deal with this loop?

> +		u8 cec_irq;
> +		int ret;
> +
> +		ret = drm_dp_dpcd_readb(aux, DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
> +					&cec_irq);

I believe ESI only exists for DPCD 1.2+. Are we protected from reaching
this on earlier devices? Hmm. I guess the cec_adap check should protect us.

Supposedly DPCD should just return zeroes for nonexisting registers, but
I've seen at least one device that failed on that front. In that
particular case there were just a handful of bytes in the entire DPCD
address space that couldn't be read succesfully.

I don't entirely like this function doing irq read/ack part. There
really should be some kind of central sink irq dispatch thingy, but
since we don't have that currently I think this is an OK approach.
At some point I did start on trying to clean up the sink irq handling
mess, but I didn't get very far with it before I had to move on to
something else.

> +		if (ret < 0 || !(cec_irq & DP_CEC_IRQ))
> +			break;
> +
> +		if (!drm_dp_cec_handle_irq(aux))
> +			handled = true;
> +
> +		ret = drm_dp_dpcd_writeb(aux, DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
> +					 DP_CEC_IRQ);
> +		if (ret < 0)
> +			break;
> +	}
> +	return handled;
> +}
> +EXPORT_SYMBOL(drm_dp_cec_irq);
> +
> +/**
> + * drm_dp_cec_configure_adapter() - configure the CEC adapter
> + * @aux: DisplayPort AUX channel
> + * @name: name of the CEC device
> + * @parent: parent device
> + *
> + * Checks if this is a DisplayPort-to-HDMI adapter that supports
> + * CEC-tunneling-over-AUX, and if so it creates a CEC device.
> + *
> + * If a CEC device was already created, then check if the capabilities
> + * have changed. If not, then do nothing. Otherwise destroy the old
> + * CEC device and create a new CEC device.
> + *
> + * This can happen when one DP-to-HDMI adapter is disconnected and
> + * replaced by another adapter with different CEC capabilities.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char *name,
> +				 struct device *parent)
> +{
> +	u32 cec_caps = CEC_CAP_DEFAULTS | CEC_CAP_NEEDS_HPD;
> +	unsigned int num_las = 1;
> +	int err;
> +	u8 cap;
> +
> +	if (drm_dp_dpcd_readb(aux, DP_CEC_TUNNELING_CAPABILITY, &cap) != 1 ||
> +	    !(cap & DP_CEC_TUNNELING_CAPABLE)) {
> +		cec_unregister_adapter(aux->cec_adap);
> +		aux->cec_adap = NULL;
> +		return -ENODEV;
> +	}
> +
> +	if (cap & DP_CEC_SNOOPING_CAPABLE)
> +		cec_caps |= CEC_CAP_MONITOR_ALL;
> +	if (cap & DP_CEC_MULTIPLE_LA_CAPABLE)
> +		num_las = CEC_MAX_LOG_ADDRS;
> +
> +	if (aux->cec_adap) {
> +		if (aux->cec_adap->capabilities == cec_caps &&
> +		    aux->cec_adap->available_log_addrs == num_las)
> +			return 0;
> +		cec_unregister_adapter(aux->cec_adap);
> +	}
> +
> +	aux->cec_adap = cec_allocate_adapter(&drm_dp_cec_adap_ops,
> +			 aux, name, cec_caps, num_las);
> +	if (IS_ERR(aux->cec_adap)) {
> +		err = PTR_ERR(aux->cec_adap);
> +		aux->cec_adap = NULL;
> +		return err;
> +	}
> +	err = cec_register_adapter(aux->cec_adap, parent);
> +	if (err) {
> +		cec_delete_adapter(aux->cec_adap);
> +		aux->cec_adap = NULL;
> +	}
> +	return err;
> +}
> +EXPORT_SYMBOL(drm_dp_cec_configure_adapter);
> diff --git a/include/drm/drm_dp_helper.h b/include/drm/drm_dp_helper.h
> index b17476a6909c..0e236dd40b42 100644
> --- a/include/drm/drm_dp_helper.h
> +++ b/include/drm/drm_dp_helper.h
> @@ -952,6 +952,8 @@ struct drm_dp_aux_msg {
>  	size_t size;
>  };
>  
> +struct cec_adapter;
> +
>  /**
>   * struct drm_dp_aux - DisplayPort AUX channel
>   * @name: user-visible name of this AUX channel and the I2C-over-AUX adapter
> @@ -1010,6 +1012,10 @@ struct drm_dp_aux {
>  	 * @i2c_defer_count: Counts I2C DEFERs, used for DP validation.
>  	 */
>  	unsigned i2c_defer_count;
> +	/**
> +	 * @cec_adap: the CEC adapter for CEC-Tunneling-over-AUX support.
> +	 */
> +	struct cec_adapter *cec_adap;
>  };
>  
>  ssize_t drm_dp_dpcd_read(struct drm_dp_aux *aux, unsigned int offset,
> @@ -1132,4 +1138,22 @@ drm_dp_has_quirk(const struct drm_dp_desc *desc, enum drm_dp_quirk quirk)
>  	return desc->quirks & BIT(quirk);
>  }
>  
> +#ifdef CONFIG_DRM_DP_CEC
> +bool drm_dp_cec_irq(struct drm_dp_aux *aux);
> +int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux, const char *name,
> +				 struct device *parent);
> +#else
> +static inline bool drm_dp_cec_irq(struct drm_dp_aux *aux)
> +{
> +	return false;
> +}
> +
> +static inline int drm_dp_cec_configure_adapter(struct drm_dp_aux *aux,
> +					       const char *name,
> +					       struct device *parent)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
>  #endif /* _DRM_DP_HELPER_H_ */
> -- 
> 2.14.1

-- 
Ville Syrjälä
Intel OTC
