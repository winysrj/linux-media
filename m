Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59427 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaIAX65 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Sep 2014 19:58:57 -0400
Message-ID: <5405083A.3010207@iki.fi>
Date: Tue, 02 Sep 2014 02:58:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Changbing Xiong <cb.xiong@samsung.com>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH 3/3] media: check status of dmxdev->exit in poll functions
 of demux&dvr
References: <1408586740-2169-1-git-send-email-cb.xiong@samsung.com>
In-Reply-To: <1408586740-2169-1-git-send-email-cb.xiong@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Changbing and thanks to working that.

I reviewed the first patch and tested all these patches. It does not 
deadlock USB device anymore because of patch #1 so it is improvement. 
However, what I expect that patch, it should force device unregister but 
when I use tzap and unplug running device, it does not stop tzap, but 
continues zapping until app is killed using ctrl-c.
I used same(?) WinTV Aero for my tests.
$ tzap -r "YLE TV1" -a 0 -f 1 -c ~/.tzap/channels.conf_

Sep 02 02:50:38 localhost.localdomain kernel: usb 1-2: USB disconnect, 
device number 6
Sep 02 02:50:38 localhost.localdomain kernel: [57] dvb_usbv2_disconnect: 
usb 1-2: dvb_usbv2_disconnect: bInterfaceNumber=0
Sep 02 02:50:38 localhost.localdomain kernel: [57] dvb_usbv2_exit: usb 
1-2: dvb_usbv2_exit:
Sep 02 02:50:38 localhost.localdomain kernel: [57] 
dvb_usbv2_remote_exit: usb 1-2: dvb_usbv2_remote_exit:
Sep 02 02:50:38 localhost.localdomain kernel: [57] 
dvb_usbv2_adapter_exit: usb 1-2: dvb_usbv2_adapter_exit:
Sep 02 02:50:38 localhost.localdomain kernel: [57] 
dvb_usbv2_adapter_dvb_exit: usb 1-2: dvb_usbv2_adapter_dvb_exit: adap=0
Sep 02 02:50:38 localhost.localdomain kernel: [24239] 
dvb_usb_v2_generic_io: usb 1-2: dvb_usb_v2_generic_io: >>> aa 28
Sep 02 02:50:38 localhost.localdomain kernel: usb 1-2: dvb_usb_v2: 
usb_bulk_msg() failed=-19
Sep 02 02:50:38 localhost.localdomain kernel: 
mxl1x1sf_demod_get_rs_lock_status: error -19 on line 232
Sep 02 02:50:38 localhost.localdomain kernel: 
mxl111sf_demod_read_status: error -19 on line 452
Sep 02 02:50:39 localhost.localdomain kernel: [24238] 
dvb_usb_v2_generic_io: usb 1-2: dvb_usb_v2_generic_io: >>> aa 28
Sep 02 02:50:39 localhost.localdomain kernel: usb 1-2: dvb_usb_v2: 
usb_bulk_msg() failed=-19
Sep 02 02:50:39 localhost.localdomain kernel: 
mxl1x1sf_demod_get_rs_lock_status: error -19 on line 232
Sep 02 02:50:39 localhost.localdomain kernel: 
mxl111sf_demod_read_status: error -19 on line 452
Sep 02 02:50:39 localhost.localdomain kernel: [24238] 
dvb_usb_v2_generic_io: usb 1-2: dvb_usb_v2_generic_io: >>> aa 28
[.....]
Sep 02 02:50:42 localhost.localdomain kernel: [24238] 
dvb_usb_v2_generic_io: usb 1-2: dvb_usb_v2_generic_io: >>> aa 2e
Sep 02 02:50:42 localhost.localdomain kernel: usb 1-2: dvb_usb_v2: 
usb_bulk_msg() failed=-19
Sep 02 02:50:42 localhost.localdomain kernel: 
mxl111sf_demod_read_ucblocks: error -19 on line 350
Sep 02 02:50:42 localhost.localdomain kernel: [24238] dvb_usb_stop_feed: 
usb 1-2: dvb_usb_stop_feed: adap=0 active_fe=1 feed_type=0 setting pid 
[no]: 0200 (0512) at index 0
Sep 02 02:50:42 localhost.localdomain kernel: [24239] dvb_usb_fe_sleep: 
usb 1-2: dvb_usb_fe_sleep: adap=0 fe=1
Sep 02 02:50:42 localhost.localdomain kernel: [24238] dvb_usb_stop_feed: 
usb 1-2: dvb_usb_stop_feed: adap=0 active_fe=1 feed_type=0 setting pid 
[no]: 028a (0650) at index 1
Sep 02 02:50:42 localhost.localdomain kernel: [24238] usb_urb_killv2: 
usb 1-2: usb_urb_killv2: kill urb=0
Sep 02 02:50:42 localhost.localdomain kernel: [24238] usb_urb_killv2: 
usb 1-2: usb_urb_killv2: kill urb=1
Sep 02 02:50:42 localhost.localdomain kernel: [24238] usb_urb_killv2: 
usb 1-2: usb_urb_killv2: kill urb=2
Sep 02 02:50:42 localhost.localdomain kernel: [24238] usb_urb_killv2: 
usb 1-2: usb_urb_killv2: kill urb=3
Sep 02 02:50:42 localhost.localdomain kernel: [24238] usb_urb_killv2: 
usb 1-2: usb_urb_killv2: kill urb=4
Sep 02 02:50:42 localhost.localdomain kernel: [24239] 
dvb_usbv2_device_power_ctrl: usb 1-2: dvb_usbv2_device_power_ctrl: power=0
Sep 02 02:50:42 localhost.localdomain kernel: [24239] dvb_usb_fe_sleep: 
usb 1-2: dvb_usb_fe_sleep: ret=0
Sep 02 02:50:42 localhost.localdomain kernel: [57] 
dvb_usbv2_adapter_stream_exit: usb 1-2: dvb_usbv2_adapter_stream_exit: 
adap=0
Sep 02 02:50:42 localhost.localdomain kernel: [57] usb_urb_free_urbs: 
usb 1-2: usb_urb_free_urbs: free urb=4
Sep 02 02:50:42 localhost.localdomain kernel: [57] usb_urb_free_urbs: 
usb 1-2: usb_urb_free_urbs: free urb=3
Sep 02 02:50:42 localhost.localdomain kernel: [57] usb_urb_free_urbs: 
usb 1-2: usb_urb_free_urbs: free urb=2
Sep 02 02:50:42 localhost.localdomain kernel: [57] usb_urb_free_urbs: 
usb 1-2: usb_urb_free_urbs: free urb=1
Sep 02 02:50:42 localhost.localdomain kernel: [57] usb_urb_free_urbs: 
usb 1-2: usb_urb_free_urbs: free urb=0
Sep 02 02:50:42 localhost.localdomain kernel: [57] 
usb_free_stream_buffers: usb 1-2: usb_free_stream_buffers: free buf=4
Sep 02 02:50:42 localhost.localdomain kernel: [57] 
usb_free_stream_buffers: usb 1-2: usb_free_stream_buffers: free buf=3
Sep 02 02:50:42 localhost.localdomain kernel: [57] 
usb_free_stream_buffers: usb 1-2: usb_free_stream_buffers: free buf=2
Sep 02 02:50:42 localhost.localdomain kernel: [57] 
usb_free_stream_buffers: usb 1-2: usb_free_stream_buffers: free buf=1
Sep 02 02:50:42 localhost.localdomain kernel: [57] 
usb_free_stream_buffers: usb 1-2: usb_free_stream_buffers: free buf=0
Sep 02 02:50:42 localhost.localdomain kernel: [57] 
dvb_usbv2_adapter_frontend_exit: usb 1-2: 
dvb_usbv2_adapter_frontend_exit: adap=0
Sep 02 02:50:42 localhost.localdomain kernel: [57] dvb_usbv2_i2c_exit: 
usb 1-2: dvb_usbv2_i2c_exit:
Sep 02 02:50:42 localhost.localdomain kernel: usb 1-2: dvb_usb_v2: 
'Hauppauge WinTV-Aero-M' successfully deinitialized and disconnected

Is there any change to close all those /dev file handles when device 
disappears?

regards
Antti


On 08/21/2014 05:05 AM, Changbing Xiong wrote:
> when usb-type tuner is pulled out, user applications did not close device's FD,
> and go on polling the device, we should return POLLERR directly.
>
> Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
> ---
>   drivers/media/dvb-core/dmxdev.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index 7a5c070..42b5e70 100755
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -1085,9 +1085,10 @@ static long dvb_demux_ioctl(struct file *file, unsigned int cmd,
>   static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
>   {
>   	struct dmxdev_filter *dmxdevfilter = file->private_data;
> +	struct dmxdev *dmxdev = dmxdevfilter->dev;
>   	unsigned int mask = 0;
>
> -	if (!dmxdevfilter)
> +	if ((!dmxdevfilter) || (dmxdev->exit))
>   		return POLLERR;
>
>   	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
> @@ -1181,6 +1182,9 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
>
>   	dprintk("function : %s\n", __func__);
>
> +	if (dmxdev->exit)
> +		return POLLERR;
> +
>   	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
>
>   	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
> --
> 1.7.9.5
>

-- 
http://palosaari.fi/
