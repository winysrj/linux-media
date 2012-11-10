Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36586 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752688Ab2KJUz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Nov 2012 15:55:27 -0500
Date: Sat, 10 Nov 2012 22:55:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: drivers without explicit MAINTAINERS entry - was: Re:
 [media-workshop] Tentative Agenda for the November workshop
Message-ID: <20121110205522.GJ25623@valkosipuli.retiisi.org.uk>
References: <201210221035.56897.hverkuil@xs4all.nl>
 <20121025152701.0f4145c8@redhat.com>
 <201211011644.50882.hverkuil@xs4all.nl>
 <20121101141244.6c72242c@redhat.com>
 <20121102111310.755e38aa@gaivota.chehab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102111310.755e38aa@gaivota.chehab>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Nov 02, 2012 at 11:13:10AM -0200, Mauro Carvalho Chehab wrote:
...
These are "Maintained" by me (with Laurent):

> i2c/adp1653.ko                 = i2c/adp1653.c
> i2c/as3645a.ko                 = i2c/as3645a.c

"Maintained" by me:

> i2c/smiapp-pll.ko              = i2c/smiapp-pll.c
> i2c/smiapp/smiapp.ko           = i2c/smiapp/smiapp-core.c i2c/smiapp/smiapp-regs.c i2c/smiapp/smiapp-quirk.c i2c/smiapp/smiapp-limits.c

"Odd fixes":

> i2c/tcm825x.ko                 = i2c/tcm825x.c
> platform/omap2cam.ko           = platform/omap24xxcam.c platform/omap24xxcam-dma.c

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
