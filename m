Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:52101 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZKDJUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 04:20:02 -0500
Received: by qyk4 with SMTP id 4so3302233qyk.33
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 01:20:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091104101429.23338a42.ospite@studenti.unina.it>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
	<f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
	<20091104101429.23338a42.ospite@studenti.unina.it>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 4 Nov 2009 17:19:47 +0800
Message-ID: <f17812d70911040119g6eb1f254pa78dd8519afef61d@mail.gmail.com>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX phones
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 4, 2009 at 5:14 PM, Antonio Ospite <ospite@studenti.unina.it> wrote:
> On Wed, 4 Nov 2009 14:38:40 +0800
> Eric Miao <eric.y.miao@gmail.com> wrote:
>
>> Hi Antonio,
>>
>> Patch looks generally OK except for the MFP/GPIO usage, check my
>> comments below, thanks.
>>
>
> Ok, will resend ASAP. Some questions inlined below after your comments.
>
>> > +/* camera */
>> > +static int a780_pxacamera_init(struct device *dev)
>> > +{
>> > +       int err;
>> > +
>> > +       /*
>> > +        * GPIO50_GPIO is CAM_EN: active low
>> > +        * GPIO19_GPIO is CAM_RST: active high
>> > +        */
>> > +       err = gpio_request(MFP_PIN_GPIO50, "nCAM_EN");
>>
>> Mmm... MFP != GPIO, so this probably should be written simply as:
>>
>> #define GPIO_nCAM_EN  (50)
>>
>
> If the use of parentheses here is recommended, should I send another
> patch to add them to current defines for GPIOs in ezx.c, for style
> consistency?

I don't actually care about that - with or without parentheses are both OK
to me, though Guennadi recommends removing them, so it would be
just OK to left them untouched.

>
>> or (which tends to be more accurate but not necessary)
>>
>> #define GPIO_nCAM_EN  mfp_to_gpio(MFP_PIN_GPIO50)
>>
>
> For me it is the same, just tell me if you really prefer this one.
>

OK, the first/simple one pls

>> > +
>> > +static int a780_pxacamera_power(struct device *dev, int on)
>> > +{
>> > +       gpio_set_value(MFP_PIN_GPIO50, on ? 0 : 1);
>>
>>       gpio_set_value(GPIO_nCAM_EN, on ? 0 : 1);
>>
>> > +
>> > +#if 0
>> > +       /*
>> > +        * This is reported to resolve the "vertical line in view finder"
>> > +        * issue (LIBff11930), in the original source code released by
>> > +        * Motorola, but we never experienced the problem, so we don't use
>> > +        * this for now.
>> > +        *
>> > +        * AP Kernel camera driver: set TC_MM_EN to low when camera is running
>> > +        * and TC_MM_EN to high when camera stops.
>> > +        *
>> > +        * BP Software: if TC_MM_EN is low, BP do not shut off 26M clock, but
>> > +        * BP can sleep itself.
>> > +        */
>> > +       gpio_set_value(MFP_PIN_GPIO99, on ? 0 : 1);
>> > +#endif
>>
>> This is a little bit confusing - can we remove this for this stage?
>>
>
> Ok, I am removing it for now. I might put this note in again in
> future, hopefully with a better description.
>

That would be good.
