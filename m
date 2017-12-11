Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:43266 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbdLKQ1K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:27:10 -0500
MIME-Version: 1.0
In-Reply-To: <1513008559.2747.0.camel@wdc.com>
References: <20171211113048.3514863-1-arnd@arndb.de> <1513008559.2747.0.camel@wdc.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 11 Dec 2017 17:27:08 +0100
Message-ID: <CAK8P3a0Dtit+=a+PaY_6KuKmopxYEP9dLMY5RMtOTuKa6GfY_A@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: gadget: restore tristate-choice for legacy gadgets
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "romain.izard.pro@gmail.com" <romain.izard.pro@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ruslan.bilovol@gmail.com" <ruslan.bilovol@gmail.com>,
        "hare@suse.com" <hare@suse.com>,
        "cascardo@cascardo.eti.br" <cascardo@cascardo.eti.br>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 11, 2017 at 5:09 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Mon, 2017-12-11 at 12:30 +0100, Arnd Bergmann wrote:
>> One patch that was meant as a cleanup apparently did more than it intended,
>> allowing all combinations of legacy gadget drivers to be built into the
>> kernel, and leaving an empty 'choice' statement behind:
>>
>> drivers/usb/gadget/Kconfig:487:warning: choice default symbol 'USB_ETH' is not contained in the choice
>>
>> The description of commit 7a9618a22aad ("usb: gadget: allow to enable legacy
>> drivers without USB_ETH") was a bit cryptic, as it did not change the
>> behavior of USB_ETH other than allowing it to be built into the kernel
>> alongside other legacy gadgets, which is not a valid configuration.
>>
>> As Felipe explained in the description for commit bc49d1d17dcf ("usb:
>> gadget: don't couple configfs to legacy gadgets"), the configfs based
>> gadgets can be freely configured as loadable modules or built-in
>> drivers, but the legacy gadgets can only be modules if there is more
>> than one of them, so we require the 'choice' statement here.
>>
>> This leaves the added USB_GADGET_LEGACY menuconfig symbol in place,
>> but then restores the 'choice' below it, so we can enforce the
>> single-legacy-gadget rule as before.
>
> Hello Arnd,
>
> A discussion is ongoing about whether or not commit 7a9618a22aad should be reverted.
> Please drop this patch until a conclusion has been reached.

Ok. I'll use a revert of 7a9618a22aad in my local test tree then.
Reverting that is probably good, I thought about suggesting that
instead, but couldn't tell whether you had a bigger plan behind that
commit.

      Arnd
