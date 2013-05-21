Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:48341 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3EUOqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 10:46:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3] adv7180: add more subdev video ops
Date: Tue, 21 May 2013 16:45:49 +0200
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	vladimir.barinov@cogentembedded.com, linux-sh@vger.kernel.org,
	matsu@igel.co.jp
References: <201305132321.39495.sergei.shtylyov@cogentembedded.com> <201305211135.59706.hverkuil@xs4all.nl> <519B8478.9010305@cogentembedded.com>
In-Reply-To: <519B8478.9010305@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305211645.49257.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 21 May 2013 16:28:08 Sergei Shtylyov wrote:
> Hello.
> 
> On 21-05-2013 13:35, Hans Verkuil wrote:
> 
> >> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> >> Add subdev video ops for ADV7180 video decoder.  This makes decoder usable on
> >> the soc-camera drivers.
> 
> >> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> >> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> >> ---
> >> This patch is against the 'media_tree.git' repo.
> 
> >> Changes from version 2:
> >> - set the field format depending on video standard in try_mbus_fmt() method;
> >> - removed querystd() method calls from try_mbus_fmt() and cropcap() methods;
> >> - removed g_crop() method.
> 
> >>   drivers/media/i2c/adv7180.c |   86 ++++++++++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 86 insertions(+)
> >>
> >> Index: media_tree/drivers/media/i2c/adv7180.c
> >> ===================================================================
> >> --- media_tree.orig/drivers/media/i2c/adv7180.c
> >> +++ media_tree/drivers/media/i2c/adv7180.c
> 
> 
> >> +
> >> +static int adv7180_try_mbus_fmt(struct v4l2_subdev *sd,
> >> +				struct v4l2_mbus_framefmt *fmt)
> >> +{
> >> +	struct adv7180_state *state = to_state(sd);
> >> +
> >> +	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
> >> +	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
> >> +	fmt->field = state->curr_norm & V4L2_STD_525_60 ?
> >> +		     V4L2_FIELD_INTERLACED_BT : V4L2_FIELD_INTERLACED_TB;
> 
> > Just noticed this: use V4L2_FIELD_INTERLACED as that does the right thing.
> > No need to split in _BT and _TB.
> 
>     Hm, testers have reported that _BT vs _TB do make a difference. I'll 
> try to look into how V4L2 handles interlacing for different standards.

When using V4L2_FIELD_INTERLACED the BT vs TB is implicit (i.e. the application
is supposed to know that the order will be different depending on the standard).
Explicitly using BT/TB is only useful if you want to override the default, e.g.
if a video was encoded using the wrong temporal order.
 
> >> +	fmt->width = 720;
> >> +	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> >> +
> >> +	return 0;
> >> +}
> 
> > Actually, all this code can be simplified substantially: the try/g/s_mbus_fmt
> > functions are really all identical since the data returned is only dependent
> > on the current standard. So this means you can use just a single function for
> > all three ops, and you can do away with adding struct v4l2_mbus_framefmt to
> > adv7180_state.
> 
>     Hm, I wonder how "get" and "set" methods can be identical... I'll 
> look into this some more.

Normally they aren't, but in this case there is only one possible format, so
any values you attempt to set are ignored completely.

Regards,

	Hans
