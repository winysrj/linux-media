Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47378 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab0GZTFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 15:05:41 -0400
Received: by qyk7 with SMTP id 7so2152447qyk.19
        for <linux-media@vger.kernel.org>; Mon, 26 Jul 2010 12:05:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100726173428.GA14609@core.coreip.homeip.net>
References: <20100726141352.GA28182@redhat.com>
	<20100726173428.GA14609@core.coreip.homeip.net>
Date: Mon, 26 Jul 2010 15:05:36 -0400
Message-ID: <AANLkTinzoC9Eso=Hncc5=aaZuWnizhV4CWkcddQvFHsb@mail.gmail.com>
Subject: Re: [PATCH] IR/imon: remove incorrect calls to input_free_device
From: Jarod Wilson <jarod@wilsonet.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 26, 2010 at 1:34 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, Jul 26, 2010 at 10:13:52AM -0400, Jarod Wilson wrote:
>> Per Dmitry Torokhov (in a completely unrelated thread on linux-input),
>> following input_unregister_device with an input_free_device is
>> forbidden, the former is sufficient alone.
>>
>> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
> Acked-by: Dmitry Torokhov <dtor@mail.ru>
>
> Random notes about irmon:
>
> imon_init_idev():
>        memcpy(&ir->dev, ictx->dev, sizeof(struct device));
>
> This is... scary.  Devices are refcounted and if you copy them around
> all hell may break loose. On an unrelated note you do not need memcpy to
> copy a structire, *it->dev = *ictx->dev will do.
>
> imon_init_idev(), imon_init_touch(): - consizer returning proper error
> codes via ERR_PTR() and check wit IS_ERR().

Hm, I'm overdue to give that driver another look (bz.k.o #16351), will
add looking at these to the TODO list... (have immortalized them in
the bz).


-- 
Jarod Wilson
jarod@wilsonet.com
