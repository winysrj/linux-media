Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbaGNMbn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:31:43 -0400
Message-ID: <53C3CDAC.3010500@redhat.com>
Date: Mon, 14 Jul 2014 14:31:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] libv4lcontrol: sync control strings/flags with the
 kernel
References: <53BBD0EF.1050104@xs4all.nl>
In-Reply-To: <53BBD0EF.1050104@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/08/2014 01:07 PM, Hans Verkuil wrote:
> Hans,
> 
> I'd like your opinion on this. I really don't think the (sw) suffix serves
> any purpose and is just confusing to the end-user.
> 
> If you think that it is important that apps/users know that a control is emulated,
> then I would propose adding a V4L2_CTRL_FLAG_EMULATED and setting it in
> libv4lcontrol. Similar to the FMT_FLAG_EMULATED.

I agree that if we want to differentiate for programmatic purposes
(which is what Sakari seems to be talking about) it would be better do so
with a flag. But lets wait till we get a real use case for that before
implementing the flag.

In the mean time I think syncing up the strings with the kernel is a good
idea.

> The emulated control names and control flags were different from
> what the kernel uses.  Sync them up.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good, feel free to push:

Reviewed by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  lib/libv4lconvert/control/libv4lcontrol.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
> index 2fd585d..33bf9ce 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.c
> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
> @@ -788,7 +788,7 @@ static const struct v4l2_queryctrl fake_controls[V4LCONTROL_COUNT] = {
>  	{
>  		.id = V4L2_CID_AUTO_WHITE_BALANCE,
>  		.type = V4L2_CTRL_TYPE_BOOLEAN,
> -		.name =  "Whitebalance (software)",
> +		.name =  "White Balance, Automatic",
>  		.minimum = 0,
>  		.maximum = 1,
>  		.step = 1,
> @@ -797,7 +797,7 @@ static const struct v4l2_queryctrl fake_controls[V4LCONTROL_COUNT] = {
>  	}, {
>  		.id = V4L2_CID_HFLIP,
>  		.type = V4L2_CTRL_TYPE_BOOLEAN,
> -		.name =  "Horizontal flip (sw)",
> +		.name =  "Horizontal Flip",
>  		.minimum = 0,
>  		.maximum = 1,
>  		.step = 1,
> @@ -806,7 +806,7 @@ static const struct v4l2_queryctrl fake_controls[V4LCONTROL_COUNT] = {
>  	}, {
>  		.id = V4L2_CID_VFLIP,
>  		.type = V4L2_CTRL_TYPE_BOOLEAN,
> -		.name =  "Vertical flip (sw)",
> +		.name =  "Vertical Flip",
>  		.minimum = 0,
>  		.maximum = 1,
>  		.step = 1,
> @@ -815,17 +815,17 @@ static const struct v4l2_queryctrl fake_controls[V4LCONTROL_COUNT] = {
>  	}, {
>  		.id = V4L2_CID_GAMMA,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.name =  "Gamma (software)",
> +		.name =  "Gamma",
>  		.minimum = 500,  /* == 0.5 */
>  		.maximum = 3000, /* == 3.0 */
>  		.step = 1,
>  		.default_value = 1000, /* == 1.0 */
> -		.flags = 0
> +		.flags = V4L2_CTRL_FLAG_SLIDER
>  	}, { /* Dummy place holder for V4LCONTROL_AUTO_ENABLE_COUNT */
>  	}, {
>  		.id = V4L2_CID_AUTOGAIN,
>  		.type = V4L2_CTRL_TYPE_BOOLEAN,
> -		.name =  "Auto Gain (software)",
> +		.name =  "Gain, Automatic",
>  		.minimum = 0,
>  		.maximum = 1,
>  		.step = 1,
> @@ -834,12 +834,12 @@ static const struct v4l2_queryctrl fake_controls[V4LCONTROL_COUNT] = {
>  	}, {
>  		.id = V4L2_CTRL_CLASS_USER + 0x2000, /* FIXME */
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.name =  "Auto Gain target",
> +		.name =  "Auto Gain Target",
>  		.minimum = 0,
>  		.maximum = 255,
>  		.step = 1,
>  		.default_value = 100,
> -		.flags = 0
> +		.flags = V4L2_CTRL_FLAG_SLIDER
>  	},
>  };
>  
> 
