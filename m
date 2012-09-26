Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-04.vtx.ch ([194.38.175.93]:41894 "EHLO smtp-04.vtx.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab2IZGv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 02:51:56 -0400
Received: from tuxstudio (dyn.83-228-176-046.dsl.vtx.ch [83.228.176.46])
	by smtp-04.vtx.ch (VTX Services SA) with ESMTP id AF7FA29BFA4
	for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 08:51:54 +0200 (CEST)
Date: Wed, 26 Sep 2012 09:48:41 +0200
From: Dominique Michel <dominique.michel@vtxnet.ch>
To: linux-media@vger.kernel.org
Subject: Re: HVR 4000 and DVB-API
Message-ID: <20120926094841.24615558@tuxstudio>
In-Reply-To: <201209252227.55241@leon.remlab.net>
References: <20120924095123.7db56ab3@tuxstudio>
	<201209252227.55241@leon.remlab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Tue, 25 Sep 2012 22:27:55 +0300,
"Rémi Denis-Courmont" <remi@remlab.net> a écrit :

Thanks for the answer.


> Le lundi 24 septembre 2012 10:51:23, Dominique Michel a écrit :
> > The WinTV HVR-4000-HD is a multi-tuners TV card with 2 dvb tuners.
> > It look like its driver doesn't have been updated to the new
> > DVB-API.
> 
> Multi-standard frontends required DVB API version 5.5. That is found
> in kernel versions 3.2 and later. So you might need to update the
> kernel. If you already have, then well, you need to get someone to
> update the driver.

I have kernel 3.4.5 with the in-kernel dvb driver, so it must be OK.
I just checked the kernel config, and it seam OK too. But just to be
sure, do you know if it is some specific kernel option that need to be
enabled in order to get the DVB API version 5.5, or is it the only one
that is in the kernel?

> 
> Also the application needs to be updated to support DVBv5.5 too. I
> don't know which versions of VDR support multi-standard frontends, if
> any as yet.
> 
In the main time, I will ask on the vdr forum. vdr-1.6.0 here, the last
stable version.

-- 
"We have the heroes we deserve."
