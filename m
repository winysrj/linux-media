Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:46758 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375AbbGQNF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 09:05:26 -0400
Message-ID: <55A8FD58.7010806@xs4all.nl>
Date: Fri, 17 Jul 2015 15:04:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 8/9] hackrf: add support for transmitter
References: <1437030298-20944-1-git-send-email-crope@iki.fi> <1437030298-20944-9-git-send-email-crope@iki.fi>
In-Reply-To: <1437030298-20944-9-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2015 09:04 AM, Antti Palosaari wrote:
> HackRF SDR device has both receiver and transmitter. There is limitation
> that receiver and transmitter cannot be used at the same time
> (half-duplex operation). That patch implements transmitter support to
> existing receiver only driver.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/hackrf/hackrf.c | 787 +++++++++++++++++++++++++++-----------
>  1 file changed, 572 insertions(+), 215 deletions(-)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index 5bd291b..97de9cb6 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> @@ -34,6 +34,7 @@ enum {
>  	CMD_AMP_ENABLE                     = 0x11,
>  	CMD_SET_LNA_GAIN                   = 0x13,
>  	CMD_SET_VGA_GAIN                   = 0x14,
> +	CMD_SET_TXVGA_GAIN                 = 0x15,
>  };
>  
>  /*
> @@ -44,7 +45,7 @@ enum {
>  #define MAX_BULK_BUFS            (6)
>  #define BULK_BUFFER_SIZE         (128 * 512)
>  
> -static const struct v4l2_frequency_band bands_adc[] = {
> +static const struct v4l2_frequency_band bands_adc_dac[] = {
>  	{
>  		.tuner = 0,
>  		.type = V4L2_TUNER_ADC,
> @@ -55,7 +56,7 @@ static const struct v4l2_frequency_band bands_adc[] = {
>  	},
>  };
>  
> -static const struct v4l2_frequency_band bands_rf[] = {
> +static const struct v4l2_frequency_band bands_rx_tx[] = {
>  	{
>  		.tuner = 1,
>  		.type = V4L2_TUNER_RF,
> @@ -91,28 +92,39 @@ struct hackrf_frame_buf {
>  };
>  
>  struct hackrf_dev {
> -#define POWER_ON                         1
> -#define USB_STATE_URB_BUF                2 /* XXX: set manually */
> -#define SAMPLE_RATE_SET                 10
> -#define RX_BANDWIDTH                    11
> -#define RX_RF_FREQUENCY                 12
> -#define RX_RF_GAIN                      13
> -#define RX_LNA_GAIN                     14
> -#define RX_IF_GAIN                      15
> +#define USB_STATE_URB_BUF                1 /* XXX: set manually */
> +#define QUEUE_SETUP                      3
> +#define RX_ON                            4
> +#define TX_ON                            5
> +#define RX_ADC_FREQUENCY                11
> +#define TX_DAC_FREQUENCY                12
> +#define RX_BANDWIDTH                    13
> +#define TX_BANDWIDTH                    14
> +#define RX_RF_FREQUENCY                 15
> +#define TX_RF_FREQUENCY                 16
> +#define RX_RF_GAIN                      17
> +#define TX_RF_GAIN                      18
> +#define RX_IF_GAIN                      19
> +#define RX_LNA_GAIN                     20
> +#define TX_LNA_GAIN                     21
>  	unsigned long flags;
>  
>  	struct usb_interface *intf;
>  	struct device *dev;
>  	struct usb_device *udev;
> -	struct video_device vdev;
> -	struct v4l2_device v4l2_dev;
> +	struct video_device rx_vdev;
> +	struct video_device tx_vdev;
> +	struct v4l2_device rx_v4l2_dev;
> +	struct v4l2_device tx_v4l2_dev;

Why two v4l2_device structs? It is a single USB device, so there is a single
v4l2_device struct.

It looks like the only reason might be that you want different control handlers
for each radio device. If that's the case, then that can easily be done by
assigning the v4l2_ctrl_handler pointer to the ctrl_handler field of the struct
video_device instead of the struct v4l2_device.

Other than that the code looks good.

Regards,

	Hans

>  
>  	/* videobuf2 queue and queued buffers list */
> -	struct vb2_queue vb_queue;
> +	struct vb2_queue rx_vb2_queue;
> +	struct vb2_queue tx_vb2_queue;
>  	struct list_head queued_bufs;
>  	spinlock_t queued_bufs_lock; /* Protects queued_bufs */
>  	unsigned sequence;	     /* Buffer sequence counter */
>  	unsigned int vb_full;        /* vb is full and packets dropped */
> +	unsigned int vb_empty;       /* vb is empty and packets dropped */
>  
>  	/* Note if taking both locks v4l2_lock must always be locked first! */
>  	struct mutex v4l2_lock;      /* Protects everything else */

