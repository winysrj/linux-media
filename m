Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f191.google.com ([209.85.221.191]:63960 "EHLO
	mail-qy0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0BVTxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 14:53:32 -0500
Received: by qyk29 with SMTP id 29so370024qyk.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 11:53:31 -0800 (PST)
Message-ID: <4B82E0B5.5090508@gmail.com>
Date: Mon, 22 Feb 2010 16:53:25 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [GIT FIXES FOR 2.6.34] uvcvideo updates
References: <201002182121.51921.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201002182121.51921.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Mauro,
> 
> The following changes since commit 8e17df0d68f260e9e722b5f3adfa18f553542f93:
>   Randy Dunlap (1):
>         V4L/DVB: dvb: fix sparse warnings
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo
> 
> Laurent Pinchart (7):
>       uvcvideo: Increase the streaming control timeout to 5 seconds
>       uvcvideo: Use %pUl printk format specifier to print GUIDs
>       uvcvideo: Return -ERANGE when setting a control to an out-of-range menu index
>       uvcvideo: Cache control min, max, res and def query results

# ERROR: spaces prohibited around that ':' (ctx:WxW)
# #213: FILE: drivers/media/video/uvc/uvcvideo.h:248:
# +          modified : 1,
#                     ^
#  
# ERROR: spaces prohibited around that ':' (ctx:WxW)
# #214: FILE: drivers/media/video/uvc/uvcvideo.h:249:
# +          cached : 1;
#                   ^
#
# total: 2 errors, 0 warnings, 190 lines checked

As the other bitmask flags are also with spaces, I'll apply.
Please fix them later.

Cheers,
Mauro
