Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50387 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbbJSCDs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Oct 2015 22:03:48 -0400
Date: Mon, 19 Oct 2015 04:03:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 5/5] media: atmel-isi: support RGB565 output when sensor
 output YUV formats
In-Reply-To: <561DFCE4.8090508@atmel.com>
Message-ID: <Pine.LNX.4.64.1510190357000.26684@axis700.grange>
References: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
 <1442898875-7147-6-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1510041852470.26834@axis700.grange> <561DFCE4.8090508@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Wed, 14 Oct 2015, Josh Wu wrote:

> Dear Guennadi,
> 
> Thanks for the review.
> 
> On 10/5/2015 1:02 AM, Guennadi Liakhovetski wrote:
> > On Tue, 22 Sep 2015, Josh Wu wrote:
> > 
> > > This patch enable Atmel ISI preview path to convert the YUV to RGB format.
> > > 
> > > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > > ---
> > > 
> > >   drivers/media/platform/soc_camera/atmel-isi.c | 38
> > > ++++++++++++++++++++-------
> > >   1 file changed, 29 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> > > b/drivers/media/platform/soc_camera/atmel-isi.c
> > > index e87d354..e33a16a 100644
> > > --- a/drivers/media/platform/soc_camera/atmel-isi.c
> > > +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> > > @@ -201,13 +201,20 @@ static bool is_supported(struct soc_camera_device
> > > *icd,
> > >   	case V4L2_PIX_FMT_UYVY:
> > >   	case V4L2_PIX_FMT_YVYU:
> > >   	case V4L2_PIX_FMT_VYUY:
> > > +	/* RGB */
> > > +	case V4L2_PIX_FMT_RGB565:
> > >   		return true;
> > > -	/* RGB, TODO */
> > >   	default:
> > >   		return false;
> > >   	}
> > >   }
> > >   +static bool is_output_rgb(const struct soc_mbus_pixelfmt *host_fmt)
> > > +{
> > > +	return host_fmt->fourcc == V4L2_PIX_FMT_RGB565 ||
> > > +			host_fmt->fourcc == V4L2_PIX_FMT_RGB32;
> > > +}
> > > +
> > Why not just pass fourcc to this function? Or maybe just embed it in
> > start_streaming - it won't clutter it a lot.
> 
> I think pass fourcc to the function is good.
> Since configure_geometry() is hardware related, and the enable_preview_path is
> also hardware related, so I prefer initialize enable_preview_path in
> configure_geometry().

But you don't, you do it in start_streaming() below. But actually my 
comment was not about _where_ to do it, but whether this calculation is 
worth a separate function. I would just perform this calculation directly 
where you're calling it:

static ... start_streaming(...)
{
	...
	u32 fourcc = icd->current_fmt->host_fmt->fourcc;

	isi->enable_preview_path = fourcc == V4L2_PIX_FMT_RGB565 ||
				fourcc == V4L2_PIX_FMT_RGB32;

Thanks
Guennadi

> > >   static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
> > >   {
> > >   	if (isi->active) {
> > > @@ -467,6 +474,8 @@ static int start_streaming(struct vb2_queue *vq,
> > > unsigned int count)
> > >   	struct atmel_isi *isi = ici->priv;
> > >   	int ret;
> > >   +	isi->enable_preview_path = is_output_rgb(icd->current_fmt->host_fmt);
> > > +
> > >   	pm_runtime_get_sync(ici->v4l2_dev.dev);
> > >     	/* Reset ISI */
> > > @@ -688,6 +697,14 @@ static const struct soc_mbus_pixelfmt
> > > isi_camera_formats[] = {
> > >   		.order			= SOC_MBUS_ORDER_LE,
> > >   		.layout			= SOC_MBUS_LAYOUT_PACKED,
> > >   	},
> > > +	{
> > > +		.fourcc			= V4L2_PIX_FMT_RGB565,
> > > +		.name			= "RGB565",
> > > +		.bits_per_sample	= 8,
> > > +		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
> > > +		.order			= SOC_MBUS_ORDER_LE,
> > > +		.layout			= SOC_MBUS_LAYOUT_PACKED,
> > > +	},
> > >   };
> > >     /* This will be corrected as we get more formats */
> > > @@ -744,7 +761,7 @@ static int isi_camera_get_formats(struct
> > > soc_camera_device *icd,
> > >   				  struct soc_camera_format_xlate *xlate)
> > >   {
> > >   	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > > -	int formats = 0, ret;
> > > +	int formats = 0, ret, i, n;
> > >   	/* sensor format */
> > >   	struct v4l2_subdev_mbus_code_enum code = {
> > >   		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > > @@ -778,13 +795,16 @@ static int isi_camera_get_formats(struct
> > > soc_camera_device *icd,
> > >   	case MEDIA_BUS_FMT_VYUY8_2X8:
> > >   	case MEDIA_BUS_FMT_YUYV8_2X8:
> > >   	case MEDIA_BUS_FMT_YVYU8_2X8:
> > > -		formats++;
> > > -		if (xlate) {
> > > -			xlate->host_fmt	= &isi_camera_formats[0];
> > > -			xlate->code	= code.code;
> > > -			xlate++;
> > > -			dev_dbg(icd->parent, "Providing format %s using code
> > > %d\n",
> > > -				isi_camera_formats[0].name, code.code);
> > > +		n = ARRAY_SIZE(isi_camera_formats);
> > > +		formats += n;
> > > +		for (i = 0; i < n; i++) {
> > > +			if (xlate) {
> > I'd put if outside of the loop, or just do
> > 
> > +		for (i = 0; xlate && i < n; i++) {
> 
> yes, that simpler one. I'll take it. Thanks.
> 
> Best Regards,
> Josh Wu
> > 
> > 
> > > +				xlate->host_fmt	= &isi_camera_formats[i];
> > > +				xlate->code	= code.code;
> > > +				dev_dbg(icd->parent, "Providing format %s
> > > using code %d\n",
> > > +					isi_camera_formats[0].name,
> > > code.code);
> > > +				xlate++;
> > > +			}
> > >   		}
> > >   		break;
> > >   	default:
> > > -- 
> > > 1.9.1
> > > 
> 
