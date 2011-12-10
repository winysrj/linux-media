Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40680 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1LJKds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 05:33:48 -0500
Date: Sat, 10 Dec 2011 12:33:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
Message-ID: <20111210103344.GF1967@valkosipuli.localdomain>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <1323011776-15967-2-git-send-email-snjw23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323011776-15967-2-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Dec 04, 2011 at 04:16:12PM +0100, Sylwester Nawrocki wrote:
> Change the V4L2_CID_FOCUS_AUTO control type from boolean to a menu
> type. In case of boolean control we had values 0 and 1 corresponding
> to manual and automatic focus respectively.
> 
> The V4L2_CID_FOCUS_AUTO menu control has currently following items:
>   0 - V4L2_FOCUS_MANUAL,
>   1 - V4L2_FOCUS_AUTO,
>   2 - V4L2_FOCUS_AUTO_MACRO,
>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.

I would put the macro mode to a separate menu since it's configuration for
how the regular AF works rather than really different mode.

...

> @@ -567,6 +576,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_PRIVACY:			return "Privacy";
>  	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
> +	case V4L2_CID_DO_AUTO_FOCUS:		return "Do Auto Focus";

I'd perhaps use "begin" or "start". How does the user learn the autofocus
has finished? I think this looks like quite similar problem than telling the
flash strobe status to the user. The solution could also be similar to that.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
