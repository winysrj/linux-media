Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47984 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0JWJPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 05:15:30 -0400
Received: by wyf28 with SMTP id 28so1708669wyf.19
        for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 02:15:29 -0700 (PDT)
Subject: Re: [PATCH][UPDATE for 2.6.37] LME2510(C) DM04/QQBOX USB DVB-S
 BOXES
From: tvbox <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4CC22B52.7040003@redhat.com>
References: <1287258283.494.10.camel@canaries-desktop>
	 <4CC22B52.7040003@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Oct 2010 10:15:26 +0100
Message-ID: <1287825326.6605.43.camel@canaries-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2010-10-22 at 22:24 -0200, Mauro Carvalho Chehab wrote:
> Em 16-10-2010 16:44, tvbox escreveu:
> > Updated driver for DM04/QQBOX USB DVB-S BOXES to version 1.60
> > 
> > These include
> > -later kill of usb_buffer to avoid kernel crash on hot unplugging.
> > -DiSEqC functions.
> > -LNB Power switch
> > -Faster channel change.
> > -support for LG tuner on LME2510C.
> > -firmware switching for LG tuner.
> 
> Please, don't do updates like that, adding several different things into just
> one patch. Instead, send one patch per change.
> 
The patches as released is a working driver.

This device is particularly temperamental and covers several
adaptations. The driver returned to beta testing through several of
those changes.

I didn't want release patches that would have produced an unworkable
driver for the user.

Regards

Malcolm

