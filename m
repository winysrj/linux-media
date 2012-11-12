Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2KLKiN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 05:38:13 -0500
Date: Mon, 12 Nov 2012 08:37:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: drivers without explicit MAINTAINERS entry - was: Re:
 [media-workshop] Tentative Agenda for the November workshop
Message-ID: <20121112083715.3d9a6b37@redhat.com>
In-Reply-To: <20121110205522.GJ25623@valkosipuli.retiisi.org.uk>
References: <201210221035.56897.hverkuil@xs4all.nl>
	<20121025152701.0f4145c8@redhat.com>
	<201211011644.50882.hverkuil@xs4all.nl>
	<20121101141244.6c72242c@redhat.com>
	<20121102111310.755e38aa@gaivota.chehab>
	<20121110205522.GJ25623@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Em Sat, 10 Nov 2012 22:55:22 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Fri, Nov 02, 2012 at 11:13:10AM -0200, Mauro Carvalho Chehab wrote:
> ...
> These are "Maintained" by me (with Laurent):
> 
> > i2c/adp1653.ko                 = i2c/adp1653.c
> > i2c/as3645a.ko                 = i2c/as3645a.c
> 
> "Maintained" by me:
> 
> > i2c/smiapp-pll.ko              = i2c/smiapp-pll.c
> > i2c/smiapp/smiapp.ko           = i2c/smiapp/smiapp-core.c i2c/smiapp/smiapp-regs.c i2c/smiapp/smiapp-quirk.c i2c/smiapp/smiapp-limits.c
> 
> "Odd fixes":
> 
> > i2c/tcm825x.ko                 = i2c/tcm825x.c
> > platform/omap2cam.ko           = platform/omap24xxcam.c platform/omap24xxcam-dma.c
> 
> Regards,
> 


Care to send us a patch with the above? It is likely better to have one entry per
driver, to reduce the risk of merge conflicts upstream.

-- 
Regards,
Mauro
