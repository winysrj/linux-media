Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm50-vm4.bullet.mail.bf1.yahoo.com ([216.109.115.223]:21578
	"EHLO nm50-vm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411Ab3HQTzG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 15:55:06 -0400
References: <1376586925.5384.YahooMailNeo@web140001.mail.bf1.yahoo.com> <1376642528.76478.YahooMailNeo@web140001.mail.bf1.yahoo.com> <000001ce9acf$f68c4a20$e3a4de60$@com>
Message-ID: <1376769304.26176.YahooMailNeo@web140006.mail.bf1.yahoo.com>
Date: Sat, 17 Aug 2013 12:55:04 -0700 (PDT)
From: Jody Gugelhupf <knueffle@yahoo.com>
Reply-To: Jody Gugelhupf <knueffle@yahoo.com>
Subject: Re: DVR card SAA7134/SAA7135HL unknown
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <000001ce9acf$f68c4a20$e3a4de60$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

thanks, but that does not work
33,33,33,33,33,33,33,33
97,97,97,97,97,97,97,97 
both do seem to work, maybe even more, but i wonder how to determine the best/right one or does that not matter?
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

