Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:49795 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbZLCWDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 17:03:52 -0500
Subject: Re: V4L1 compatibility broken for VIDIOCGTUNER with radio
From: hermann pitton <hermann-pitton@arcor.de>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200912031656.20893.herton@mandriva.com.br>
References: <200912031656.20893.herton@mandriva.com.br>
Content-Type: text/plain
Date: Thu, 03 Dec 2009 22:54:29 +0100
Message-Id: <1259877269.10943.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 03.12.2009, 16:56 -0200 schrieb Herton Ronaldo
Krzesinski:
> Hi,
> 
> After commit 9bedc7f ("V4L/DVB (12429): v4l2-ioctl: fix G_STD and G_PARM 
> default handlers"), radio software using V4L1 stopped to work on a saa7134 
> card, a git bisect pointed to this commit introducing the regression. All 
> VIDIOCGTUNER calls on a v4l1 application are returning -EINVAL after this 
> commit.
> 
> Investigating the issue, it turns out that v4l1_compat_get_tuner calls 
> VIDIOC_G_STD ioctl, but as it is a radio device (saa7134-radio) it now is 
> returning -EINVAL to user space applications which are being confused about 
> this.
> 
> May be VIDIOC_G_STD change in the commit above should be reverted, or 
> v4l1_compat_get_tuner changed to not return error with G_STD, or not call 
> G_STD ioctl for a radio device?
> 
> --
> []'s
> Herton

it was fixed here.

http://linuxtv.org/hg/v4l-dvb/rev/58ecda742a70

Maybe it was not ported to stable?

Cheers,
Hermann


