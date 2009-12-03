Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:58614 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZLCXEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 18:04:08 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: V4L1 compatibility broken for VIDIOCGTUNER with radio
Date: Thu, 3 Dec 2009 21:04:10 -0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <200912031656.20893.herton@mandriva.com.br> <1259877269.10943.3.camel@pc07.localdom.local>
In-Reply-To: <1259877269.10943.3.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912032104.10785.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Qui 03 Dez 2009, às 19:54:29, hermann pitton escreveu:
> Hi,
> 
> Am Donnerstag, den 03.12.2009, 16:56 -0200 schrieb Herton Ronaldo
> Krzesinski:
> > Hi,
> > 
> > After commit 9bedc7f ("V4L/DVB (12429): v4l2-ioctl: fix G_STD and G_PARM 
> > default handlers"), radio software using V4L1 stopped to work on a saa7134 
> > card, a git bisect pointed to this commit introducing the regression. All 
> > VIDIOCGTUNER calls on a v4l1 application are returning -EINVAL after this 
> > commit.
> > 
> > Investigating the issue, it turns out that v4l1_compat_get_tuner calls 
> > VIDIOC_G_STD ioctl, but as it is a radio device (saa7134-radio) it now is 
> > returning -EINVAL to user space applications which are being confused about 
> > this.
> > 
> > May be VIDIOC_G_STD change in the commit above should be reverted, or 
> > v4l1_compat_get_tuner changed to not return error with G_STD, or not call 
> > G_STD ioctl for a radio device?
> > 
> > --
> > []'s
> > Herton
> 
> it was fixed here.
> 
> http://linuxtv.org/hg/v4l-dvb/rev/58ecda742a70

Indeed, thanks for the pointer. I forgot to check latest v4l1-compat.c /o\

> 
> Maybe it was not ported to stable?

Not on latest stable (2.6.31.6), perhaps it should be forwarded.

> 
> Cheers,
> Hermann

--
[]'s
Herton
