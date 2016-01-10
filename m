Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49327 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333AbcAJSfo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 13:35:44 -0500
Received: from axis700.grange ([87.79.216.87]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0Ln7wj-1ZiCKh1RHR-00hLCv for
 <linux-media@vger.kernel.org>; Sun, 10 Jan 2016 19:35:42 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 0625A13EC9
	for <linux-media@vger.kernel.org>; Sun, 10 Jan 2016 19:35:41 +0100 (CET)
Date: Sun, 10 Jan 2016 19:35:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] 3.5 fixes
In-Reply-To: <Pine.LNX.4.64.1601101931050.24180@axis700.grange>
Message-ID: <Pine.LNX.4.64.1601101935230.24180@axis700.grange>
References: <Pine.LNX.4.64.1601101931050.24180@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, 4.5, of course.

On Sun, 10 Jan 2016, Guennadi Liakhovetski wrote:

> Hi Mauro,
> 
> Please, pull 2 fixes for 3.5, they should be also fine for -rc2 if it's 
> too late to push them for -rc1.
> 
> The following changes since commit 768acf46e1320d6c41ed1b7c4952bab41c1cde79:
> 
>   [media] rc: sunxi-cir: Initialize the spinlock properly (2015-12-23 15:51:40 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.5-2
> 
> for you to fetch changes up to 9c09aca87e259e090250833989e855e5a84eaa45:
> 
>   atmel-isi: fix debug message which only show the first format (2016-01-09 12:30:27 +0100)
> 
> ----------------------------------------------------------------
> Josh Wu (1):
>       atmel-isi: fix debug message which only show the first format
> 
> Wolfram Sang (1):
>       soc_camera: cleanup control device on async_unbind
> 
>  drivers/media/platform/soc_camera/atmel-isi.c  | 2 +-
>  drivers/media/platform/soc_camera/soc_camera.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> Thanks
> Guennadi
> 
