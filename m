Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:53559 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbdJWNMU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 09:12:20 -0400
Received: by mail-qk0-f176.google.com with SMTP id y23so21819574qkb.10
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 06:12:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171023093724.4cgcwbjpeygfb4so@gofer.mess.org>
References: <5f441db1-93eb-2a9f-25ce-022cdcfadfc1@kaa.org.ua> <20171023093724.4cgcwbjpeygfb4so@gofer.mess.org>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Mon, 23 Oct 2017 09:12:18 -0400
Message-ID: <CAGoCfix8JxMTuz2ynV=NsHG9jtSqLDr0Wwcchw4Dbd0k5z0p+Q@mail.gmail.com>
Subject: Re: cx231xx IR remote control protocol
To: Sean Young <sean@mess.org>
Cc: Oleh Kravchenko <oleg@kaa.org.ua>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oleh,

On Mon, Oct 23, 2017 at 5:37 AM, Sean Young <sean@mess.org> wrote:
> Hi Oleh,
>
> On Sun, Oct 22, 2017 at 05:01:05PM +0300, Oleh Kravchenko wrote:
>> Hi,
>>
>> I'm trying add support remote control for tuners:
>> - EvroMedia Full Hybrid Full HD
>> - Astrometa T2hybrid
>>
>> But I'm stuck. Can anybody recognize this protocol?
>

Is there anything to indicate that there actually a separate IR
receiver on the board?  Most cx231xx devices have an MCEUSB compliant
IR RX/TX built into the chip, and thus they don't use a separate part.

Also, IIRC, address 0x30 is the I2C address of the onboard analog
frontend for the cx23102, and I suspect you're just reading the values
out of the AFE.  I suspect you've grabbed a dump from the initial
device plug-in, which would coincide with the initial register
programming of the AFE.

I suspect if you connect the device, let it device settle, *then*
start the I2C capture and hit a key on the remote, you'll see traffic
on a totally different endpoint which would be the IR traffic being
sent back over the IR interface/endpoint.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
