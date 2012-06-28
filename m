Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55185 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab2F1Ju5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 05:50:57 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH v3 08/13] davinci: vpif: add support for clipping on
 output data
Date: Thu, 28 Jun 2012 09:50:47 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E936AEF@DBDE01.ent.ti.com>
References: <1340622455-10419-1-git-send-email-manjunath.hadli@ti.com>
 <201206251508.10347.hverkuil@xs4all.nl> <2866335.LkvUDJ0OzN@avalon>
 <201206251523.20679.hverkuil@xs4all.nl>
In-Reply-To: <201206251523.20679.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Jun 25, 2012 at 18:53:20, Hans Verkuil wrote:
> On Mon 25 June 2012 15:18:41 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Monday 25 June 2012 15:08:10 Hans Verkuil wrote:
> > > On Mon 25 June 2012 14:54:39 Laurent Pinchart wrote:
> > > > On Monday 25 June 2012 16:37:30 Manjunath Hadli wrote:
> > > > > add hardware clipping support for VPIF output data. This
> > > > > is needed as it is possible that the external encoder
> > > > > might get confused between the FF or 00 which are a part
> > > > > of the data and that of the SAV or EAV codes.
> > > > > 
> > > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > > > ---
> > > > > 
> > > > >  drivers/media/video/davinci/vpif.h         |   30 +++++++++++++++++++++
> > > > >  drivers/media/video/davinci/vpif_display.c |   10 +++++++++
> > > > >  include/media/davinci/vpif_types.h         |    2 +
> > > > >  3 files changed, 42 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/media/video/davinci/vpif.h
> > > > > b/drivers/media/video/davinci/vpif.h index a4d2141..c2ce4d9 100644
> > > > > --- a/drivers/media/video/davinci/vpif.h
> > > > > +++ b/drivers/media/video/davinci/vpif.h
> > > > > @@ -211,6 +211,12 @@ static inline void vpif_clr_bit(u32 reg, u32 bit)
> > > > > 
> > > > >  #define VPIF_CH3_INT_CTRL_SHIFT	(6)
> > > > >  #define VPIF_CH_INT_CTRL_SHIFT	(6)
> > > > > 
> > > > > +#define VPIF_CH2_CLIP_ANC_EN	14
> > > > > +#define VPIF_CH2_CLIP_ACTIVE_EN	13
> > > > > +
> > > > > +#define VPIF_CH3_CLIP_ANC_EN	14
> > > > > +#define VPIF_CH3_CLIP_ACTIVE_EN	13
> > > > > +
> > > > > 
> > > > >  /* enabled interrupt on both the fields on vpid_ch0_ctrl register */
> > > > >  #define channel0_intr_assert()	(regw((regr(VPIF_CH0_CTRL)|\
> > > > >  
> > > > >  	(VPIF_INT_BOTH << VPIF_CH0_INT_CTRL_SHIFT)), VPIF_CH0_CTRL))
> > > > > 
> > > > > @@ -515,6 +521,30 @@ static inline void channel3_raw_enable(int enable,
> > > > > u8
> > > > > index) vpif_clr_bit(VPIF_CH3_CTRL, mask);
> > > > > 
> > > > >  }
> > > > > 
> > > > > +/* function to enable clipping (for both active and blanking regions)
> > > > > on ch 2 */ +static inline void channel2_clipping_enable(int enable)
> > > > > +{
> > > > > +	if (enable) {
> > > > > +		vpif_set_bit(VPIF_CH2_CTRL, VPIF_CH2_CLIP_ANC_EN);
> > > > > +		vpif_set_bit(VPIF_CH2_CTRL, VPIF_CH2_CLIP_ACTIVE_EN);
> > > > > +	} else {
> > > > > +		vpif_clr_bit(VPIF_CH2_CTRL, VPIF_CH2_CLIP_ANC_EN);
> > > > > +		vpif_clr_bit(VPIF_CH2_CTRL, VPIF_CH2_CLIP_ACTIVE_EN);
> > > > > +	}
> > > > > +}
> > > > > +
> > > > > +/* function to enable clipping (for both active and blanking regions)
> > > > > on ch 2 */ +static inline void channel3_clipping_enable(int enable)
> > > > > +{
> > > > > +	if (enable) {
> > > > > +		vpif_set_bit(VPIF_CH3_CTRL, VPIF_CH3_CLIP_ANC_EN);
> > > > > +		vpif_set_bit(VPIF_CH3_CTRL, VPIF_CH3_CLIP_ACTIVE_EN);
> > > > > +	} else {
> > > > > +		vpif_clr_bit(VPIF_CH3_CTRL, VPIF_CH3_CLIP_ANC_EN);
> > > > > +		vpif_clr_bit(VPIF_CH3_CTRL, VPIF_CH3_CLIP_ACTIVE_EN);
> > > > > +	}
> > > > > +}
> > > > > +
> > > > > 
> > > > >  /* inline function to set buffer addresses in case of Y/C non mux mode
> > > > >  */
> > > > >  static inline void ch2_set_videobuf_addr_yc_nmux(unsigned long
> > > > > 
> > > > > top_strt_luma, unsigned long btm_strt_luma,
> > > > > diff --git a/drivers/media/video/davinci/vpif_display.c
> > > > > b/drivers/media/video/davinci/vpif_display.c index 61ea8bc..4436ef6
> > > > > 100644
> > > > > --- a/drivers/media/video/davinci/vpif_display.c
> > > > > +++ b/drivers/media/video/davinci/vpif_display.c
> > > > > @@ -1046,6 +1046,8 @@ static int vpif_streamon(struct file *file, void
> > > > > *priv, channel2_intr_assert();
> > > > > 
> > > > >  			channel2_intr_enable(1);
> > > > >  			enable_channel2(1);
> > > > > 
> > > > > +			if (vpif_config_data->ch2_clip_en)
> > > > > +				channel2_clipping_enable(1);
> > > > > 
> > > > >  		}
> > > > >  		
> > > > >  		if ((VPIF_CHANNEL3_VIDEO == ch->channel_id)
> > > > > 
> > > > > @@ -1053,6 +1055,8 @@ static int vpif_streamon(struct file *file, void
> > > > > *priv, channel3_intr_assert();
> > > > > 
> > > > >  			channel3_intr_enable(1);
> > > > >  			enable_channel3(1);
> > > > > 
> > > > > +			if (vpif_config_data->ch3_clip_en)
> > > > > +				channel3_clipping_enable(1);
> > > > > 
> > > > >  		}
> > > > >  		channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
> > > > >  	
> > > > >  	}
> > > > > 
> > > > > @@ -1065,6 +1069,8 @@ static int vpif_streamoff(struct file *file, void
> > > > > *priv, struct vpif_fh *fh = priv;
> > > > > 
> > > > >  	struct channel_obj *ch = fh->channel;
> > > > >  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> > > > > 
> > > > > +	struct vpif_display_config *vpif_config_data =
> > > > > +					vpif_dev->platform_data;
> > > > > 
> > > > >  	if (buftype != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > > > >  	
> > > > >  		vpif_err("buffer type not supported\n");
> > > > > 
> > > > > @@ -1084,11 +1090,15 @@ static int vpif_streamoff(struct file *file,
> > > > > void
> > > > > *priv, if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > > > > 
> > > > >  		/* disable channel */
> > > > >  		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
> > > > > 
> > > > > +			if (vpif_config_data->ch2_clip_en)
> > > > > +				channel2_clipping_enable(0);
> > > > > 
> > > > >  			enable_channel2(0);
> > > > >  			channel2_intr_enable(0);
> > > > >  		
> > > > >  		}
> > > > >  		if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
> > > > >  		
> > > > >  					(2 == common->started)) {
> > > > > 
> > > > > +			if (vpif_config_data->ch3_clip_en)
> > > > > +				channel3_clipping_enable(0);
> > > > > 
> > > > >  			enable_channel3(0);
> > > > >  			channel3_intr_enable(0);
> > > > >  		
> > > > >  		}
> > > > > 
> > > > > diff --git a/include/media/davinci/vpif_types.h
> > > > > b/include/media/davinci/vpif_types.h index bd8217c..d8f6ab1 100644
> > > > > --- a/include/media/davinci/vpif_types.h
> > > > > +++ b/include/media/davinci/vpif_types.h
> > > > > @@ -50,6 +50,8 @@ struct vpif_display_config {
> > > > > 
> > > > >  	const char **output;
> > > > >  	int output_count;
> > > > >  	const char *card_name;
> > > > > 
> > > > > +	bool ch2_clip_en;
> > > > > +	bool ch3_clip_en;
> > > > 
> > > > Instead of hardcoding this in platform data, I think it would be better to
> > > > make this runtime-configurable. One option is to use the value of the
> > > > v4l2_pix_format::colorspace field configured by userspace. We already have
> > > > V4L2_COLORSPACE_JPEG which maps to the full 0-255 range, but we're missing
> > > > a colorspace for the clipped 1-254 range used by the VPIF and I'm not
> > > > sure whether it would really make sense to add one. Another option is to
> > > > use a V4L2 control.
> > > 
> > > This is something for a V4L2 control I think since clipping is colorspace
> > > independent (you have the same situation for e.g. YCbCr).
> > 
> > But some colorspaces define ranges smaller than 0-255.
> 
> Just because they define a smaller range doesn't mean you actually get that.
> From personal experience I can assure you that those are two different things :-)
> 
> Regards,
> 
> 	Hans
> 
> > In this particular case 
> > I agree with you though, as the hardware clips to 1-255 without taking 
> > colorspaces into account.
> > 
> > 
> 
This is not really related to color spaces strictly. Since one of the versions of this IPs
did not clip, we had issues on the encoder front with the SAV/EAV and the data getting confused 
by the encoder. The platform hard coding is required, and at this point, this is the correct way to handle it. There is no need to make this runtime configurable in this case as at no point
 we would want to disable the clipping - unless it is not supported.

Thx and Regards,
-Manju
