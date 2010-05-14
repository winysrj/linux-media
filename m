Return-path: <linux-media-owner@vger.kernel.org>
Received: from web27805.mail.ukl.yahoo.com ([217.146.182.10]:47708 "HELO
	web27805.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757120Ab0ENSUM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 14:20:12 -0400
Message-ID: <399556.40549.qm@web27805.mail.ukl.yahoo.com>
Date: Fri, 14 May 2010 18:20:09 +0000 (GMT)
From: marc balta <marc_balta@yahoo.de>
Subject: Re: Stuck Digittrade DVB-T stick (dvb_usb_af9015)
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4BED857A.9050203@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thx for responding so fast. Ok I have updated:

May 14 20:11:57 debian kernel: af9013: firmware version:5.1.0
May 14 20:11:57 debian kernel: DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
May 14 20:11:57 debian kernel: MT2060: successfully identified (IF1 = 1220)

Now lets wait 3 days ...

Greetings,
Marc


--- Antti Palosaari <crope@iki.fi> schrieb am Fr, 14.5.2010:

> Von: Antti Palosaari <crope@iki.fi>
> Betreff: Re: Stuck Digittrade DVB-T stick (dvb_usb_af9015)
> An: "marc balta" <marc_balta@yahoo.de>
> CC: linux-media@vger.kernel.org
> Datum: Freitag, 14. Mai, 2010 19:16 Uhr
> Terve
> 
> On 05/14/2010 02:17 PM, marc balta wrote:
> > would be nice because it is happening rather often :
> Every second or third day. Is there a way to reinit the
> device with a script wihtout restarting my server and
> without influencing other usb devices. If yes I could reinit
> the device say two minutes before every recording starts
> using a hook. This would solve my problems.
> 
> I just added support for new firmware 5.1.0.0. Please test
> if it helps.
> http://linuxtv.org/hg/~anttip/af9015/
> http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/
> 
> regards
> Antti
> -- http://palosaari.fi/
> 


