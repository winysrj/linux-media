Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.156.147.13] (helo=jenni1.rokki.sonera.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anssi.hannula@gmail.com>) id 1JymnS-0004Jn-Sk
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 13:47:55 +0200
Message-ID: <48340BE1.40003@gmail.com>
Date: Wed, 21 May 2008 14:47:45 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
MIME-Version: 1.0
To: Dominik Kuhlen <dkuhlen@gmx.net>
References: <200804190101.14457.dkuhlen@gmx.net>
In-Reply-To: <200804190101.14457.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e)
 and	TT-Connect-S2-3600 final version
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

Dominik Kuhlen wrote:
> Hi,

Hi!

> Here is my current version after quite a while of testing and tuning:
> I stripped the stb0899 tuning/searching algo to speed up tuning a bit
> now I have very fast and reliable locks (no failures, no errors)
> =

> I have also merged the TT-S2-3600 patch from Andr=E9. (I cannot test it t=
hough.)

I was able to use my TT-S2-3600 with your patches for DVB-S, with a few
caveats:

I can't tune to 12727 V with 18400 symbolrate on 1=B0W. The only
meaningful difference to other transponders on 1=B0W seems to be the
symbolrate.

$ ./simpletune -a 4 -f12717 -p v -s 18400 -d 1
using '/dev/dvb/adapter4/frontend0' as frontend
frontend fd=3D3: type=3D0
ioclt: FE_SET_VOLTAGE : 0
High band
tone: 1
dvbfe setparams :  delsys=3D1 2117MHz / Rate : 18400kBPS
Status: 00:
SNR: 222 173 (0xdead) (5700.5dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=3D2117.021

I also get some image distortions like Andr=E9 mentioned in his earlier
message.

-- =

Anssi Hannula

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
