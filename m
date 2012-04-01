Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53227 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2DAEvg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 00:51:36 -0400
Message-ID: <4F77DED5.2040103@iki.fi>
Date: Sun, 01 Apr 2012 07:51:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse> <4F762CF5.9010303@iki.fi> <20120331001458.33f12d82@milhouse> <20120331160445.71cd1e78@milhouse> <4F771496.8080305@iki.fi> <20120331182925.3b85d2bc@milhouse> <4F77320F.8050009@iki.fi> <4F773562.6010008@iki.fi> <20120331185217.2c82c4ad@milhouse>
In-Reply-To: <20120331185217.2c82c4ad@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31.03.2012 19:52, Michael Büsch wrote:
> On Sat, 31 Mar 2012 19:48:34 +0300
> Antti Palosaari<crope@iki.fi>  wrote:
>
>> And about the new FW downloader, that supports those new firmwares, feel
>> free to implement it if you wish too. I will now goto out of house and
>> will back during few hours. If you wish to do it just reply during 4
>> hours, and I will not start working for it. Instead I will continue with
>> IT9135.
>
> I have no clue about the firmware format, so it will probably be easier
> if you'd dive into that stuff as you already seem to know it.

Done. I didn't have neither info, but there was good posting from Daniel 
Glöckner that documents it! Nice job Daniel, without that info I was 
surely implemented it differently and surely more wrong way.

I pushed my experimental tree out, patches are welcome top of that.
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

I extracted three firmwares from windows binaries I have. I will sent 
those you, Michael, for testing. First, and oldest, is TUA9001, 2nd is 
from FC0012 device and 3rd no idea.

md5sum f71efe295151ba76cac2280680b69f3f
LINK=11.5.9.0 OFDM=5.17.9.1

md5sum 7cdc1e3aba54f3a9ad052dc6a29603fd
LINK=11.10.10.0 OFDM=5.33.10.0

md5sum 862604ab3fec0c94f4bf22b4cffd0d89
LINK=12.13.15.0 OFDM=6.20.15.0

I need more AF903x hardware, please give links to cheap eBay devices 
etc. Also I would like to get one device where is AF9033 but no AF9035 
at all just for stand-alone demodulator implementation. I know there is 
few such devices, like AverMedia A336 for example...

regards
Antti
-- 
http://palosaari.fi/
