Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.birch@gmail.com>) id 1JfDDh-00039H-9Y
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 12:58:06 +0100
Received: by wa-out-1112.google.com with SMTP id m28so269294wag.13
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 04:57:54 -0700 (PDT)
Message-ID: <972309270803280457x3f877ac3p2a8c8697242ace56@mail.gmail.com>
Date: Fri, 28 Mar 2008 22:57:53 +1100
From: "David Birch" <david.birch@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] dibcom 7070 support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1556791615=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1556791615==
Content-Type: multipart/alternative;
	boundary="----=_Part_13413_30658353.1206705473133"

------=_Part_13413_30658353.1206705473133
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
  i've seen a few posts to this list regarding the dibcom 7070 chips - a
friend just purchased a DVICO dual tuner 4 card - and it appears to be a new
revision changed from conexant to dibcom chips. A discussion is here:
http://forums.whirlpool.net.au/forum-replies-archive.cfm/919552.html
and a pic of the board is here:
http://mandmservices.com.au/dvico/IMGP0657.JPG
I'm just wondering if this device should be usable by applying similar
changes as here:
http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29144.html (for the
Emtec 810S DVB-T), but switching the device id for the dvico card?  The usb
part of the card is identified, just not the dvb parts.
I realise this is not quite a solution, but i'm just trying to get the card
going to start with... is this a silly idea hoping the fix could be this
simple?

thanks
David

------=_Part_13413_30658353.1206705473133
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br>&nbsp; i&#39;ve seen a few posts to this list regarding the dibcom 7070 chips - a friend just purchased a DVICO dual tuner 4 card - and it appears to be a new revision changed from conexant to dibcom chips. A discussion is here: <a href="http://forums.whirlpool.net.au/forum-replies-archive.cfm/919552.html">http://forums.whirlpool.net.au/forum-replies-archive.cfm/919552.html</a><br>
and a pic of the board is here: <a href="http://mandmservices.com.au/dvico/IMGP0657.JPG">http://mandmservices.com.au/dvico/IMGP0657.JPG</a><br>I&#39;m just wondering if this device should be usable by applying similar changes as here: <a href="http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29144.html">http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29144.html</a> (for the Emtec 810S DVB-T), but switching the device id for the dvico card?&nbsp; The usb part of the card is identified, just not the dvb parts.<br>
I realise this is not quite a solution, but i&#39;m just trying to get the card going to start with... is this a silly idea hoping the fix could be this simple?<br><br>thanks<br>David<br>

------=_Part_13413_30658353.1206705473133--


--===============1556791615==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1556791615==--
