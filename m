Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([69.56.170.18]:35727 "EHLO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818Ab3HSSQ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 14:16:56 -0400
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway07.websitewelcome.com (Postfix) with ESMTP id 064A12300FD5B
	for <linux-media@vger.kernel.org>; Mon, 19 Aug 2013 12:56:04 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Jody Gugelhupf'" <knueffle@yahoo.com>,
	<linux-media@vger.kernel.org>
References: <1376586925.5384.YahooMailNeo@web140001.mail.bf1.yahoo.com> <1376642528.76478.YahooMailNeo@web140001.mail.bf1.yahoo.com> <000001ce9acf$f68c4a20$e3a4de60$@com> <1376769304.26176.YahooMailNeo@web140006.mail.bf1.yahoo.com>
In-Reply-To: <1376769304.26176.YahooMailNeo@web140006.mail.bf1.yahoo.com>
Subject: RE: DVR card SAA7134/SAA7135HL unknown
Date: Mon, 19 Aug 2013 10:56:47 -0700
Message-ID: <000001ce9d05$799d91d0$6cd8b570$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As long as you found a card number that works, it shouldn't matter. BTW, do
you have its card info, like manufacturer, Model number, picture, ..., etc.?
What's your app? If you only use it for video surveillance and don't need
stereo audio, you may use a low cost capture card, like Sensoray Model 812
(http://www.sensoray.com/products/812.htm) for your application.

Best,

Charlie X. Liu @ Sensoray Company, Inc.


-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Jody Gugelhupf
Sent: Saturday, August 17, 2013 12:55 PM
To: linux-media@vger.kernel.org
Subject: Re: DVR card SAA7134/SAA7135HL unknown

thanks, but that does not work
33,33,33,33,33,33,33,33
97,97,97,97,97,97,97,97 
both do seem to work, maybe even more, but i wonder how to determine the
best/right one or does that not matter?
thx in advance
jody


----- Original Message -----
From: Charlie X. Liu <charlie@sensoray.com>
To: 'Jody Gugelhupf' <knueffle@yahoo.com>; linux-media@vger.kernel.org
Cc: 
Sent: Saturday, August 17, 2013 12:28:41 AM
Subject: RE: DVR card SAA7134/SAA7135HL unknown

You may use "card=73,73,73,73,73,73,73,73"

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Jody Gugelhupf
Sent: Friday, August 16, 2013 1:42 AM
To: linux-media@vger.kernel.org
Subject: Re: DVR card SAA7134/SAA7135HL unknown

Seems like something went wrong with pastebin, here the info again, would
really appreciate some help:
http://pastebin.com/TUTpkc0F


----- Original Message -----
From: Jody Gugelhupf <knueffle@yahoo.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: 
Sent: Thursday, August 15, 2013 7:15:25 PM
Subject: DVR card SAA7134/SAA7135HL unknown

hi all :)
trying to get this 8 channel dvr card to work in linux, but I get this:

Board is currently unknown. You might try to use the card=<nr>
saa7134: insmod option to specify which board do you have, but this is
saa7134: somewhat risky, as might damage your card. It is better to ask
saa7134: for support at linux-media@vger.kernel.org.

so here I am. I have not tried to set the card myself as I don't know what
number to use. Was hoping I could get some help here to get it working. Some
info I collected so far can be found here http://pastebin.ca/2430477 any
ideas what I might try next or what card to specify?
thank you in advance for any help.
jody
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

