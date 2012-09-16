Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45674 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2IPXgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 19:36:21 -0400
Message-ID: <50566260.1090108@iki.fi>
Date: Mon, 17 Sep 2012 02:36:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl> <504D00BC.4040109@schinagl.nl> <504D0F44.6030706@iki.fi> <504D17AA.8020807@schinagl.nl> <504D1859.5050201@iki.fi> <504DB9D4.6020502@schinagl.nl> <504DD311.7060408@iki.fi> <504DF950.8060006@schinagl.nl> <504E2345.5090800@schinagl.nl> <5055DD27.7080501@schinagl.nl> <505601B6.2010103@iki.fi> <5055EA30.8000200@schinagl.nl> <50560B82.7000205@iki.fi> <50564E58.20004@schinagl.nl>
In-Reply-To: <50564E58.20004@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/17/2012 01:10 AM, Oliver Schinagl wrote:
> On 09/16/12 19:25, Antti Palosaari wrote:
>> On 09/16/2012 06:03 PM, Oliver Schinagl wrote:
>>> I don't have windows, so capturing using windows is near impossible.
>>> Also since the vendor driver used to work, I guess I will have to dig
>>> into that more.
>>
>> You could capture data from Linux too (eg. Wireshark).
> Ah of course. I'll dig up the old vendor driver and see if I can get it
> running on 3.2 or better yet, on 3.5/your-3.6. I know there's patches
> for 3.2 but I've never tested those. Otherwise the older 2.6.2* series
> should still work.
>
>>
>> But with a little experience you could see those GPIOs reading existing
>> Linux driver and then do some tests to see what happens. For example
>> some GPIO powers tuner off, you will see I2C error. Changing it back
>> error disappears.
> I have zero experience so I'll try to figure things out. I guess you
> currently turn on/off GPIO's etc in the current driver? Any line which
> does this so I can examine how it's done? As for the I2C errors, I
> suppose the current driver will spew those out?

Those GPIOs are set in file af9035.c, functiuons: af9035_tuner_attach() 
and af9035_fc0011_tuner_callback(). For TDA18218 tuner there is no any 
GPIOs set, which could be wrong and it just works with good luck OR it 
is wired/connected directly so that GPIOs are not used at all.

> Speaking off, in my previous message, I wrote about the driver spitting
> out the following error:
> [dvb_usb_af9035]af9035_read_config =_ "%s: [%d]tuner=%02x\012"

It is the tuner ID value got from eeprom. You should take that number 
and add it to af9033.h file:
#define AF9033_TUNER_FC2580    0xXXXX <= insert number here

> None of the values where set however. Did I miss-configure anything for
> it to cause to 'forget' substituting?

What you mean? Could you enable debugs, plug stick in and copy paste 
what debugs says?

>
>>
>>> Since all the pieces should be there, fc2580 driver, af9033/5 driver,
>>> it's just a matter of glueing things together, right? I'll dig further
>>> into it and see what I can find/do.
>>
>> Correct. Tuner init (demod settings fc2580) for is needed for af9033.
>> And GPIOs for AF9035. In very bad luck some changes for fc2580 is needed
>> too, but it is not very, very, unlikely.
>>
>> This patch is very similar you will need to do (tda18218 tuner support
>> for af9035):
>> http://patchwork.linuxtv.org/patch/10547/
> I re-did my patch using that as a template (before I used your work on
> the rtl) and got the exact result.
>
> Your rtl|fc2580 combo btw (from bare memory) didn't have the fc2580_init
> stream in af9033_priv.h. What exactly gets init-ed there? The af9033 to
> work with the fc2580?

You have to add fc2580 init table to file af9033_priv.h. It configures 
all the settings needed for AF9033 demod in order to operate with FC2580 
tuner. There is some values like "tuner ID" which is passed for AF9033 
firmware, dunno what kind of tweaks it done. Maybe calculates some 
values like signal strengths and AGC values. It could work without, but 
at least performance is reduced.

regards
Antti



-- 
http://palosaari.fi/
