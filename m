Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42311 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZHHI2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 04:28:19 -0400
Date: Sat, 8 Aug 2009 11:15:50 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv14 6/8] FM TX: si4713: Add files to handle si4713 i2c
 device
Message-ID: <20090808081550.GC21541@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1248707530-4068-1-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-6-git-send-email-eduardo.valentin@nokia.com>
 <1248707530-4068-7-git-send-email-eduardo.valentin@nokia.com>
 <200908071351.36063.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908071351.36063.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 07, 2009 at 01:51:36PM +0200, ext Hans Verkuil wrote:
> Hi Eduardo,
> 
> Douglas pointed out to me that I hadn't reviewed this series yet.

Ok. I've noticed that as well when you replied in the wrong series version.
But no problem.

> 
> That was mostly because it's pretty good as far as I'm concerned :-)
> 
> I do think one small thing should change:
> 
> On Monday 27 July 2009 17:12:08 Eduardo Valentin wrote:
> > diff --git a/linux/drivers/media/radio/si4713-i2c.c b/linux/drivers/media/radio/si4713-i2c.c
> 
> <snip>
> 
> > +/* write string property */
> > +static int si4713_write_econtrol_string(struct si4713_device *sdev,
> > +				struct v4l2_ext_control *control)
> > +{
> > +	struct v4l2_queryctrl vqc;
> > +	int len;
> > +	s32 rval = 0;
> > +
> > +	vqc.id = control->id;
> > +	rval = si4713_queryctrl(&sdev->sd, &vqc);
> > +	if (rval < 0)
> > +		goto exit;
> > +
> > +	switch (control->id) {
> > +	case V4L2_CID_RDS_TX_PS_NAME: {
> > +		char ps_name[MAX_RDS_PS_NAME + 1];
> > +
> > +		len = control->size - 1;
> > +		if (len > MAX_RDS_PS_NAME)
> > +			len = MAX_RDS_PS_NAME;
> > +		rval = copy_from_user(ps_name, control->string, len);
> > +		if (rval < 0)
> > +			goto exit;
> > +		ps_name[len] = '\0';
> > +
> > +		if (strlen(ps_name) % vqc.step) {
> > +			rval = -EINVAL;
> 
> I think we should return -ERANGE instead. It makes more sense than -EINVAL,
> since it is the string length that is out of bounds. -ERANGE is the expected
> error code when the control boundary checks fail.
> 
> I know I said EINVAL before, but after thinking about it some more I've
> reconsidered.
> 
> > +			goto exit;
> > +		}
> > +
> > +		rval = si4713_set_rds_ps_name(sdev, ps_name);
> > +	}
> > +		break;
> > +
> > +	case V4L2_CID_RDS_TX_RADIO_TEXT:{
> > +		char radio_text[MAX_RDS_RADIO_TEXT + 1];
> > +
> > +		len = control->size - 1;
> > +		if (len > MAX_RDS_RADIO_TEXT)
> > +			len = MAX_RDS_RADIO_TEXT;
> > +		rval = copy_from_user(radio_text, control->string, len);
> > +		if (rval < 0)
> > +			goto exit;
> > +		radio_text[len] = '\0';
> > +
> > +		if (strlen(radio_text) % vqc.step) {
> > +			rval = -EINVAL;
> 
> Ditto.
> 
> > +			goto exit;
> > +		}
> > +
> > +		rval = si4713_set_rds_radio_text(sdev, radio_text);
> > +	}
> > +		break;
> > +
> > +	default:
> > +		rval = -EINVAL;
> > +		break;
> > +	};
> > +
> > +exit:
> > +	return rval;
> > +}
> 
> Just change this and you can add
> 
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> for the whole series.

I'll include only these three changes for v15 then:
- Ordering of RDS controls
- The null pointer problem pointed by Matti
- This ERANGE issue

BR

> 
> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
