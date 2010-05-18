Return-path: <linux-media-owner@vger.kernel.org>
Received: from web27803.mail.ukl.yahoo.com ([217.146.182.8]:40250 "HELO
	web27803.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751964Ab0ERLLo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 07:11:44 -0400
Message-ID: <130535.72294.qm@web27803.mail.ukl.yahoo.com>
Date: Tue, 18 May 2010 11:11:41 +0000 (GMT)
From: marc balta <marc_balta@yahoo.de>
Subject: Re: Stuck Digittrade DVB-T stick (dvb_usb_af9015)
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

ok forget this time it took a little bit longer: The same problem occured again with the symptoms i explaines previously: Including a very unresponsive system (keyboard press takes 2 seconds for being recognized by the system).

--- marc balta <marc_balta@yahoo.de> schrieb am Mo, 17.5.2010:

> Von: marc balta <marc_balta@yahoo.de>
> Betreff: Re: Stuck Digittrade DVB-T stick (dvb_usb_af9015)
> An: "Antti Palosaari" <crope@iki.fi>
> CC: linux-media@vger.kernel.org
> Datum: Montag, 17. Mai, 2010 16:18 Uhr
> hi,
> 
> After the past days there has been no device crash anymore
> but another problem:
> 
> it seems after some time running the device (some hours)
> tuning takes longer and longer until it isnt  possible
> at all anymore to tune to some channels, although signal
> strength is sufficient: rmmoding and modprobing the driver
> (dvb_usb_af9015) solves the problem and tuning is fast on
> the same channel again.
> 
> 
> 
> Greetings,
> Marc
> 
> --- Antti Palosaari <crope@iki.fi>
> schrieb am Fr, 14.5.2010:
> 
> > Von: Antti Palosaari <crope@iki.fi>
> > Betreff: Re: Stuck Digittrade DVB-T stick
> (dvb_usb_af9015)
> > An: "marc balta" <marc_balta@yahoo.de>
> > CC: linux-media@vger.kernel.org
> > Datum: Freitag, 14. Mai, 2010 19:16 Uhr
> > Terve
> > 
> > On 05/14/2010 02:17 PM, marc balta wrote:
> > > would be nice because it is happening rather
> often :
> > Every second or third day. Is there a way to reinit
> the
> > device with a script wihtout restarting my server and
> > without influencing other usb devices. If yes I could
> reinit
> > the device say two minutes before every recording
> starts
> > using a hook. This would solve my problems.
> > 
> > I just added support for new firmware 5.1.0.0. Please
> test
> > if it helps.
> > http://linuxtv.org/hg/~anttip/af9015/
> > http://palosaari.fi/linux/v4l-dvb/firmware/af9015/5.1.0.0/
> > 
> > regards
> > Antti
> > -- http://palosaari.fi/
> > 
> 
> 
> 


