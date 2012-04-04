Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59424 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab2DDNPU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2012 09:15:20 -0400
Received: by eaaq12 with SMTP id q12so87186eaa.19
        for <linux-media@vger.kernel.org>; Wed, 04 Apr 2012 06:15:19 -0700 (PDT)
Message-ID: <4F7C4963.2060100@gmail.com>
Date: Wed, 04 Apr 2012 15:15:15 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH 3/5] tda18218: fix IF frequency for 7MHz bandwidth channels
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com> <1333401917-27203-4-git-send-email-gennarone@gmail.com> <4F7A2AC9.8040407@iki.fi> <4F7A47E5.8040604@gmail.com> <4F7ACEB6.9020108@iki.fi>
In-Reply-To: <4F7ACEB6.9020108@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 03/04/2012 12:19, Antti Palosaari ha scritto:
> On 03.04.2012 03:44, Gianluca Gennari wrote:
>> Il 03/04/2012 00:40, Antti Palosaari ha scritto:
>>> On 03.04.2012 00:25, Gianluca Gennari wrote:
>>>> This is necessary to tune VHF channels with the AVerMedia A835 stick.
>>>>
>>>> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
>>>> ---
>>>>    drivers/media/common/tuners/tda18218.c |    2 +-
>>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/media/common/tuners/tda18218.c
>>>> b/drivers/media/common/tuners/tda18218.c
>>>> index dfb3a83..b079696 100644
>>>> --- a/drivers/media/common/tuners/tda18218.c
>>>> +++ b/drivers/media/common/tuners/tda18218.c
>>>> @@ -144,7 +144,7 @@ static int tda18218_set_params(struct dvb_frontend
>>>> *fe)
>>>>            priv->if_frequency = 3000000;
>>>>        } else if (bw<= 7000000) {
>>>>            LP_Fc = 1;
>>>> -        priv->if_frequency = 3500000;
>>>> +        priv->if_frequency = 4000000;
>>>>        } else {
>>>>            LP_Fc = 2;
>>>>            priv->if_frequency = 4000000;
>>>
>>> Kwaak, I will not apply that until I have done background checking. That
>>> driver is used only by AF9015 currently. And I did that driver as
>>> reverse-engineering and thus there is some things guessed. I have only 8
>>> MHz wide signal, thus I never tested 7 and 6 MHz. Have no DVB-T
>>> modulator either... Maybe some AF9015 user can confirm? Is there any
>>> AF9015&  TDA18218 bug reports seen in discussion forums...
>>
>> A friend has a AF9015+TDA18218 stick and told me that it works fine with
>> the patch (including VHF), but to be safe I will ask him to double check
>> with the current media_build tree, with and without the patch. In the
>> worst case, we can add a new parameter (or an array of parameters) for
>> the IF frequency to struct tda18218_config.
> 
> Public short datasheet [1], page 16, says default IFs are BW=8 MHz IF=4
> MHz, BW=7 MHz IF=3.5 MHz, BW=6 MHz IF=3 MHz. I suspect it still locks in
> some cases even IF is off-by 0.5 MHz for BW 7 and 8 but performance is
> reduced. So there is now something wrong, likely bug in the tda18218
> driver.
> 
> Could someone send me Windows sniff from success tune to 7 MHz BW channel?
> 
> [1] http://www.nxp.com/documents/data_sheet/TDA18218HN.pdf

Hi Antti,
I did some testing with the A835 and the findings are interesting. With
the old tda18218 driver the af9015 sticks required IF=3.5MHz to tune VHF
channels, while the A835 required IF=4MHz.

With the current driver, both the af9015 and the A835 are much more
tolerant to IF frequency variations.
In particular, the A835 is capable to successfully tune UHF channels
with IF in the range [3.5,5.5] MHz, and VHF channels with IF in the
range [3.0,6.5] MHz, inclusive.

I don't know if this may be considered the symptom of a bug, but for
sure the patch I posted is useless with the current driver.
If you are still interested in a USB sniff of the Windows driver, just
let me know.

Best regards,
Gianluca
