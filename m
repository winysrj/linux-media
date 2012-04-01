Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55104 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2DAMxr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 08:53:47 -0400
Message-ID: <4F784FD9.8080304@iki.fi>
Date: Sun, 01 Apr 2012 15:53:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi> <201204011227.18739.hfvogt@gmx.net>
In-Reply-To: <201204011227.18739.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ooops forget to comment these...

On 01.04.2012 13:27, Hans-Frieder Vogt wrote:
> Your new firmware loader implies that the firmware is available as a type
> "download firmware". It seems this is indeed the case for most (all?) of the
> AF9035 devices. If the IT9135 driver should be merged, the "copy firmware"
> functionality (i.e. scatter write =>  command code 0x29) would need to be
> implemented.

Technically correct way is to split out all functionality, I mean USB 
-interface, demodulator and tuner, as own driver modules and use same 
modules for all the hardware not caring integration level. Those are 
just logical entities put to inside same silicon or sold separately.

For the existing IT9135 driver, it is there and surely will not be 
removed unless it goes unmaintained. Still it is nice to offer modular 
implementation as a choice for upcoming devices.

I haven't looked so carefully IT9135 FW download process - only thing I 
noticed it uses totally much smaller firmware than af9035, which is 
somehow weird since it contains tuner which is main difference between 
af9035 and it9135 :) Maybe there is done some bug fixing or other 
improvements in silicon level too.

It is easy to implement 2 or more firmware downloader, one for each 
firmware type and select correct by driver.

>> I extracted three firmwares from windows binaries I have. I will sent
>> those you, Michael, for testing. First, and oldest, is TUA9001, 2nd is
>> from FC0012 device and 3rd no idea.
>>
>> md5sum f71efe295151ba76cac2280680b69f3f
>> LINK=11.5.9.0 OFDM=5.17.9.1

That was from TerraTec Cinergy T -Stick, the stick which was one of the 
first af9035 and I originally made driver for.

>> md5sum 7cdc1e3aba54f3a9ad052dc6a29603fd
>> LINK=11.10.10.0 OFDM=5.33.10.0

Some DealExtreme cheap stick.

>> md5sum 862604ab3fec0c94f4bf22b4cffd0d89
>> LINK=12.13.15.0 OFDM=6.20.15.0
>>
> I have got a firmware converted from the linux driver version 1.0.28 for the
> AVermedia AVerTV A867R (07ca:1867, tuner: MaxLinear Mxl5007t)
> LINK=10.10.3.0 OFDM=4.21.6.251
> (only 2 firmwares each for link and ofdm!)
>
> For the same device the Windows driver verion 8.0.0.60 has a load of firmwares
> with
> LINK=11.15.10.0 OFDM=5.48.10.0
> (3 firmwares each for link and ofdm)
>
>  From the Terratec T6 dual tuner device (fc0012) Windows driver version
> 10.09.20.01 I have got (is probably the one that you have got as well)
> LINK=12.13.15.0 OFDM=6.20.15.0
> (3 firmwares each for link and ofdm)

True.

> I got an e-mail from Terratec support that they don't see a problem with the
> distribution of the firmware that I sniffed from the Terratec T6 running under
> Windows.
>
> The Terratec Windows driver contains 3 firmwares that get selected depending on
> the available tuner:
> firmware 1 for tuners TUA8010, TUA9001, TD1316AFIHP, TDA18271, TDA18291HN,
> XC3028L, XC4000, FC2580, FC0011, PICTOR, 0x40 (?), 0x43 (?)
> firmware 2 for tuner MT2266
> firmware 3 for tuners FC0012 and 0x37
>  From this I conclude that there is not a single generic firmware that we could
> use for the af9035 devices, but maybe 3 are sufficient.

We should gather enough information to decide used firmware naming. 
Mainly for that reason I didn't release get_dvb_firmware changes I used 
to extract those.
So do you have the idea about firmware naming?
Reading tuner ID from eeprom before firmware download is needed as you 
point out. And then select firmware based of that. Or is it possible to 
split firmwares even smaller blocks like LINK and OFDM and download 
those separately. I think it is OFDM version which says if tuner is 
supported or not.


regards
Antti
-- 
http://palosaari.fi/
