Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Andre.Weidemann@web.de>) id 1JUeFT-00060u-OI
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 09:36:15 +0100
Message-ID: <47C67273.8050102@web.de>
Date: Thu, 28 Feb 2008 09:36:03 +0100
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200801252245.58642.dkuhlen@gmx.net> <47C3D206.9020507@web.de>
	<47C5EEA2.8030307@gmail.com>
In-Reply-To: <47C5EEA2.8030307@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] TT Connect S2-3600
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Manu Abraham wrote:
> What do you use to play back ? is the distortions seen with dvb-s2/h.264 =

> only ?

I'm using vdr-1.5.12 with Reinhard Nissls h.264 patch and xine.
Just for comparison... Tuning with the TT S2-3200 works for DVB-S and =

DVB-S2 channels. The picture quality great, no distortion at all.

I managed to get a Pinnacle 452e for testing. The Pinnacle 452e as well =

as the TT connect S2-3600 show image distortions on all channels. There =

is no difference between channels on a DVB-S or DVB-S2 transponders. BER =

and UNC seem to be zero, if the femon output can still be trusted for =

the multiproto drivers.

My patch for the TT connect S2-3600 is far from perfect. I will =

hopefully be able to post a new version this week.

I just saw, that you have committed some changes to the multiproto tree =

a few days ago. I will check out the repository tonight and see how =

things are now.

Andr=E9

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
