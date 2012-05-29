Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63450 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2E2V0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 17:26:22 -0400
Received: by yenm10 with SMTP id m10so2509427yen.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 14:26:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCCy4f84F-G8pup5sesc+GNr13pWakKkfzYxxChnrpQx2Q@mail.gmail.com>
References: <1338154013-5124-3-git-send-email-martin.blumenstingl@googlemail.com>
 <1338325692-19684-1-git-send-email-martin.blumenstingl@googlemail.com>
 <CAOMZO5Bmc3cesaJ_y_NgSaAPYQpcwOUtn_6TX=khg7k=4da-Bg@mail.gmail.com> <CAFBinCCy4f84F-G8pup5sesc+GNr13pWakKkfzYxxChnrpQx2Q@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 29 May 2012 23:26:01 +0200
Message-ID: <CAFBinCBeO7Y+HPoWSnv643idxkUW-TU28sosPn_dcgVQHYXxjg@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: Show a warning if the board does not
 support remote controls
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Fabio,

I can use dev_err if you want.

And sorry for sending the patch twice.
I messed up the git send-email command here - sorry for that.

Regards,
Martin

> On Tue, May 29, 2012 at 11:22 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> On Tue, May 29, 2012 at 6:08 PM, Martin Blumenstingl
>> <martin.blumenstingl@googlemail.com> wrote:
>>> This simply shows a little warning if the board does not have remote
>>> control support. This should make it easier for users to see if they
>>> have misconfigured their system or if the driver simply does not have
>>> rc-support for their card (yet).
>>>
>>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>>> ---
>>>  drivers/media/video/em28xx/em28xx-input.c |    3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
>>> index fce5f76..d94b434 100644
>>> --- a/drivers/media/video/em28xx/em28xx-input.c
>>> +++ b/drivers/media/video/em28xx/em28xx-input.c
>>> @@ -527,6 +527,9 @@ static int em28xx_ir_init(struct em28xx *dev)
>>>
>>>        if (dev->board.ir_codes == NULL) {
>>>                /* No remote control support */
>>> +               printk("No remote control support for em28xx "
>>> +                       "card %s (model %d) available.\n",
>>> +                       dev->name, dev->model);
>>
>> What about using dev_err instead?
