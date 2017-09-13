Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:5840 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdIMPfH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 11:35:07 -0400
Subject: Re: IR driver support for tango platforms
To: Sean Young <sean@mess.org>
Cc: Mans Rullgard <mans@mansr.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
References: <6076a18d-c5ba-cb83-ac36-8eda965c7eb8@free.fr>
 <20170911211210.a7a2st4hfn7leec3@gofer.mess.org>
 <7942dc9f-e7a2-e088-e843-f013ac1b0302@free.fr>
 <20170912181957.zhd4fwwannpxblqx@gofer.mess.org>
 <c5aa1452-44e9-49a9-828a-5b32395609f4@free.fr>
 <20170913145735.y7uhfa4li5clnm75@gofer.mess.org>
From: Mason <slash.tmp@free.fr>
Message-ID: <84616dcf-0897-15e3-0a00-695711fbee09@free.fr>
Date: Wed, 13 Sep 2017 17:34:22 +0200
MIME-Version: 1.0
In-Reply-To: <20170913145735.y7uhfa4li5clnm75@gofer.mess.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/09/2017 16:57, Sean Young wrote:

> On Sep 13, 2017 at 16:03, Mason wrote:
>
>> Changes from v1 to v2:
>>
>> o Rebase driver on top of linuxtv/master
>> o Use ir_nec_bytes_to_scancode() in tango_ir_handle_nec()
>> o Use devm_rc_allocate_device() in tango_ir_probe()
>> o Use Use devm_rc_register_device() in tango_ir_probe()
>> o Rename rc->input_name to rc->device_name (not sure what value to use here)
>> o List all NEC variants for rc->allowed_protocols
>> o Change type of clkrate to u64
>> o Fix tango_ir_probe and tango_ir_remove for devm
>> o Move around some init calls in tango_ir_probe() for devm
>> o Use relaxed variants of MMIO accessors
>>
>> TODO: test RC-5 and RC-6 (I need to locate proper remote)
> 
> You could get a IR transmitter (e.g. raspberry pi + IR led + resistor) or
> some of the mceusb devices, and then you can use the ir-ctl tool to
> test all the different protocols, including extended rc5 and the other
> rc6 variants.

Thanks for the suggestions.

I do have a box full of remote controls, and I'm hoping some of
them are RC-5 and RC-6. (Someone told me there is a Sony decoder
in the chip, but I have found no documentation whatsoever regarding
that feature!)

There is an IR transmitter on the board, but I have no driver for
it, only a custom test app. So that doesn't help me for ir-ctl...
I don't know how much time a driver would require.

> But I don't think we need to block merging because these protocols haven't
> been tested. It would be nice though.

I'll try my best to test the driver thoroughly. And then I'll
send a formal patch.

Regards.
