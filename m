Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.km20937-01.keymachine.de ([84.19.184.169]:55213 "EHLO
	mail.mojo.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZINV3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 17:29:11 -0400
Received: from maistor.s-und-s.home (eko [84.112.117.162])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.mojo.cc (Postfix) with ESMTP id 1E67F316007A
	for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 23:29:13 +0200 (CEST)
From: Emanoil Kotsev <emanoil.kotsev@sicherundsicher.at>
Reply-To: Emanoil Kotsev <emanoil.kotsev@sicherundsicher.de>
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec T USB XXS 0ccd:00ab device
Date: Mon, 14 Sep 2009 23:29:05 +0200
References: <200909131457.05286.emanoil.kotsev@sicherundsicher.at>
In-Reply-To: <200909131457.05286.emanoil.kotsev@sicherundsicher.at>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909142329.06809.emanoil.kotsev@sicherundsicher.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just for the record

На Sunday 13 September 2009 14:56:56 Emanoil Kotsev написа:
> Hello, I've just subscribed this list. I'm normally using knode to read
> news, but somehow I can not pull the groups etc from the vger server.
>
> I also tried to post to linux-dvb mailing list, but found out that it moved
> here. If you think I need to know something explicitly about participating
> to the list, please let me know.

Something is completely wrong with this "linux-dvb" list. I subscriubed there before and people are posting - I'm getting the mails.

>
> The issue I'm facing is that my old TV card (HVR900) stopped working, so I
> googled around and decided to buy Terratec T USB XXS, reading it was
> supported in dvb_usb_dib0700
>
> However after installing the card (usb-stick) it was not recognized (my one
> has product id 0x00ab and not 0x0078), so I googled again and found a hint
> to change the device id in dvb_usb_ids.h which was working for other
> Terratec card.

It seems there are two device ids covering the same card model 

 http://linux.terratec.de/tv_en.html

>
> I pulled the latest v4l-dvb code and did it (perhaps I could have done it
> in the kernel 2.6.31), compiled, installed and it started working.

no dvb_usb_dib0700 is not part of the mainstream kernel yet

>
> However I can not handle udev to get the remote control links created
> correctly. Can someone help me with it? How can I provide useful output to
> developers to solve the issues with ir? I read and saw that ir control keys
> are coded in the driver, so if the ir part of the 0x00ab card is different,
> how can I get a useful information that can be coded for this card? Who is
> doing the work at linux-dvb?

http://www.linuxtv.org/wiki/index.php/Template:Making-it-work:dvb-usb-dib0700

helped solve the issues

however you don't get this page listed in google under top ten (at least on my pc)

>
> I read there are other people, returning the cards to the seller, because
> it's not working/supported by linux, which does not seem to be really true.

This is really stupid idea to give up something that easily.

>
> Luckilly I have a bit kernel experience and good C knowledge and could do
> testing if somebody can have a look at the issues - the code is completely
> new to me so that I prefer to be an alpha tester for the device.
>

The offer still holds - someebody should change the code to make it work

regards

-- 
pub   1024D/648C084C 2008-06-06 Emanoil Kotsev 
<emanoil.kotsev@sicherundsicher.at>
 Primary key fingerprint: 002C AF99 232A 5A44 EF9E  6D7D 0D65 4160 648C 084C
