Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtp18-01-2.prod.phx3.secureserver.net ([173.201.193.182]:35403
	"EHLO p3plwbeout18-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab3EXH0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 May 2013 03:26:50 -0400
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Message-Id: <20130524002648.e7c3a0fec861aa4693105436139f36a5.be52ad9937.wbe@email18.secureserver.net>
From: <leo@lumanate.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Jeff Hansen" <x@jeffhansen.com>, linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
Subject: RE: [PATCH] [media] hdpvr: Disable IR receiver by default.
Date: Fri, 24 May 2013 00:26:48 -0700
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, Jeff,

Yes, the FW instability is a known issue. It's not just the IR
polling. For example frequent polling for video lock will cause
FW crash as well. In windows driver there's a workaround for
this issue - all USB calls are serialized and surrounded by
small delays which makes HDPVR fairly stable. In fact, I implemented
this same workaround on Linux driver about a month ago but stashed
it due to lack of free time. If somebody is interested and willing
to test - I can provide a patch.

To answer the following email from Jeff - as far as I know
HDPVR firmware was released by Ambarella as a binary image only.

Best regards,
-Leo.


-------- Original Message --------
Subject: Re: [PATCH] [media] hdpvr: Disable IR receiver by default.
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, May 23, 2013 1:41 am
To: Leonid Kegulskiy <leo@lumanate.com>
Cc: Jeff Hansen <x@jeffhansen.com>, linux-media@vger.kernel.org, Mauro
Carvalho Chehab <mchehab@redhat.com>

On Tue 14 May 2013 06:44:19 Jeff Hansen wrote:
> All of the firmwares I've tested, including 0x1e, will inevitably crash
> before recording for even 10 minutes. There must be a race condition of
> IR RX vs. video-encoding in the firmware, because if you disable IR receiver
> polling, then the firmware is stable again. I'd guess that most people don't
> use this feature anyway, so we might as well disable it by default, and
> warn them that it might be unstable until Hauppauge fixes it in a future
> firmware.

Leonid, have you ever seen this? Can you verify that this happens for
you
as well?

Regards,

 Hans

> 
> Signed-off-by: Jeff Hansen <x@jeffhansen.com>
> ---
> drivers/media/usb/hdpvr/hdpvr-core.c | 16 +++++++++++-----
> 1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
> index 8247c19..3e80202 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-core.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-core.c
> @@ -53,6 +53,10 @@ static bool boost_audio;
> module_param(boost_audio, bool, S_IRUGO|S_IWUSR);
> MODULE_PARM_DESC(boost_audio, "boost the audio signal");
> 
> +int ir_rx_enable;
> +module_param(ir_rx_enable, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(ir_rx_enable, "Enable HDPVR IR receiver (firmware may be unstable)");
> +
> 
> /* table of devices that work with this driver */
> static struct usb_device_id hdpvr_table[] = {
> @@ -394,11 +398,13 @@ static int hdpvr_probe(struct usb_interface *interface,
> goto error;
> }
> 
> - client = hdpvr_register_ir_rx_i2c(dev);
> - if (!client) {
> - v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
> - retval = -ENODEV;
> - goto reg_fail;
> + if (ir_rx_enable) {
> + client = hdpvr_register_ir_rx_i2c(dev);
> + if (!client) {
> + v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
> + retval = -ENODEV;
> + goto reg_fail;
> + }
> }
> 
> client = hdpvr_register_ir_tx_i2c(dev);
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
