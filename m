Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:40918 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbZANSSD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 13:18:03 -0500
Message-ID: <496E2C6B.3050607@scram.de>
Date: Wed, 14 Jan 2009 19:18:19 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Detlef Rohde <rohde.d@t-online.de>
CC: Roberto Ragusa <mail@robertoragusa.it>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: MC44S803 frontend (it works)
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de> <49623372.90403@robertoragusa.it> <4965327A.5000605@t-online.de> <496CD4C8.50004@t-online.de>
In-Reply-To: <496CD4C8.50004@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Detlef,

> I wonder if there is any progress including/merging the frontend-driver 
> MC44S803 i.o. to get my Cinergy T USB XE running under Linux? Currently 
> I can use it on a WXP-VM, but I guess it's not the best solution making 
> this detour..

Work is going on to merge this driver. However, it takes some time and review
cycles to make sure the driver meets the quality and code style as defined
in Documentation/development-process/2.Process.

Of course you could also download my kernel snapshot from
http://git.bocc.de/cgi-bin/gitweb.cgi?p=dbox2.git;a=snapshot;h=8d0441385cc9cf327d069b7185d2a647d4c77150
and test the preliminary driver ;-)

Thanks,
Jochen
