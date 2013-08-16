Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm22-vm1.bullet.mail.bf1.yahoo.com ([98.139.212.127]:28662 "EHLO
	nm22-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab3HPMp6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 08:45:58 -0400
References: <1376586925.5384.YahooMailNeo@web140001.mail.bf1.yahoo.com> <1376642528.76478.YahooMailNeo@web140001.mail.bf1.yahoo.com>
Message-ID: <1376657157.35696.YahooMailNeo@web140004.mail.bf1.yahoo.com>
Date: Fri, 16 Aug 2013 05:45:57 -0700 (PDT)
From: Jody Gugelhupf <knueffle@yahoo.com>
Reply-To: Jody Gugelhupf <knueffle@yahoo.com>
Subject: Re: DVR card SAA7134/SAA7135HL unknown
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1376642528.76478.YahooMailNeo@web140001.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok, thanks to theBear on IRC i managed to get it working with mplayer, so in case someone in the future runs into the same problem i hope they will find my post.
I connected a camera to one cable and tried all inputs and video devices:
mplayer tv:// -tv driver=v4l2:device=/dev/video0:input=0

...
mplayer tv:// -tv driver=v4l2:device=/dev/video7:input=8


most resulting videos were just black, but there were also some green and some grey lines ones, then i remembered another post, namely:
http://www.zoneminder.com/wiki/index.php/Videocards_with_Philips_saa7134_chipset) 
So this made me add to my modprobe and rebooted:

alias char-major-81 videodev
alias char-major-81-0 saa7134
options saa7134 card=33,33,33,33


then tried the mplayer command again and it worked!!! :)



----- Original Message -----
From: Jody Gugelhupf <knueffle@yahoo.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: 
Sent: Friday, August 16, 2013 10:42:08 AM
Subject: Re: DVR card SAA7134/SAA7135HL unknown

Seems like something went wrong with pastebin, here the info again, would really appreciate some help:
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

so here I am. I have not tried to set the card myself as I don't know what number to use. Was hoping I could get some help here to get it working. Some info I collected so far can be found here http://pastebin.ca/2430477 any ideas what I might try next or what card to specify?
thank you in advance for any help.
jody 
