Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110813.mail.gq1.yahoo.com ([67.195.13.236]:41902 "HELO
	web110813.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753632AbZCLOZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 10:25:31 -0400
Message-ID: <541911.18449.qm@web110813.mail.gq1.yahoo.com>
Date: Thu, 12 Mar 2009 07:25:29 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS based cards
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Mauro and all,

I submitted 3 patches, two modifications for the SDIO generic stack, and one new high level SDIO interface driver for Siano based devices.

This concludes SDIO related changes, with one exception, which is explained below.

However this explanation requires some overview about Siano's module inner architecture.

The Siano kernel module architecture is composed from:
1) SMS "Core" - This main component holds all Siano's host-device protocol logic, and any logic needed to bind the other module's components, interface and adapters.
2) Interfaces drivers (SDIO, USB, TS, SPP, HIF, ...) - At lease one interface driver must be compiled and linked, but multiple interfaces are supported. This feature enables platforms like the Asus UMPC series to use SMS based USB dongle and SMS based SDIO dongle simultaneously. 
3) Client adapters (DVB API v3, DVB API v5, others) - Similar to the interfaces drivers, at least one client adapter must be linked, but multiple are supported.
4) SMS "cards" - This component contains any hardware target specific information (like LEDs locations, antenna configuration, alternative firmware names, and much more), leaving any other component target-independent.


And now back to SDIO....

True all SDIO related sources files are now updated (after these 3 patches), but since the build system (Kconfig & Makefile) and "smscore" component are yet to be updated, the SDIO interface driver can not be linked into the module.
The option to link and use the SDIO interface driver, will be available after those files will be updated (hope it'll happen shortly).


One question: Should I continue submit patches (I have them ready), or should I wait till the 3 previous submission will be reviewed and committed?


Regards,

Uri





      
