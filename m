Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33202 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2HEUbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2012 16:31:45 -0400
Received: by vbbff1 with SMTP id ff1so2055292vbb.19
        for <linux-media@vger.kernel.org>; Sun, 05 Aug 2012 13:31:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+WuPQcyvyYz9hVGwP6prS6Y5A0Q64Va3BtCn=QKwxAWGQ@mail.gmail.com>
References: <1344103941-23047-1-git-send-email-develkernel412222@gmail.com>
	<CALF0-+VHfxhjzc-yBQYrXL7-gscfqt2tZmxx+Tpe8qE+cPXzWA@mail.gmail.com>
	<CA+C2MxQn1OR_2ONEKuGc7HfX+aZos0RUGdr9e-7vP5iNduMn6Q@mail.gmail.com>
	<CALF0-+WuPQcyvyYz9hVGwP6prS6Y5A0Q64Va3BtCn=QKwxAWGQ@mail.gmail.com>
Date: Mon, 6 Aug 2012 02:16:44 +0545
Message-ID: <CA+C2MxRgPjTKBKAXtdN-H2L6YiVu+8y203ceLimnbq6iq1V97Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: media: cxd2099: use kzalloc to allocate ci
 pointer of type struct cxd in cxd2099_attach
From: Devendra Naga <develkernel412222@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ezequiel,

Thanks, you wrote a full description of what i need to do.. i will
definitely follow this.

On Sun, Aug 5, 2012 at 11:57 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hi Devendra,
>
> On Sun, Aug 5, 2012 at 1:04 AM, Devendra Naga
> <develkernel412222@gmail.com> wrote:
>> Hello Ezequiel,
>>
>> On Sun, Aug 5, 2012 at 12:24 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>> Hi Devendra,
>>>
>>> On Sat, Aug 4, 2012 at 3:12 PM, Devendra Naga
>>> <develkernel412222@gmail.com> wrote:
>>>>
>>>>         mutex_init(&ci->lock);
>>>>         memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
>>>
>>> While you're still looking at this driver, perhaps you can change the memcpy
>>> with a plain struct assignment (if you feel like).
>>> It's really pointless to use a memcpy here.
>>>
>>> Something like this:
>>>
>>> -       memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
>>> +       ci->cfg = *cfg;
>>>
>> Correct, and also one more thing like this is
>>
>> -           memcpy(&ci->en, &en_templ, sizeof(en_templ));
>> +          ci->en = en_templ;
>>
>> Is it ok if i change ci->cfg and ci->en?
>
> Yes, I believe it is ok.
>
> A few more remarks I would like to add.
>
> 1. When sending patches for staging/media, it's not necessary to put
> staging list/maintainer
> (Greg) on Cc. I guess, it doesn't hurt, though.
> But it's media list / Mauro who will decide on the patches.
>
Yeah, for some patches i have done ccing to Greg, but i think you told me not to
cc  at that time itself so not cc'ed now.

> 2. You could also change the order in "struct cxd".
> Currently it's like this
>
> struct cxd {
>         struct dvb_ca_en50221 en;
>         struct i2c_adapter *i2c;
>         struct cxd2099_cfg cfg;
>
> But it would be better to put it like this
>
> struct cxd {
>         struct i2c_adapter *i2c;
>         struct cxd2099_cfg cfg;
>         struct dvb_ca_en50221 en;
>
> It's more logical, and ci->i2c and ci->cfg are used more frequently, so it makes
> sense to put it near the top of the struct.
> (You may think I'm being too paranoid: I am).
>
I am afraid i may not be doing those, if re-ordering may cause some
ambiguous problems. sorry...

> 3. You don't have hw to test, uh?
> In that case, don't forget to always add a "Tested by compilation only"
> inside the commit message. That way the maintainer (Mauro) are free to
> _not_ pick
> the patch, if he feels it's not safe/clear enough.
>
Ok . i will definitely put that message in commit. Thanks

> Hope this helps and thanks for your work,
> Ezequiel.

Since the changes are different than what this patch does, i will do
the changes you proposed in a new patch and will send it out.

Thanks for your time,
