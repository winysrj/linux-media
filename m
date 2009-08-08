Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1932 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbZHHJj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 05:39:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: Re: [PATCHv14 6/8] FM TX: si4713: Add files to handle si4713 i2c device
Date: Sat, 8 Aug 2009 11:39:47 +0200
Cc: ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248707530-4068-1-git-send-email-eduardo.valentin@nokia.com> <200908071351.36063.hverkuil@xs4all.nl> <20090808090722.GA25264@esdhcp037198.research.nokia.com>
In-Reply-To: <20090808090722.GA25264@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908081139.47534.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 08 August 2009 11:07:22 Eduardo Valentin wrote:
> On Fri, Aug 07, 2009 at 01:51:36PM +0200, ext Hans Verkuil wrote:
> > Hi Eduardo,
> > 
> > Douglas pointed out to me that I hadn't reviewed this series yet.
> > 
> > That was mostly because it's pretty good as far as I'm concerned :-)
> > 
> > I do think one small thing should change:
> > 
> > On Monday 27 July 2009 17:12:08 Eduardo Valentin wrote:
> > > diff --git a/linux/drivers/media/radio/si4713-i2c.c b/linux/drivers/media/radio/si4713-i2c.c
> > 
> > <snip>
> > 
> > > +/* write string property */
> > > +static int si4713_write_econtrol_string(struct si4713_device *sdev,
> > > +				struct v4l2_ext_control *control)
> > > +{
> > > +	struct v4l2_queryctrl vqc;
> > > +	int len;
> > > +	s32 rval = 0;
> > > +
> > > +	vqc.id = control->id;
> > > +	rval = si4713_queryctrl(&sdev->sd, &vqc);
> > > +	if (rval < 0)
> > > +		goto exit;
> > > +
> > > +	switch (control->id) {
> > > +	case V4L2_CID_RDS_TX_PS_NAME: {
> > > +		char ps_name[MAX_RDS_PS_NAME + 1];
> > > +
> > > +		len = control->size - 1;
> > > +		if (len > MAX_RDS_PS_NAME)
> > > +			len = MAX_RDS_PS_NAME;
> > > +		rval = copy_from_user(ps_name, control->string, len);
> > > +		if (rval < 0)
> > > +			goto exit;
> > > +		ps_name[len] = '\0';
> > > +
> > > +		if (strlen(ps_name) % vqc.step) {
> > > +			rval = -EINVAL;
> > 
> > I think we should return -ERANGE instead. It makes more sense than -EINVAL,
> > since it is the string length that is out of bounds. -ERANGE is the expected
> > error code when the control boundary checks fail.
> > 
> > I know I said EINVAL before, but after thinking about it some more I've
> > reconsidered.
> 
> 
> Hans, just to make sure in this point. Here I am returning EINVAL because
> the string length is not multiple of control step and not because it is greater
> than it is supposed to be. As discussed earlier, during control write, if
> the coming string value is larger than it was supposed to be, I'm shrinking it.
> See above lines. So the question is: should I return ERANGE when string length
> is not multiple of step?

The V4L2 spec says that the device driver author has a choice: either modify
the control's value to fit the min/max and/or step values, or return -ERANGE.

In this case you can decide to either reduce the string length to the first
valid length or return -ERANGE. If you reduce the length, then you must update
the control->string as well! (A copy_to_user() of the new terminating 0).

To be honest, in this case I think you should just return -ERANGE and not
attempt to modify the string. I don't really see a good use-case for that.
Cutting off a string is a rather unexpected side-effect IMHO.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
