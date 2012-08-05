Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43741 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2HESMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2012 14:12:10 -0400
Received: by obbuo13 with SMTP id uo13so4562082obb.19
        for <linux-media@vger.kernel.org>; Sun, 05 Aug 2012 11:12:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+C2MxQn1OR_2ONEKuGc7HfX+aZos0RUGdr9e-7vP5iNduMn6Q@mail.gmail.com>
References: <1344103941-23047-1-git-send-email-develkernel412222@gmail.com>
	<CALF0-+VHfxhjzc-yBQYrXL7-gscfqt2tZmxx+Tpe8qE+cPXzWA@mail.gmail.com>
	<CA+C2MxQn1OR_2ONEKuGc7HfX+aZos0RUGdr9e-7vP5iNduMn6Q@mail.gmail.com>
Date: Sun, 5 Aug 2012 15:12:09 -0300
Message-ID: <CALF0-+WuPQcyvyYz9hVGwP6prS6Y5A0Q64Va3BtCn=QKwxAWGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: media: cxd2099: use kzalloc to allocate ci
 pointer of type struct cxd in cxd2099_attach
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devendra,

On Sun, Aug 5, 2012 at 1:04 AM, Devendra Naga
<develkernel412222@gmail.com> wrote:
> Hello Ezequiel,
>
> On Sun, Aug 5, 2012 at 12:24 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> Hi Devendra,
>>
>> On Sat, Aug 4, 2012 at 3:12 PM, Devendra Naga
>> <develkernel412222@gmail.com> wrote:
>>>
>>>         mutex_init(&ci->lock);
>>>         memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
>>
>> While you're still looking at this driver, perhaps you can change the memcpy
>> with a plain struct assignment (if you feel like).
>> It's really pointless to use a memcpy here.
>>
>> Something like this:
>>
>> -       memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
>> +       ci->cfg = *cfg;
>>
> Correct, and also one more thing like this is
>
> -           memcpy(&ci->en, &en_templ, sizeof(en_templ));
> +          ci->en = en_templ;
>
> Is it ok if i change ci->cfg and ci->en?

Yes, I believe it is ok.

A few more remarks I would like to add.

1. When sending patches for staging/media, it's not necessary to put
staging list/maintainer
(Greg) on Cc. I guess, it doesn't hurt, though.
But it's media list / Mauro who will decide on the patches.

2. You could also change the order in "struct cxd".
Currently it's like this

struct cxd {
        struct dvb_ca_en50221 en;
        struct i2c_adapter *i2c;
        struct cxd2099_cfg cfg;

But it would be better to put it like this

struct cxd {
        struct i2c_adapter *i2c;
        struct cxd2099_cfg cfg;
        struct dvb_ca_en50221 en;

It's more logical, and ci->i2c and ci->cfg are used more frequently, so it makes
sense to put it near the top of the struct.
(You may think I'm being too paranoid: I am).

3. You don't have hw to test, uh?
In that case, don't forget to always add a "Tested by compilation only"
inside the commit message. That way the maintainer (Mauro) are free to
_not_ pick
the patch, if he feels it's not safe/clear enough.

Hope this helps and thanks for your work,
Ezequiel.
