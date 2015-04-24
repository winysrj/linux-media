Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36776 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491AbbDXHDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 03:03:10 -0400
Received: by iebrs15 with SMTP id rs15so77666823ieb.3
        for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 00:03:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGzPZaJoMtHXYuFo081xbG3Eb_1+WwePziKfp6R5kREGDw@mail.gmail.com>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
	<1429823471-21835-2-git-send-email-olli.salonen@iki.fi>
	<5539E96C.1000407@gmail.com>
	<CAAZRmGzPZaJoMtHXYuFo081xbG3Eb_1+WwePziKfp6R5kREGDw@mail.gmail.com>
Date: Fri, 24 Apr 2015 09:03:09 +0200
Message-ID: <CAAZRmGwUd1gj2FmkX1ODeb+-q2oZXuZc6urgoR6i8W2VsLgGPA@mail.gmail.com>
Subject: Re: [PATCH 02/12] dvbsky: use si2168 config option ts_clock_gapped
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tycho,

Yes, so far the only device that I know should use gapped clock is the
DVBSky T330 a.k.a. TechnoTrend CT2-4400.

I've also seen that the Hauppauge HVR-2205 Windows driver enables this
option, but it seems to me that that board works ok also without this.

Cheers,
-olli

On 24 April 2015 at 09:01, Olli Salonen <olli.salonen@iki.fi> wrote:
> Hi Tycho,
>
> Yes, so far the only device that I know should use gapped clock is the
> DVBSky T330 a.k.a. TechnoTrend CT2-4400.
>
> I've also seen that the Hauppauge HVR-2205 Windows driver enables this
> option, but it seems to me that that board works ok also without this.
>
> Cheers,
> -olli
>
> On 24 April 2015 at 08:57, Tycho Lürsen <tycholursen@gmail.com> wrote:
>>
>> One more question:
>>
>> cx23885-dvb.c (and maybe others) contains a couple of instances of
>>
>> si2168_config.ts_mode = SI2168_TS_PARALLEL;
>> and
>> si2168_config.ts_mode = SI2168_TS_SERIAL;
>>
>> But you don't patch them with
>>
>> si2168_config.ts_clock_gapped = true;
>>
>> Is this intentional?
>>
>> Kind regards,
>> Tycho
>>
>> Op 23-04-15 om 23:11 schreef Olli Salonen:
>>>
>>> Change the dvbsky driver to support gapped clock instead of the current
>>> hack.
>>>
>>> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>>> ---
>>>   drivers/media/usb/dvb-usb-v2/dvbsky.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c
>>> b/drivers/media/usb/dvb-usb-v2/dvbsky.c
>>> index cdf59bc..0f73b1d 100644
>>> --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
>>> +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
>>> @@ -615,7 +615,8 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter
>>> *adap)
>>>         memset(&si2168_config, 0, sizeof(si2168_config));
>>>         si2168_config.i2c_adapter = &i2c_adapter;
>>>         si2168_config.fe = &adap->fe[0];
>>> -       si2168_config.ts_mode = SI2168_TS_PARALLEL | 0x40;
>>> +       si2168_config.ts_mode = SI2168_TS_PARALLEL;
>>> +       si2168_config.ts_clock_gapped = true;
>>>         memset(&info, 0, sizeof(struct i2c_board_info));
>>>         strlcpy(info.type, "si2168", I2C_NAME_SIZE);
>>>         info.addr = 0x64;
>>
>>
>
