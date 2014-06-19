Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaFSOfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 10:35:24 -0400
Message-ID: <53A2F525.2070504@redhat.com>
Date: Thu, 19 Jun 2014 16:35:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>, linux-media@vger.kernel.org
CC: Alexander Sosna <alexander@xxor.de>
Subject: Re: [RFC 2/2] gspca_kinect: add support for the depth stream
References: <53450D76.2010405@redhat.com> <1401913499-6475-1-git-send-email-ao2@ao2.it> <1401913499-6475-3-git-send-email-ao2@ao2.it>
In-Reply-To: <1401913499-6475-3-git-send-email-ao2@ao2.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/04/2014 10:24 PM, Antonio Ospite wrote:
> Add support for the depth mode at 10bpp, use a command line parameter to
> switch mode.
> 
> NOTE: this is just a proof-of-concept, the final implementation will
> have to expose two v4l2 devices, one for the video stream and one for
> the depth stream.

Thanks for the patch. If this is useful for some people I'm willing to
merge this until we've a better fix.

> Signed-off-by: Alexander Sosna <alexander@xxor.de>
> Signed-off-by: Antonio Ospite <ao2@ao2.it>
> ---
> 
> For now a command line parameter called "depth_mode" is used to select which
> mode to activate when loading the driver, this is necessary because gspca is
> not quite ready to have a subdriver call gspca_dev_probe() multiple times.
> 
> The problem seems to be that gspca assumes one video device per USB
> _interface_, and so it stores a pointer to gspca_dev as the interface
> private data: see usb_set_intfdata(intf, gspca_dev) in
> gspca_dev_probe2().
> 
> If anyone feels brave (do a backup first, etc. etc.), hack the sd_probe()
> below to register both the devices: you will get the two v4l nodes and both
> streams will work OK, but the kernel will halt when you disconnect the device,
> i.e. some problem arises in gspca_disconnect() after the usb_get_intfdata(intf)
> call.
> 
> I am still figuring out the details of the failure sequence, and I'll try to
> imagine a way to support the use case "multiple v4l devices on one USB
> interface", but this will take some more time.

I believe that support 2 devices would require separating the per video node /
stream data and global data into separate structs, and then refactoring everything
so that we can have 2 streams on one gspca_dev. If you do this please make it
a patch-set with many small patches, rather then 1 or 2 very large patches.

And then in things like disconnect, loop over the streams and stop both, unregister
both nodes, etc.

If you ever decide to add support for controls you will also need to think about what
to do with those, but for now I guess you can just register all the controls on the
first video-node/stream (which will be the only one for all devices except kinect
devices, and the kinect code currently does not have controls.

Regards,

Hans



> 
> Thanks,
>    Antonio
> 
>  drivers/media/usb/gspca/kinect.c | 97 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 86 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
> index 081f051..ce688d8 100644
> --- a/drivers/media/usb/gspca/kinect.c
> +++ b/drivers/media/usb/gspca/kinect.c
> @@ -36,6 +36,8 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
>  MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
>  MODULE_LICENSE("GPL");
>  
> +static bool depth_mode;
> +
>  struct pkt_hdr {
>  	uint8_t magic[2];
>  	uint8_t pad;
> @@ -73,6 +75,14 @@ struct sd {
>  
>  #define FPS_HIGH       0x0100
>  
> +static const struct v4l2_pix_format depth_camera_mode[] = {
> +	{640, 480, V4L2_PIX_FMT_Y10BPACK, V4L2_FIELD_NONE,
> +	 .bytesperline = 640 * 10 / 8,
> +	 .sizeimage =  640 * 480 * 10 / 8,
> +	 .colorspace = V4L2_COLORSPACE_SRGB,
> +	 .priv = MODE_640x488 | FORMAT_Y10B},
> +};
> +
>  static const struct v4l2_pix_format video_camera_mode[] = {
>  	{640, 480, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
>  	 .bytesperline = 640,
> @@ -219,7 +229,7 @@ static int write_register(struct gspca_dev *gspca_dev, uint16_t reg,
>  }
>  
>  /* this function is called at probe time */
> -static int sd_config(struct gspca_dev *gspca_dev,
> +static int sd_config_video(struct gspca_dev *gspca_dev,
>  		     const struct usb_device_id *id)
>  {
>  	struct sd *sd = (struct sd *) gspca_dev;
> @@ -227,8 +237,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
>  
>  	sd->cam_tag = 0;
>  
> -	/* Only video stream is supported for now,
> -	 * which has stream flag = 0x80 */
> +	/* video has stream flag = 0x80 */
>  	sd->stream_flag = 0x80;
>  
>  	cam = &gspca_dev->cam;
> @@ -245,6 +254,26 @@ static int sd_config(struct gspca_dev *gspca_dev,
>  	return 0;
>  }
>  
> +static int sd_config_depth(struct gspca_dev *gspca_dev,
> +		     const struct usb_device_id *id)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +	struct cam *cam;
> +
> +	sd->cam_tag = 0;
> +
> +	cam = &gspca_dev->cam;
> +
> +	/* depth has stream flag = 0x70 */
> +	sd->stream_flag = 0x70;
> +	cam->cam_mode = depth_camera_mode;
> +	cam->nmodes = ARRAY_SIZE(depth_camera_mode);
> +
> +	gspca_dev->xfer_ep_index = 1;
> +
> +	return 0;
> +}
> +
>  /* this function is called at probe and resume time */
>  static int sd_init(struct gspca_dev *gspca_dev)
>  {
> @@ -253,7 +282,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
>  	return 0;
>  }
>  
> -static int sd_start(struct gspca_dev *gspca_dev)
> +static int sd_start_video(struct gspca_dev *gspca_dev)
>  {
>  	int mode;
>  	uint8_t fmt_reg, fmt_val;
> @@ -325,12 +354,39 @@ static int sd_start(struct gspca_dev *gspca_dev)
>  	return 0;
>  }
>  
> -static void sd_stopN(struct gspca_dev *gspca_dev)
> +static int sd_start_depth(struct gspca_dev *gspca_dev)
> +{
> +	/* turn off IR-reset function */
> +	write_register(gspca_dev, 0x105, 0x00);
> +
> +	/* reset depth stream */
> +	write_register(gspca_dev, 0x06, 0x00);
> +	/* Depth Stream Format 0x03: 11 bit stream | 0x02: 10 bit */
> +	write_register(gspca_dev, 0x12, 0x02);
> +	/* Depth Stream Resolution 1: standard (640x480) */
> +	write_register(gspca_dev, 0x13, 0x01);
> +	/* Depth Framerate / 0x1e (30): 30 fps */
> +	write_register(gspca_dev, 0x14, 0x1e);
> +	/* Depth Stream Control  / 2: Open Depth Stream */
> +	write_register(gspca_dev, 0x06, 0x02);
> +	/* disable depth hflip / LSB = 0: Smoothing Disabled */
> +	write_register(gspca_dev, 0x17, 0x00);
> +
> +	return 0;
> +}
> +
> +static void sd_stopN_video(struct gspca_dev *gspca_dev)
>  {
>  	/* reset video stream */
>  	write_register(gspca_dev, 0x05, 0x00);
>  }
>  
> +static void sd_stopN_depth(struct gspca_dev *gspca_dev)
> +{
> +	/* reset depth stream */
> +	write_register(gspca_dev, 0x06, 0x00);
> +}
> +
>  static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
>  {
>  	struct sd *sd = (struct sd *) gspca_dev;
> @@ -366,12 +422,24 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
>  }
>  
>  /* sub-driver description */
> -static const struct sd_desc sd_desc = {
> +static const struct sd_desc sd_desc_video = {
>  	.name      = MODULE_NAME,
> -	.config    = sd_config,
> +	.config    = sd_config_video,
>  	.init      = sd_init,
> -	.start     = sd_start,
> -	.stopN     = sd_stopN,
> +	.start     = sd_start_video,
> +	.stopN     = sd_stopN_video,
> +	.pkt_scan  = sd_pkt_scan,
> +	/*
> +	.get_streamparm = sd_get_streamparm,
> +	.set_streamparm = sd_set_streamparm,
> +	*/
> +};
> +static const struct sd_desc sd_desc_depth = {
> +	.name      = MODULE_NAME,
> +	.config    = sd_config_depth,
> +	.init      = sd_init,
> +	.start     = sd_start_depth,
> +	.stopN     = sd_stopN_depth,
>  	.pkt_scan  = sd_pkt_scan,
>  	/*
>  	.get_streamparm = sd_get_streamparm,
> @@ -391,8 +459,12 @@ MODULE_DEVICE_TABLE(usb, device_table);
>  /* -- device connect -- */
>  static int sd_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  {
> -	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
> -				THIS_MODULE);
> +	if (depth_mode)
> +		return gspca_dev_probe(intf, id, &sd_desc_depth,
> +				       sizeof(struct sd), THIS_MODULE);
> +	else
> +		return gspca_dev_probe(intf, id, &sd_desc_video,
> +				       sizeof(struct sd), THIS_MODULE);
>  }
>  
>  static struct usb_driver sd_driver = {
> @@ -408,3 +480,6 @@ static struct usb_driver sd_driver = {
>  };
>  
>  module_usb_driver(sd_driver);
> +
> +module_param(depth_mode, bool, 0644);
> +MODULE_PARM_DESC(depth_mode, "0=rgb 1=depth");
> 
