Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:65231 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZI0Uhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2009 16:37:55 -0400
Received: by qyk4 with SMTP id 4so2963691qyk.33
        for <linux-media@vger.kernel.org>; Sun, 27 Sep 2009 13:37:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090927202448.GA27176@systol-ng.god.lan>
References: <20090922210500.GA8661@systol-ng.god.lan>
	 <37219a840909241146q72af5395hc028b91b6a97ada1@mail.gmail.com>
	 <20090924214233.GA13708@systol-ng.god.lan>
	 <37219a840909270925y5de5f10fn1a10e63d62953fe0@mail.gmail.com>
	 <37219a840909270935j74a25f3fn229839fb7c2cf50a@mail.gmail.com>
	 <20090927202448.GA27176@systol-ng.god.lan>
Date: Sun, 27 Sep 2009 16:37:58 -0400
Message-ID: <303a8ee30909271337r51502479o77cb2062372064e4@mail.gmail.com>
Subject: Re: [PATCH 1/4] tda18271_set_analog_params major bugfix
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 27, 2009 at 4:24 PM,  <spam@systol-ng.god.lan> wrote:
> On Sun, Sep 27, 2009 at 12:35:00PM -0400, Michael Krufky wrote:
>> On Sun, Sep 27, 2009 at 12:25 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
>>
>> On a second thought, I see that my above patch loses some precision
>> ...  this is even better:
>>
>> diff -r f52640ced9e8 linux/drivers/media/common/tuners/tda18271-fe.c
>> --- a/linux/drivers/media/common/tuners/tda18271-fe.c Tue Sep 15
>> 01:25:35 2009 -0400
>> +++ b/linux/drivers/media/common/tuners/tda18271-fe.c Sun Sep 27
>> 12:33:20 2009 -0400
>> @@ -1001,12 +1001,12 @@
>>       struct tda18271_std_map_item *map;
>>       char *mode;
>>       int ret;
>> -     u32 freq = params->frequency * 62500;
>> +     u32 freq = params->frequency * 125 *
>> +             ((params->mode == V4L2_TUNER_RADIO) ? 1 : 1000) / 2;
>>
>>       priv->mode = TDA18271_ANALOG;
>>
>>       if (params->mode == V4L2_TUNER_RADIO) {
>> -             freq = freq / 1000;
>>               map = &std_map->fm_radio;
>>               mode = "fm";
>>       } else if (params->std & V4L2_STD_MN) {
>>
>> Cheers,
>>
>> Mike
>
> Much better!
>
> Btw. It seems that the tuner is capable of tuning in 1000 Hz steps, is
> there a reason why we are using 62500 Hz steps?

That's the v4l2 analog tuner API.  It has nothing to do with the
tda18271 driver internals.  If you look on the digital set_params
function, you'll see that this doesnt happen there.

-Mike
