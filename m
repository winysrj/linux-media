Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34829 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932155AbdGSK0Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:26:24 -0400
Subject: Re: [PATCH v4l2-utils] v4l2-ctl: Print numerical control ID
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        linux-media@vger.kernel.org
References: <20170623135612.23922-1-soren.brinkmann@xilinx.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f3eeb34b-3d7d-d47c-d8a8-b7b6d15d55fb@xs4all.nl>
Date: Wed, 19 Jul 2017 12:26:18 +0200
MIME-Version: 1.0
In-Reply-To: <20170623135612.23922-1-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/06/17 15:56, Soren Brinkmann wrote:
> Print the numerical ID for each control in list commands.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> I was trying to set controls from a userspace application and was hence looking
> for an easy way to find the control IDs to use with VIDIOC_(G|S)_EXT_CTRLS. The
> -l/-L options of v4l2-ctl already provide most information needed, hence I
> thought I'd add the numerical ID too.

Good idea. I applied the patch but with two small changes:

1) I replaced qmenu.id by queryctrl->id to be more consistent.
2) I replaced the '/' separator by a space. It made the output a bit more readable IMHO.

Regards,

	Hans

> 
> 	Sören
> 
>  utils/v4l2-ctl/v4l2-ctl-common.cpp | 45 +++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> index 6d9371eacbb7..149053bbbd4a 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
> @@ -313,67 +313,68 @@ static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
>  	qmenu.id = queryctrl->id;
>  	switch (queryctrl->type) {
>  	case V4L2_CTRL_TYPE_INTEGER:
> -		printf("%31s (int)    : min=%lld max=%lld step=%lld default=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (int)    : min=%lld max=%lld step=%lld default=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->step, queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_INTEGER64:
> -		printf("%31s (int64)  : min=%lld max=%lld step=%lld default=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (int64)  : min=%lld max=%lld step=%lld default=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->step, queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_STRING:
> -		printf("%31s (str)    : min=%lld max=%lld step=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (str)    : min=%lld max=%lld step=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->step);
>  		break;
>  	case V4L2_CTRL_TYPE_BOOLEAN:
> -		printf("%31s (bool)   : default=%lld",
> -				s.c_str(), queryctrl->default_value);
> +		printf("%31s/%#8.8x (bool)   : default=%lld",
> +				s.c_str(), qmenu.id, queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_MENU:
> -		printf("%31s (menu)   : min=%lld max=%lld default=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (menu)   : min=%lld max=%lld default=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_INTEGER_MENU:
> -		printf("%31s (intmenu): min=%lld max=%lld default=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (intmenu): min=%lld max=%lld default=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_BUTTON:
> -		printf("%31s (button) :", s.c_str());
> +		printf("%31s/%#8.8x (button) :", s.c_str(), qmenu.id);
>  		break;
>  	case V4L2_CTRL_TYPE_BITMASK:
> -		printf("%31s (bitmask): max=0x%08llx default=0x%08llx",
> -				s.c_str(), queryctrl->maximum,
> +		printf("%31s/%#8.8x (bitmask): max=0x%08llx default=0x%08llx",
> +				s.c_str(), qmenu.id, queryctrl->maximum,
>  				queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_U8:
> -		printf("%31s (u8)     : min=%lld max=%lld step=%lld default=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (u8)     : min=%lld max=%lld step=%lld default=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->step, queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_U16:
> -		printf("%31s (u16)    : min=%lld max=%lld step=%lld default=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (u16)    : min=%lld max=%lld step=%lld default=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->step, queryctrl->default_value);
>  		break;
>  	case V4L2_CTRL_TYPE_U32:
> -		printf("%31s (u32)    : min=%lld max=%lld step=%lld default=%lld",
> -				s.c_str(),
> +		printf("%31s/%#8.8x (u32)    : min=%lld max=%lld step=%lld default=%lld",
> +				s.c_str(), qmenu.id,
>  				queryctrl->minimum, queryctrl->maximum,
>  				queryctrl->step, queryctrl->default_value);
>  		break;
>  	default:
> -		printf("%31s (unknown): type=%x", s.c_str(), queryctrl->type);
> +		printf("%31s/%#8.8x (unknown): type=%x",
> +				s.c_str(), qmenu.id, queryctrl->type);
>  		break;
>  	}
>  	if (queryctrl->nr_of_dims == 0) {
> 
