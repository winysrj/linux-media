Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34008 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932161Ab2DMUNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 16:13:38 -0400
Message-ID: <4F8888EF.6040904@iki.fi>
Date: Fri, 13 Apr 2012 23:13:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 1/3] Support integer menus.
References: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi> <2967674.Tm7K8VO7YX@avalon>
In-Reply-To: <2967674.Tm7K8VO7YX@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments.

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thanks for the patch.
>
> The code looks fine, but unfortunately breaks compilation when using kernel
> headers<  v3.5 (which is a pretty common case as of today ;-)).
>
> V4L2_CTRL_TYPE_INTEGER_MENU is an enumerated value, not a pre-processor
> #define, so it's difficult to test for it using conditional compilation.
>
> Maybe including a copy of videodev2.h in the yavta repository is the best
> option ?

Yeah; I agree. The value of the enum item we could still #define but the 
addition of the union to v4l2_queryctrl is more difficult.

I can then remove existing code to cope with different versions of 
videodev2.h, too.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
