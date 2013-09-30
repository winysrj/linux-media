Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.seznam.cz ([77.75.76.43]:57892 "EHLO smtp2.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab3I3Q4N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 12:56:13 -0400
Message-ID: <5249A9EC.7020804@seznam.cz>
Date: Mon, 30 Sep 2013 18:42:20 +0200
From: =?UTF-8?B?SmnFmcOtIFBpbmthdmE=?= <j-pi@seznam.cz>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Gianluca Gennari <gennarone@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] r820t: fix nint range check
References: <524804B3.9090505@seznam.cz>	<524804DB.7020108@seznam.cz> <CAOcJUbyVx=fqHwVeM9K3SKUTk3g7vNqsWf0xokX5nO_DdQenYA@mail.gmail.com>
In-Reply-To: <CAOcJUbyVx=fqHwVeM9K3SKUTk3g7vNqsWf0xokX5nO_DdQenYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mike,

unfortunately no documentation can be referenced except preliminary
version of
datasheet (1).This change is based on lucky guess and supported by lot of
testing on real hardware.

This change add support for devices with Xtal frequency bellow 28.8MHz.

>From Nint  are computed values of Ni and Si. For 28.8MHz crystal can
reach up to 12 / 3 (Ni / Si). Tuner supports crystals with frequencies
(1) 12, 16, 20, 20.48, 24, 27, 28.8, 32 MHz, but this kind of device is
rare to found.
Allowing Ni to go up to 15 instead of only 12 should be safe and for 15
/ 3 (Ni / Si)
we can compute limit for Nint = max(Ni) * 4 + max(Si) + 13 = 76.

If This is sufficient and acceptable explanation I can add some sort of
documentation into patch and resend it (both patches, I can prove I'm
right :)

(1)
http://rtl-sdr.com/wp-content/uploads/2013/04/R820T_datasheet-Non_R-20111130_unlocked.pdf

> Jiří,
>
> Do you have any documentation that supports this value change?
> Changing this value affects the algorithm, and we'd be happier making
> this change if the patch included some better description and perhaps
> a reference explaining why the new value is correct.
>
> Regards,
>
> Mike Krufky
>
> On Sun, Sep 29, 2013 at 6:45 AM, Jiří Pinkava <j-pi@seznam.cz> wrote:
>>
>> Use full range of VCO parameters, fixes tunning for some frequencies.
>> ---
>>  drivers/media/tuners/r820t.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
>> index 1c23666..e25c720 100644
>> --- a/drivers/media/tuners/r820t.c
>> +++ b/drivers/media/tuners/r820t.c
>> @@ -637,7 +637,7 @@ static int r820t_set_pll(struct r820t_priv *priv,
>> enum v4l2_tuner_type type,
>>                 vco_fra = pll_ref * 129 / 128;
>>         }
>>
>> -       if (nint > 63) {
>> +       if (nint > 76) {
>>                 tuner_info("No valid PLL values for %u kHz!\n", freq);
>>                 return -EINVAL;
>>         }
>> --
>> 1.8.3.2
>>
>>

