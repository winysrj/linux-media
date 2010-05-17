Return-path: <linux-media-owner@vger.kernel.org>
Received: from web27806.mail.ukl.yahoo.com ([217.146.182.11]:24549 "HELO
	web27806.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751261Ab0EQOSM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 May 2010 10:18:12 -0400
Message-ID: <96187.19117.qm@web27806.mail.ukl.yahoo.com>
Date: Mon, 17 May 2010 14:18:10 +0000 (GMT)
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

hi,

After the past days there has been no device crash anymore but another problem:

it seems after some time running the device (some hours) tuning takes longer and longer until it isnt  possible at all anymore to tune to some channels, although signal strength is sufficient: rmmoding and modprobing the driver (dvb_usb_af9015) solves the problem and tuning is fast on the same channel again.



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


