Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:44481 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965199AbdKQPJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 10:09:32 -0500
Received: by mail-qt0-f182.google.com with SMTP id h42so6732868qtk.11
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 07:09:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171117130104.1479fd43@vento.lan>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
 <fd92263a2c04a10d58ce465058391e6e8703dc90.1510913595.git.mchehab@s-opensource.com>
 <CAOFm3uFQGftabX93YEiLfpAoR+7kEvwuLudH+A7Bo4zKa60TOQ@mail.gmail.com> <20171117130104.1479fd43@vento.lan>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 17 Nov 2017 16:08:51 +0100
Message-ID: <CAOFm3uHnbdSab3w0VQ6+WPPNkXSF96725c8NaRi4O_vixkmCNw@mail.gmail.com>
Subject: Re: [PATCH 6/6] media: usb: add SPDX identifiers to some code I wrote
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Evgeniy Polyakov <zbr@ioremap.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 4:01 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Fri, 17 Nov 2017 12:54:15 +0100
> Philippe Ombredanne <pombredanne@nexb.com> escreveu:
>
>> On Fri, Nov 17, 2017 at 11:21 AM, Mauro Carvalho Chehab
>> <mchehab@s-opensource.com> wrote:
>> > As we're now using SPDX identifiers, on several
>> > media drivers I wrote, add the proper SPDX, identifying
>> > the license I meant.
>> >
>> > As we're now using the short license, it doesn't make sense to
>> > keep the original license text.
>> >
>> > Also, fix MODULE_LICENSE to properly identify GPL v2.
>> >
>> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>
>> Mauro,
>> Thanks ++ .... I can now get rid of a special license detection rule I
>> had added for the specific language of your notices in the
>> scancode-toolkit!
>
> :-)
>
> Yeah, I was too lazy to copy the usual GPL preamble on those
> drivers ;-)

I guess I built a lazyness checker with scancode to keep you check then ;)
But FWIW you are not alone there and at least your notices are/were
consistent across files ... there are still several hundred variations
of GPL notices in the kernel each with subtle or byzantine changes.

Some of them are rather funny like Evgeniy's thermal code being under
the "therms" of the GPL [1]

CC: Evgeniy Polyakov <zbr@ioremap.net>

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/w1/slaves/w1_therm.c?h=v4.14-rc8#n8
-- 
Cordially
Philippe Ombredanne
