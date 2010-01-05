Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:39348 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0AEMkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 07:40:13 -0500
To: linux-media@vger.kernel.org
cc: Manu Abraham <manu@linuxtv.org>
Subject: Mantis driver: RC support for "CableStar HD 2" ?
From: Wolfgang Denk <wd@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Tue, 05 Jan 2010 13:40:09 +0100
Message-Id: <20100105124009.88433EA195D@gemini.denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

can anybody tell me if the RC support for the "CableStar HD 2" DVB-C
card is supposed to be working? I'm trying the drivers from the
http://linuxtv.org/hg/v4l-dvb repository in combination with the
current Fedora 12 kernel (2.6.31.9-174.fc12.i686.PAE kernel).

I managed to see the registration of an UART device ("Initializing
UART @ 9600bps parity:NONE"), but I don't se a corresponding device
node for this (nor do I know where I should look for it, or if there
is some other way to make LIRC work with this UART).

I also notice that there is mantis/mantis_input.c which eventually
might provide a standard input device, but the code is not hooked up
anywhere and thus does not get executed; and from a closer look it
seems as if it didn't work if enabled either.


Or is there a more recent version of the mantis driver somewhere else?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
How many Unix hacks does it take to change a light bulb?  Let's  see,
   can you use a shell script for that or does it need a C program?
