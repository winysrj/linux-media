Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40935 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751070Ab2DAK1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 06:27:31 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T Stick [0ccd:0093]
Date: Sun, 1 Apr 2012 12:27:18 +0200
Cc: linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi>
In-Reply-To: <4F77DED5.2040103@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204011227.18739.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

nice work! I'll try to port the features that I have in my implementation of 
an af9035 driver into yours.

Am Sonntag, 1. April 2012 schrieb Antti Palosaari:
> On 31.03.2012 19:52, Michael Büsch wrote:
> > On Sat, 31 Mar 2012 19:48:34 +0300
> > 
> > Antti Palosaari<crope@iki.fi>  wrote:
> >> And about the new FW downloader, that supports those new firmwares, feel
> >> free to implement it if you wish too. I will now goto out of house and
> >> will back during few hours. If you wish to do it just reply during 4
> >> hours, and I will not start working for it. Instead I will continue with
> >> IT9135.
> > 
> > I have no clue about the firmware format, so it will probably be easier
> > if you'd dive into that stuff as you already seem to know it.
> 
> Done. I didn't have neither info, but there was good posting from Daniel
> Glöckner that documents it! Nice job Daniel, without that info I was
> surely implemented it differently and surely more wrong way.
> 
> I pushed my experimental tree out, patches are welcome top of that.
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_exp
> erimental
> 
Your new firmware loader implies that the firmware is available as a type 
"download firmware". It seems this is indeed the case for most (all?) of the 
AF9035 devices. If the IT9135 driver should be merged, the "copy firmware" 
functionality (i.e. scatter write => command code 0x29) would need to be 
implemented.

> I extracted three firmwares from windows binaries I have. I will sent
> those you, Michael, for testing. First, and oldest, is TUA9001, 2nd is
> from FC0012 device and 3rd no idea.
> 
> md5sum f71efe295151ba76cac2280680b69f3f
> LINK=11.5.9.0 OFDM=5.17.9.1
> 
> md5sum 7cdc1e3aba54f3a9ad052dc6a29603fd
> LINK=11.10.10.0 OFDM=5.33.10.0
> 
> md5sum 862604ab3fec0c94f4bf22b4cffd0d89
> LINK=12.13.15.0 OFDM=6.20.15.0
>
I have got a firmware converted from the linux driver version 1.0.28 for the 
AVermedia AVerTV A867R (07ca:1867, tuner: MaxLinear Mxl5007t)
LINK=10.10.3.0 OFDM=4.21.6.251
(only 2 firmwares each for link and ofdm!)

For the same device the Windows driver verion 8.0.0.60 has a load of firmwares 
with
LINK=11.15.10.0 OFDM=5.48.10.0
(3 firmwares each for link and ofdm)

>From the Terratec T6 dual tuner device (fc0012) Windows driver version 
10.09.20.01 I have got (is probably the one that you have got as well)
LINK=12.13.15.0 OFDM=6.20.15.0
(3 firmwares each for link and ofdm)

I got an e-mail from Terratec support that they don't see a problem with the 
distribution of the firmware that I sniffed from the Terratec T6 running under 
Windows.

The Terratec Windows driver contains 3 firmwares that get selected depending on 
the available tuner:
firmware 1 for tuners TUA8010, TUA9001, TD1316AFIHP, TDA18271, TDA18291HN, 
XC3028L, XC4000, FC2580, FC0011, PICTOR, 0x40 (?), 0x43 (?)
firmware 2 for tuner MT2266
firmware 3 for tuners FC0012 and 0x37
>From this I conclude that there is not a single generic firmware that we could 
use for the af9035 devices, but maybe 3 are sufficient.

> I need more AF903x hardware, please give links to cheap eBay devices
> etc. Also I would like to get one device where is AF9033 but no AF9035
> at all just for stand-alone demodulator implementation. I know there is
> few such devices, like AverMedia A336 for example...
> 
> regards
> Antti

regards,
Hans-Frieder

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
