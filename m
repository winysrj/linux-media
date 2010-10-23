Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab0JWAYx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 20:24:53 -0400
Message-ID: <4CC22B52.7040003@redhat.com>
Date: Fri, 22 Oct 2010 22:24:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: tvbox <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH][UPDATE for 2.6.37] LME2510(C) DM04/QQBOX USB DVB-S BOXES
References: <1287258283.494.10.camel@canaries-desktop>
In-Reply-To: <1287258283.494.10.camel@canaries-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-10-2010 16:44, tvbox escreveu:
> Updated driver for DM04/QQBOX USB DVB-S BOXES to version 1.60
> 
> These include
> -later kill of usb_buffer to avoid kernel crash on hot unplugging.
> -DiSEqC functions.
> -LNB Power switch
> -Faster channel change.
> -support for LG tuner on LME2510C.
> -firmware switching for LG tuner.

Please, don't do updates like that, adding several different things into just
one patch. Instead, send one patch per change.

This time, I'll accept it as-is, but please break it into small patches next time.

Thanks,
Mauro.
