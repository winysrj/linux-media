Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44422 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2DCHSw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2012 03:18:52 -0400
Received: by bkcik5 with SMTP id ik5so3273651bkc.19
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2012 00:18:51 -0700 (PDT)
Message-ID: <4F7AA458.1040201@gmail.com>
Date: Tue, 03 Apr 2012 09:18:48 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] tda18218: fix IF frequency for 7MHz bandwidth channels
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com> <1333401917-27203-4-git-send-email-gennarone@gmail.com> <4F7A2AC9.8040407@iki.fi> <4F7A47E5.8040604@gmail.com>
In-Reply-To: <4F7A47E5.8040604@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/2012 02:44 AM, Gianluca Gennari wrote:
> Il 03/04/2012 00:40, Antti Palosaari ha scritto:
>> On 03.04.2012 00:25, Gianluca Gennari wrote:
>>> This is necessary to tune VHF channels with the AVerMedia A835 stick.
>>>
>>> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
>>> ---
>>>   drivers/media/common/tuners/tda18218.c |    2 +-
>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/media/common/tuners/tda18218.c
>>> b/drivers/media/common/tuners/tda18218.c
>>> index dfb3a83..b079696 100644
>>> --- a/drivers/media/common/tuners/tda18218.c
>>> +++ b/drivers/media/common/tuners/tda18218.c
>>> @@ -144,7 +144,7 @@ static int tda18218_set_params(struct dvb_frontend
>>> *fe)
>>>           priv->if_frequency = 3000000;
>>>       } else if (bw<= 7000000) {
>>>           LP_Fc = 1;
>>> -        priv->if_frequency = 3500000;
>>> +        priv->if_frequency = 4000000;
>>>       } else {
>>>           LP_Fc = 2;
>>>           priv->if_frequency = 4000000;
>>
>> Kwaak, I will not apply that until I have done background checking. That
>> driver is used only by AF9015 currently. And I did that driver as
>> reverse-engineering and thus there is some things guessed. I have only 8
>> MHz wide signal, thus I never tested 7 and 6 MHz. Have no DVB-T
>> modulator either... Maybe some AF9015 user can confirm? Is there any
>> AF9015 & TDA18218 bug reports seen in discussion forums...
> 
> A friend has a AF9015+TDA18218 stick and told me that it works fine with
> the patch (including VHF), but to be safe I will ask him to double check
> with the current media_build tree, with and without the patch. In the
> worst case, we can add a new parameter (or an array of parameters) for
> the IF frequency to struct tda18218_config.

PASSED on 7MHz bw MUX - 'TerraTec Cinergy T Stick RC'.

rgds,
poma
