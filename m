Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab0I3T1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 15:27:36 -0400
Received: by bwz11 with SMTP id 11so1681318bwz.19
        for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 12:27:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CA4E1FF.8090700@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
	<20100928154655.183af4b3@pedra>
	<AANLkTindJwXKPpHgT=fN8NdNGstQHqGh+=FHu6xwYG3b@mail.gmail.com>
	<4CA4E1FF.8090700@redhat.com>
Date: Thu, 30 Sep 2010 15:27:35 -0400
Message-ID: <AANLkTikkL_wDGEEdivfrV1dWbiyUHNXC4NpHjnn3-vJv@mail.gmail.com>
Subject: Re: [PATCH 03/10] V4L/DVB: tda18271: Add some hint about what
 tda18217 reg ID returned
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 30, 2010 at 3:16 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 30-09-2010 15:57, Michael Krufky escreveu:
>> On Tue, Sep 28, 2010 at 2:46 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Instead of doing:
>>>
>>> [   82.581639] tda18271 4-0060: creating new instance
>>> [   82.588411] Unknown device detected @ 4-0060, device not supported.
>>> [   82.594695] tda18271_attach: [4-0060|M] error -22 on line 1272
>>> [   82.600530] tda18271 4-0060: destroying instance
>>>
>>> Print:
>>> [  468.740392] Unknown device (0) detected @ 4-0060, device not supported.
>>>
>>> for the error message, to help detecting what's going wrong with the
>>> device.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>
>>> diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
>>> index 7955e49..77e3642 100644
>>> --- a/drivers/media/common/tuners/tda18271-fe.c
>>> +++ b/drivers/media/common/tuners/tda18271-fe.c
>>> @@ -1177,7 +1177,7 @@ static int tda18271_get_id(struct dvb_frontend *fe)
>>>                break;
>>>        }
>>>
>>> -       tda_info("%s detected @ %d-%04x%s\n", name,
>>> +       tda_info("%s (%i) detected @ %d-%04x%s\n", name, regs[R_ID] & 0x7f,
>>>                 i2c_adapter_id(priv->i2c_props.adap),
>>>                 priv->i2c_props.addr,
>>>                 (0 == ret) ? "" : ", device not supported.");
>>
>> A patch like this is fine for testing, but I see no reason for merging
>> this into the kernel.  Can you provide an explaination as per why this
>> would be useful?  In general, if you see, "Unknown device detected @
>> X-00YY, device not supported." then it means that this is not a
>> tda182x1.
>
> cx231xx have 4 I2C buses. The device I'm working with have the tuner at the wrong chip.
> As it doesn't support 0 byte transactions, if you try to read from the wrong i2c, it will
> just return 0 to all read requests.
>
> So, this kind of message can be very useful if someone sends us a report about a new device.
> The changes are small and are printed only in the case of errors, where people will likely
> try to reach the developers. So, I think it is a good idea to have it mainstream.

Mauro,

I think that's a reasonable explanation.  Would you be open to
reworking the patch such that the register contents only show up if
the device is not recognized?  (when ret < 0) . In the case where the
device is correctly identified (ret == 0), I'd rather preserve the
original successful detection message, and not see the ID register
contents.

Thanks & regards,

Mike Krufky
