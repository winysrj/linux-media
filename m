Return-path: <linux-media-owner@vger.kernel.org>
Received: from jim.sh ([75.150.123.25]:41024 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab0CDUO4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Mar 2010 15:14:56 -0500
Date: Thu, 4 Mar 2010 15:14:45 -0500
From: Jim Paris <jim@jtan.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: "M.Ebrahimi" <m.ebrahimi@ieee.org>, Max Thrun <bear24rw@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-ID: <20100304201445.GA21194@psychosis.jim.sh>
References: <20100228194951.1c1e26ce@tele>
 <20100228201850.81f7904a.ospite@studenti.unina.it>
 <20100228205528.54d1ba69@tele>
 <1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
 <20100302163937.70a15c19.ospite@studenti.unina.it>
 <7b67a5ec1003020806x65164673ue699de2067bc4fb8@mail.gmail.com>
 <1d742ad81003021827p181bf0a6mdf87ad7535bc37bd@mail.gmail.com>
 <20100303090008.f94e7789.ospite@studenti.unina.it>
 <20100304045533.GA17821@psychosis.jim.sh>
 <20100304100346.79818884.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20100304100346.79818884.ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Antonio Ospite wrote:
> On Wed, 3 Mar 2010 23:55:33 -0500
> Jim Paris <jim@jtan.com> wrote:
> 
> > Antonio Ospite wrote:
> [...]
> > > 
> > > I see. It would be interesting to see how Powerline Frequency filtering
> > > is done on PS3. I added Jim Paris on CC.
> > 
> > Hi Antonio and Mosalam,
> > 
> > I tried, but I can't capture that.  My USB logger only does USB 1.1,
> > which is too slow for the camera to run normally, but good enough to
> > see the initialization sequence.  However, the 50/60Hz option only
> > appears later, once the PS3 is receiving good frame data.
> > 
> > I can open up the camera and sniff the I2C bus instead.  It'll take
> > a little longer.
> >
> 
> Thanks for your time Jim.

No problem, glad to help.
Looks like Mosalam's patch is correct:

--- i2c-60hz.log	2010-03-04 15:09:23.000000000 -0500
+++ i2c-50hz.log	2010-03-04 15:09:27.000000000 -0500
@@ -69,7 +69,7 @@
 ov_write_verify 8C E8
 ov_write_verify 8D 20
 ov_write_verify 0C 90
-ov_write_verify 2B 00
+ov_write_verify 2B 9E
 ov_write_verify 22 7F
 ov_write_verify 23 03
 ov_write_verify 11 01

I'll attach the full logs.

-jim

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="i2c-60hz.log"

ov_write 12 80
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 3D 03
ov_write_verify 17 26
ov_write_verify 18 A0
ov_write_verify 19 07
ov_write_verify 1A F0
ov_write_verify 32 00
ov_write_verify 29 A0
ov_write_verify 2C F0
ov_write_verify 65 20
ov_write_verify 11 01
ov_write_verify 42 7F
ov_write_verify 63 E0
ov_write_verify 64 FF
ov_write_verify 66 00
ov_write_verify 13 F0
ov_write_verify 0D 41
ov_write_verify 0F C5
ov_write_verify 14 11
ov_write_verify 22 7F
ov_write_verify 23 03
ov_write_verify 24 40
ov_write_verify 25 30
ov_write_verify 26 A1
ov_write_verify 2A 00
ov_write_verify 2B 00
ov_write_verify 6B AA
ov_write_verify 13 FF
ov_write_verify 90 05
ov_write_verify 91 01
ov_write_verify 92 03
ov_write_verify 93 00
ov_write_verify 94 60
ov_write_verify 95 3C
ov_write_verify 96 24
ov_write_verify 97 1E
ov_write_verify 98 62
ov_write_verify 99 80
ov_write_verify 9A 1E
ov_write_verify 9B 08
ov_write_verify 9C 20
ov_write_verify 9E 81
ov_write_verify A6 04
ov_write_verify 7E 0C
ov_write_verify 7F 16
ov_write_verify 80 2A
ov_write_verify 81 4E
ov_write_verify 82 61
ov_write_verify 83 6F
ov_write_verify 84 7B
ov_write_verify 85 86
ov_write_verify 86 8E
ov_write_verify 87 97
ov_write_verify 88 A4
ov_write_verify 89 AF
ov_write_verify 8A C5
ov_write_verify 8B D7
ov_write_verify 8C E8
ov_write_verify 8D 20
ov_write_verify 0C 90
ov_write_verify 2B 00
ov_write_verify 22 7F
ov_write_verify 23 03
ov_write_verify 11 01
ov_read 0C 90
ov_write_verify 0C 90
ov_read 64 FF
ov_write_verify 64 FF
ov_read 0D 41
ov_write_verify 0D 41
ov_read 14 11
ov_write_verify 14 41
ov_read 0E 79
ov_write_verify 0E CD
ov_read AC FF
ov_write_verify AC BF
ov_write_verify 8E 00
ov_read 0C 90
ov_write_verify 0C D0

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="i2c-50hz.log"

ov_write 12 80
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 11 01
ov_write_verify 3D 03
ov_write_verify 17 26
ov_write_verify 18 A0
ov_write_verify 19 07
ov_write_verify 1A F0
ov_write_verify 32 00
ov_write_verify 29 A0
ov_write_verify 2C F0
ov_write_verify 65 20
ov_write_verify 11 01
ov_write_verify 42 7F
ov_write_verify 63 E0
ov_write_verify 64 FF
ov_write_verify 66 00
ov_write_verify 13 F0
ov_write_verify 0D 41
ov_write_verify 0F C5
ov_write_verify 14 11
ov_write_verify 22 7F
ov_write_verify 23 03
ov_write_verify 24 40
ov_write_verify 25 30
ov_write_verify 26 A1
ov_write_verify 2A 00
ov_write_verify 2B 00
ov_write_verify 6B AA
ov_write_verify 13 FF
ov_write_verify 90 05
ov_write_verify 91 01
ov_write_verify 92 03
ov_write_verify 93 00
ov_write_verify 94 60
ov_write_verify 95 3C
ov_write_verify 96 24
ov_write_verify 97 1E
ov_write_verify 98 62
ov_write_verify 99 80
ov_write_verify 9A 1E
ov_write_verify 9B 08
ov_write_verify 9C 20
ov_write_verify 9E 81
ov_write_verify A6 04
ov_write_verify 7E 0C
ov_write_verify 7F 16
ov_write_verify 80 2A
ov_write_verify 81 4E
ov_write_verify 82 61
ov_write_verify 83 6F
ov_write_verify 84 7B
ov_write_verify 85 86
ov_write_verify 86 8E
ov_write_verify 87 97
ov_write_verify 88 A4
ov_write_verify 89 AF
ov_write_verify 8A C5
ov_write_verify 8B D7
ov_write_verify 8C E8
ov_write_verify 8D 20
ov_write_verify 0C 90
ov_write_verify 2B 9E
ov_write_verify 22 7F
ov_write_verify 23 03
ov_write_verify 11 01
ov_read 0C 90
ov_write_verify 0C 90
ov_read 64 FF
ov_write_verify 64 FF
ov_read 0D 41
ov_write_verify 0D 41
ov_read 14 11
ov_write_verify 14 41
ov_read 0E 79
ov_write_verify 0E CD
ov_read AC FF
ov_write_verify AC BF
ov_write_verify 8E 00
ov_read 0C 90
ov_write_verify 0C D0

--T4sUOijqQbZv57TR--
