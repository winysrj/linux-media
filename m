Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46799 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2DAJ4x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 05:56:53 -0400
Received: by wibhq7 with SMTP id hq7so1811662wib.1
        for <linux-media@vger.kernel.org>; Sun, 01 Apr 2012 02:56:52 -0700 (PDT)
Message-ID: <4F782661.40001@gmail.com>
Date: Sun, 01 Apr 2012 11:56:49 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	linux-media@vger.kernel.org,
	=?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse> <4F762CF5.9010303@iki.fi> <20120331001458.33f12d82@milhouse> <20120331160445.71cd1e78@milhouse> <4F771496.8080305@iki.fi> <20120331182925.3b85d2bc@milhouse> <4F77320F.8050009@iki.fi> <4F773562.6010008@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi>
In-Reply-To: <4F77DED5.2040103@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 01/04/2012 06:51, Antti Palosaari ha scritto:

[snip]

> I need more AF903x hardware, please give links to cheap eBay devices
> etc. Also I would like to get one device where is AF9033 but no AF9035
> at all just for stand-alone demodulator implementation. I know there is
> few such devices, like AverMedia A336 for example...
> 
> regards
> Antti

Hi Antti,
here are a couple of links to buy cheap af9035 sticks.

Avermedia A835/B835: af9035 + tda18218, also known ad "Avermedia Volar
HD" or "Avermedia Volar HD Pro" or "Avermedia Volar Green HD".
The only difference between the models seems to be the presence of the
remote controller and the IR sensor. The link is for the cheaper one,
without the remote:

http://www.amazon.de/AverMedia-TV-USB-Stick-Volar/dp/B0039TFC7U/ref=sr_1_1?ie=UTF8&qid=1333272073&sr=8-1

Avermedia A867: af9035 + mxl5007t, also known as "Aver Media AVerTV 3D"
or "Sky Digital Key with blue led". You can buy them very cheap on Ebay
Italia because Sky Italia is giving away them almost for free to its
subscribers, to add DVB-T support to the Skyboxes. You can find dozens
of link like this:

http://www.ebay.it/itm/SKY-DIGITAL-KEY-ULTIMO-MODELLO-2012-LED-BLU-DIGITALE-TERRESTRE-USB-NUOVA-/110852763137?pt=Decoder_Satellitari_e_Digitali_Terrestri&hash=item19cf56ee01

The A867 and A835 are probably the most common DVB-T sticks here in
Italy, as they are very cheap and work pretty well. There is already
some support for them (based on your old driver and also on the driver
by Hans-Frieder Vogt) so I will look into porting it on the new driver.

Best regards,
Gianluca
