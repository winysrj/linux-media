Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43270 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755248Ab2INVZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 17:25:26 -0400
Message-ID: <5053A115.9060303@iki.fi>
Date: Sat, 15 Sep 2012 00:26:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFCv3 API PATCH 00/31] Full series of API fixes from the 2012
 Media Workshop
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi all,
>
> This is the full patch series containing API fixes as discussed during the
> 2012 Media Workshop.
>
> Regarding the 'make ioctl const' patches: I've only done the easy ones in
> this patch series. The remaining write-only ioctls are used much more widely,
> so changing those will happen later.
>
> The last few patches that enhance the core code with more stringent tests
> against what ioctls can be called for which types of device node will need
> reviewing. I have tested it exhaustively with ivtv (which is one of the
> most complex drivers, and the only one that has exotic devices like VBI
> out).
>
> To use v4l2-compliance with ivtv I also needed to make a few other fixes
> elsewhere. The tree with both this patch series and the addition ivtv fixes
> can be found here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/ivtv
>
> I have also tested this patch series (actually a slightly older version)
> with em28xx. That driver needed a lot of changes to get it to pass the
> v4l2-compliance tests. Those can be found here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/em28xx

Hi, Hans!

Thanks for the patchset!

On patch 7 (which I somehow managed not to receive): both cx18 and ivtv 
contain references to V4L2_BUF_TYPE_PRIVATE. I wonder if that's intentional.

For patches 2, 3, 4, 6, 8, 17 and 28 (for omap3isp)

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

And for patches 5, 11, 18

Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
