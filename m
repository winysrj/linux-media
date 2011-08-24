Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38968 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1HXU1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 16:27:39 -0400
Received: by fxh19 with SMTP id 19so1256686fxh.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 13:27:38 -0700 (PDT)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: jasondong <jason.dong@ite.com.tw>
Subject: Re: [PATCH 1/1] Add driver support for ITE IT9135 device
Date: Wed, 24 Aug 2011 22:27:34 +0200
Cc: linux-media@vger.kernel.org
References: <1312539895.2763.33.camel@Jason-Linux> <201108242008.57903.a.miskiewicz@gmail.com>
In-Reply-To: <201108242008.57903.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108242227.34816.a.miskiewicz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 24 of August 2011, Arkadiusz Miskiewicz wrote:
> On Friday 05 of August 2011, jasondong wrote:
> > This is DVB USB Linux driver for ITEtech IT9135 base USB TV module.
> > It supported the IT9135 AX and BX chip versions.
> 
> Hi,
> 
> The quick review by crop@freenode was:
> 
> "I quick check it and didnt like much since it is not plitted logically
> correct, as usb-bridge, demod and tuner. now all are rather much one big
> blob".
> 
> so I guess you have to split it into pieces in a way other dvb drivers
> already in kernel tree are done. Unfortunately I don't know which existing
> driver is the best example on how to do things.

More comments from irc:
"22:09 < crope> arekm: any current DVB USB driver. there is very many of 
integrated (2-in-1, or 3-in-1) drivers which are splitted correctly
22:10 < crope> ec168, af9015, some dibcom models?, ce6320, rtl2831u
22:11 < crope> you *must* implement all logical parts as own drivers no matter 
of those are integrated to one silicon or not. it is generally seen those
               parts used are sold as not integrated too
22:12 < crope> for example that IT9135, I really think it uses af9033 demod, 
which is sold as own part and also integrated to af9015. and very likely 
IT9135
               contains same USB-brdge than AF9035. only difference is 
integrated tuner
22:13 < crope> so IT9135 == AF9035+ ITXXXX tuner in one package. when you 
split driver correctly to logical parts you can use same drivers
22:14 < crope> and AF9035 == AF903XX USB-bridge + AF9033 demod
22:17 < crope> all DVB USB drivers we have consist of 2 parts (drivers). 1) 
USB-interface driver (aka DVB USB) 2) demodulator driver 3) tuner driver
22:17 < crope> all DVB USB drivers we have consist of 3 parts (drivers). 1) 
USB-interface driver (aka DVB USB) 2) demodulator driver 3) tuner driver
"

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
