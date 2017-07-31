Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.e-consultation.org ([185.53.129.30]:48117 "EHLO
        www.e-consultation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752316AbdGaQZl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 12:25:41 -0400
Subject: Re: HauppaugeTV-quadHD DVB-T mpeg risc op code errors
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <bc863191-8f32-d702-f7f0-06a942d29d43@e-consultation.org>
 <CALzAhNVpHQ_X4NtB2Zz4K=ii=i9+wUqvpVuaBv9EiftuX06oAw@mail.gmail.com>
From: Dave Newman <d.r.newman@e-consultation.org>
Message-ID: <40e944a0-8511-bd19-f706-25a8b112ade7@e-consultation.org>
Date: Mon, 31 Jul 2017 17:25:33 +0100
MIME-Version: 1.0
In-Reply-To: <CALzAhNVpHQ_X4NtB2Zz4K=ii=i9+wUqvpVuaBv9EiftuX06oAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/07/17 13:55, Steven Toth wrote:
> On Sun, Jul 30, 2017 at 8:55 AM, Dave Newman
> <d.r.newman@e-consultation.org> wrote:
>> I can confirm the problems with the cx23885 driver reported by Steven
>> Toth on 6 June 2017. He found that:
>>
>>> I tried the card in a different older Intel i7 board and it worked
>>> flawlessly. I then started to wonder if it was some new
>>> incompatibility introduced with Kaby Lake. I had tweaked the UEFI
>>> settings on the new Kaby Lake board to enable VT-d/VT-x since I wanted
>>> to run Linux as a host OS with Windows 10 running on top of qemu/KVM.
>>> Upon resetting the UEFI settings to their defaults (VT-d/VT-x
>>> disabled) the card worked without issue.
>>
>> Like him:
>>
>> - I have a recent Hauppauge WinTV-quadHD TV tuner PCIe card
>>
>> - I have a new fast multi-processor CPU. He found that there were no
>> problems on
>>
>> - Enabling debug output for the cx23885 driver *fixes* the issue
>> (options cx23885 debug=5), letting me run a scan of DVB channels.
>>
>> Unlike him:
>>
>> - my CPU is an 8 core Ryzen 1700 on a new Gigabyte AB350 motherboard.
>>
>> - turning off iommu does not fix the problem.
>>
>> I do not know the cx23885 code well enough to propose any patches, but I
>> am happy to do debugging and testing. One thing I noticed is that
>> i2cdetect output differs from that on
>> https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-quadHD_(DVB-T/T2/C).
>> E.g.
>>
>>        0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
>> 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
>> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
>> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
>> 50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
>> 60: -- -- -- -- UU -- UU -- -- -- -- -- -- -- -- --
>> 70: -- -- -- -- -- -- -- --
>>
>> Anything from 60 and above is listed as UU.
>>
>> The motherboard is known to have problems with chained IRQs, so the latest
>> Ubuntu kernels use independent IRQs to avoid an interrupt storm on IRQ 7.
>>
>> Apart from that, let me know what else I should test.
> 
> David, thanks for the report.
> 
> Just to be clear, I didn't report the original issue, I merely
> attempted to repro it on a Sandy Bridge quad core. I'm the original
> cx23885/8 Linux driver developer, so I know the hardware well and have
> a vested interested in chasing down any obvious problems.
> 
> I was unable to repro the issue.
> 
> That being said, another user reported success after disabling
> VT-d/VT-x. Have you tried that?
> 
> - Steve

Sorry, I quoted the wrong author from the thread. It was Adam Zegelin.

My AMD motherboard uses different terminology. I have disabled the SVM 
mode needed for virtualisation. I have also disabled IOMMU on the 
motherboard (adding amd_iommu=off to the kernel boot parameters makes no 
difference). I have left SMT mode at the auto default. That is described 
as "CPU Simultaneous Multi-Threading technology", whatever that is.

So I am currently running the card with debug=5.

Any suggestions as to how I can narrow down the problem?

David Newman
