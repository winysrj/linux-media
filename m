Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:44694 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753657AbaJHS2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 14:28:14 -0400
Message-ID: <5435823A.8000309@uli-eckhardt.de>
Date: Wed, 08 Oct 2014 20:28:10 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: Tevii S480 on Unicable SCR System
References: <542C4B14.8030708@uli-eckhardt.de> <54356BB9.5000609@uli-eckhardt.de> <20141008150038.4ca96c22.m.chehab@samsung.com>
In-Reply-To: <20141008150038.4ca96c22.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.10.2014 um 20:00 schrieb Mauro Carvalho Chehab:
> Em Wed, 08 Oct 2014 18:52:09 +0200
> Ulrich Eckhardt <uli-lirc@uli-eckhardt.de> escreveu:
>>  
>>         /*
>> +        * Ensure that frontend voltage is switched off on initialization
>> +        */
>> +       if (dvb_powerdown_on_sleep) {
> 
> I'm wandering why to test if (dvb_powerdown_on_sleep) here...
> 
> MODULE_PARM_DESC(dvb_powerdown_on_sleep, "0: do not power down, 1: turn LNB voltage off on sleep (default)");
> 
> That controls what happens when the frontend's thread stops, and not
> what happens during device initialization.
> So, IMHO, it doesn't apply here.

OK, I agree.

> My vote is to fix it at the driver's level.

So if no other opinions turns up the next days and this problem occurs only on 
the Tevii card, I will reformat my patch in my first E-Mail correctly for 
submission. 
 
Best Regards
Uli
-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste 
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
