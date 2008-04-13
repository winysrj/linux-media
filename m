Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1Jkpld-0001Fo-Bw
	for linux-dvb@linuxtv.org; Sun, 13 Apr 2008 02:08:22 +0200
Message-ID: <48014ED3.6010305@gmx.net>
Date: Sun, 13 Apr 2008 02:07:47 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Morgan_T=F8rvolt?= <morgan.torvolt@gmail.com>
References: <47F92310.4040500@gmx.net> <47FA22ED.6060308@gmx.net>
	<3cc3561f0804081328h526ad2d9j2d8c8dca2fac38ea@mail.gmail.com>
In-Reply-To: <3cc3561f0804081328h526ad2d9j2d8c8dca2fac38ea@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend common interfaces think my CAM is
	invalid
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

On 04/08/2008 10:28 PM, Morgan T=F8rvolt wrote:
>> Knoppix didn't want to start (couldn't read the CD, not sure why, maybe
>>  too old), but I found a Ubuntu 7.04 live/install CD. Started with that,
>>  no difference. I did find something else: I've got three different
>>  lenghts CI cables. One approx. 60cm, a few others approx. 40cm and some
>>  approx. 4cm. With 60cm, both the offical Mediaguard CAM and Xcam won't
>>  initialize. With 40cm, the Xcam still won't and the Mediaguard will init
>>  about 50% of the time. With 4cm, both Xcam and Mediaguard will always
>>  init. But it still doesn't work properly, even with the 4cm cable I
>>  couldn't get a picture with the Mediaguard, and I had a picture for
>>  about half a minute with the Xcam after which Kaffeine would freeze.
> =

> Not surprising. Many of the CAMs are really picky about timing and signal=
ling.
> The Conax 4.00 cam works every time for me. What I suggest is that you
> try the patch I have linked to from
> http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_S-1500#CAM_te=
sts
> Which is this:
> http://www.linuxtv.org/pipermail/linux-dvb/2007-July/019116.html
> =

> There is some manual labour to get this patch working, but once done,
> all the CAMs I have initializes perfectly. I have no idea if the
> cable-length affects the process less after the patching, but it sure
> helps on initializing the CAMs I have.
> =

>>  I'm not sure if it's a driver problem, all I know is that this started
>>  right after installing a new v4l-dvb a few weeks ago. The problem seems
>>  to have no cause:
>>
>>  Not the DVB-card, as the S2-3200 had the same problem.
>>  Not the CI cable, tried many different cables and I don't believe they
>>  are all broken the same way.
>>  Not the CI-daughterboard, I even bought new ones with no result.
>>  Not the current v4l-dvb loaded, because a Ubuntu 7.04 live CD (kernel
>>  2.6.20 iirc) has the same result now.
>>  Not the computer, because the setup didn't work in another computer eit=
her.
>>  Not the CAM, all CAMs work fine in a Vantage standalone.
>>
>>  And note I have used this setup, S-1500+CI+long cable+Xcam for months
>>  without any problems.
> =

> You said you changed your powersupply. To a more powerful one? Some
> PSUs does give away troublesome noise, especially when heavily loaded.
> Also, some powerful PSUs have much of the power on wrong voltages, or
> spread across different cables, so that you might actually be pushing
> the PSU to it's limits on one circuit, while swapping some power
> cables would solve the whole issue.
> =

> BTW, the CI daughterboard is very simple, like in _very_ simple. It is
> very unlikely that this will break. If something is broken with CI, it
> would probably be the cable or the tuner-card.
> =

> -Morgan-
> =


Yeah, more power! Another computer (AMD Geode NX1750 and a laptop =

harddrive, the 480W Antec is very very bored) gives the same result. My =

regular computer was turned off when I tested that. The patch made no =

difference whatsoever. The Xcam is actually not picky at all, it is well =

  known for working in pretty much any receiver - and it does. For =

example, KNC1 CI's are quite picky but the Xcam has no problems with =

that. Even the Matrix Reborn won't run in a KNC1, yet the Xcam does.

I installed the card on Windows to test a bit. I also noted the CI works =

better on Linux when I fold the CI cable in tinfoil. Here's an overview =

of some tests:

*Windows, unshielded 40cm cable:
Xcam sometimes takes a while to init, but works on all tested channels =

after that (including RTL4 and RTL5).
Matrix Reborn: similar result.

*Linux, v4l-dvb from hg april 12, 40cm cable in tinfoil:
Xcam does init and works. But RTL4, RTL5 =

(http://nl.kingofsat.net/pack-canaldigitaal.php) give only sound. The =

videoPID is correct and I did a rescan. Audio is gone if I remove the =

CAM, so it is encrypted.
Matrix similar result, no picture on RTL4 and RTL5 here either, but =

apart from that it seems to work.

*Linux, v4l-dvb from hg april 12, unshielded 40cm cable:
Xcam does not init anymore. Not at all. Just "Invalid PC card inserted :(".
Matrix Reborn does init, but init fails sometimes as well. When it does =

init, I can watch most channels.. But not RTL4 or RTL5 (only sound).
SCM Conax 4.00e: init sometimes, but can't even get into the menu. Don't =

have a Conax subscription card right now.

RTL4 and RTL5 do work on Windows or a standalone receiver with CI. I =

also tried to disable all the power in the house and did a test with =

UPS, but the Xcam still would not init with the unshielded cable. So no =

electrical devices in the house went bad. The UPS or display are not the =

source either, tried unplugging them. And a S-1500, T-1500 and S2-3200 =

are all doing the same thing. I've also got a Aston 1.05 and official =

Mediaguard CAM to test if required.

Pim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
