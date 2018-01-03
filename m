Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46593 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeACXC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 18:02:59 -0500
MIME-Version: 1.0
In-Reply-To: <20180103082310.59d7e52f@vento.lan>
References: <20180102095154.3424890-1-arnd@arndb.de> <20180103082310.59d7e52f@vento.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 4 Jan 2018 00:02:58 +0100
Message-ID: <CAK8P3a0Vv7Pr4eyDgbFH8zYrdN0BqEgz76bQecGCpoq+NxOZQw@mail.gmail.com>
Subject: Re: [PATCH] media: don't drop front-end reference count for ->detach
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Max Kellermann <max.kellermann@gmail.com>,
        Wolfgang Rohdewald <wolfgang@rohdewald.de>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 3, 2018 at 11:23 AM, Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
> Em Tue,  2 Jan 2018 10:48:54 +0100
> Arnd Bergmann <arnd@arndb.de> escreveu:

>> @@ -2965,7 +2968,6 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
>>       dvb_frontend_invoke_release(fe, fe->ops.release_sec);
>>       dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
>>       dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
>> -     dvb_frontend_invoke_release(fe, fe->ops.detach);
>>       dvb_frontend_put(fe);
>
> Hmm... stb0899 is not the only driver using detach:
>
> drivers/media/dvb-frontends/stb0899_drv.c:      .detach                         = stb0899_detach,
> drivers/media/pci/saa7146/hexium_gemini.c:      .detach = hexium_detach,
> drivers/media/pci/saa7146/hexium_orion.c:       .detach = hexium_detach,
> drivers/media/pci/saa7146/mxb.c:        .detach         = mxb_detach,
> drivers/media/pci/ttpci/av7110.c:       .detach         = av7110_detach,
> drivers/media/pci/ttpci/budget-av.c:    .detach = budget_av_detach,
> drivers/media/pci/ttpci/budget-ci.c:    .detach = budget_ci_detach,
> drivers/media/pci/ttpci/budget-patch.c: .detach         = budget_patch_detach,
> drivers/media/pci/ttpci/budget.c:       .detach         = budget_detach,

I'm pretty sure I checked this before and found stb0899_detach to be the
only implementation of dvb_frontend_ops:detach.

The other eight you quoted are all setting the member in struct
saa7146_extension, not struct dvb_frontend_ops, so they are
not called using the same method.

> Unfortunately, I don't have any device that would be affected by
> this change, but it sounds risky to not call this code anymore:
>
>         #ifdef CONFIG_MEDIA_ATTACH
>                 dvb_detach(release);
>         #endif
>
> for .detach ops, as it has the potential of preventing unbind on
> those drivers.

The problem that Wolfgang reported originally was specifically that
this dvb_detach() call was one more than there should be,
leading to a negative reference count. As far as I can tell, this
is true for every user of the 'detach' callback.

>> diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
>> index 0af74383083d..ae793dac4964 100644
>> --- a/drivers/media/usb/dvb-usb/pctv452e.c
>> +++ b/drivers/media/usb/dvb-usb/pctv452e.c
>> @@ -913,14 +913,6 @@ static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
>>                                               &a->dev->i2c_adap);
>>       if (!a->fe_adap[0].fe)
>>               return -ENODEV;
>> -
>> -     /*
>> -      * dvb_frontend will call dvb_detach for both stb0899_detach
>> -      * and stb0899_release but we only do dvb_attach(stb0899_attach).
>> -      * Increment the module refcount instead.
>> -      */
>> -     symbol_get(stb0899_attach);
>
>
> IMHO, the safest fix would be, instead, to do:
>
>         #ifdef CONFIG_MEDIA_ATTACH
>                 symbol_get(stb0899_attach);
>         #endif
>
> Btw, we have some code similar to that on other drivers
> with either symbol_get() or symbol_put().

This would work if we do it for every user of a driver that
has a detach callback in dvb_frontend_ops, but I still think
my suggested patch is correct and less error-prone as a
workaround here.

> Yeah, I agree that this sucks. The right fix here is to use i2c high level
> interfaces, binding it via i2c bus, instead of using the symbol_get()
> based dvb_attach() macro.
>
> We're (very) slowing doing such changes along the media subsystem.

Good to know there is a proper solution already. I had some ideas
for how to change it, but the i2c bus method is clearly better than
whatever I had in mind there.

       Arnd
