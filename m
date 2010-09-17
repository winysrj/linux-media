Return-path: <mchehab@pedra>
Received: from psmtp12.wxs.nl ([195.121.247.24]:35014 "EHLO psmtp12.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab0IQR6y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 13:58:54 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp12.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L8W001P4KM5FM@psmtp12.wxs.nl> for linux-media@vger.kernel.org;
 Fri, 17 Sep 2010 19:58:53 +0200 (MEST)
Date: Fri, 17 Sep 2010 19:58:52 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: rtl2832 chip driver
In-reply-to: <1284744791.1670.11.camel@sofia>
To: "Ole W. Saastad" <olewsaa@online.no>
Cc: linux-media@vger.kernel.org
Message-id: <4C93AC5C.1090001@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <1284744791.1670.11.camel@sofia>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Ole:

Try vlc or keffeins, and see if they have the same audio problem.
Also: try playing a normal sound mp3 file with them.
me-tv and rtl2832 havce some problems:
https://bugs.launchpad.net/ubuntu/+source/me-tv/+bug/478379

Thanks for the Sandberg link.
At:
http://www.sandberg.it/support/product.aspx?id=133-59
I found Realtek stuff that looks very familiar to the RTL2831 stuff I 
put into another HG branch:
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2

This is again code where the frontend and backend have not been 
separated. Seems realtek has their branch kind of working, based on 
their windows approach.

Antti has set up a new version from scratch at:
http://linuxtv.org/hg/~anttip/rtl2831u/



Ole W. Saastad wrote:
> Thanks for all help so far.
> 
> I managed to figure out the firetv problem as soon as I discovered
> the .myconfig file.
> 
> Including the drivers from Sandberg, for the rtl2832 chip and adding
> some lines to Makefile, Kconfig and .myconfig it compiles and install.
> Modules load and Me-TV starts, quality is poor with the small antenna.
> 
> However, there is no audio. Not even for the DAB radio channels.
> 
> Maybe this is Me-TV problem?
> 
> The version supplied with Easy Peasy Ubuntu 9.10 is old,  0.7.16.
> 
> 
> Regards,
> Ole W. Saastad
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
