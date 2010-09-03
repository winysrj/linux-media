Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55654 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab0ICKzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 06:55:37 -0400
Received: by qyk36 with SMTP id 36so3124136qyk.19
        for <linux-media@vger.kernel.org>; Fri, 03 Sep 2010 03:55:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimc2TTQQogO8Q6ih6Bv3j_oOcVMux3cg-CJPGsw@mail.gmail.com>
References: <AANLkTi=SY9xWCjp_0q6US7XN6XYoTWnGHA2=6EfjuWK-@mail.gmail.com>
	<AANLkTikg79zui71Xz8r-Lg3zut0jkSk-BGEpBpXfWz5Y@mail.gmail.com>
	<AANLkTimc2TTQQogO8Q6ih6Bv3j_oOcVMux3cg-CJPGsw@mail.gmail.com>
Date: Fri, 3 Sep 2010 10:55:36 +0000
Message-ID: <AANLkTim_mU7ayxjeE2HQz57UsPqHU46dPC3Ys600RJAD@mail.gmail.com>
Subject: Re: Gigabyte 8300
From: Dagur Ammendrup <dagurp@gmail.com>
To: Joel Wiramu Pauling <joel@aenertia.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

I tried it on a windows machine where it's identified as "Conextant
Polaris Video Capture"  or
"oem17.inf:Conexant.NTx86:POLARIS.DVBTX.x86:6.113.1125.1210:usb\vid_1b80&pid_d416&mi_01"
if that tells you anything.




2010/9/3 Dagur Ammendrup <dagurp@gmail.com>:
> I thought "Conexant CX23102" was the chip. How can I find this out? I
> have access to a windows machine if that helps.
>
>
>
>
> 2010/9/3 Joel Wiramu Pauling <joel@aenertia.net>:
>> What sort of afatech chip?
>>
>> af9035 are not supported at all. Only af9015's which are in the older devices.
>>
>> On 3 September 2010 12:55, Dagur Ammendrup <dagurp@gmail.com> wrote:
>>> Hi,
>>>
>>> I bought a Gigabyte U8300 today which is a hybrid USB tuner. These are
>>> the specifications according to the manufacturer:
>>>
>>> Analog: TVPAL / SECAM / NTSC
>>> Decoder chip: Conexant CX23102
>>> Digital TV: DVB-T
>>> Interface: USB 2.0
>>> Others Support: Microsoft® Windows 2000, XP, MCE and Windows Vista MCE
>>> / Win 7 32/ 64bits
>>> Remote sensor Interface: IR
>>> Tuner: NXP TDA18271
>>>
>>> Now I know that the decoder chip is supported in other USB sticks but
>>> mine is not recognised. Here is my lsusb output:
>>>
>>> Bus 001 Device 004: ID 1b80:d416 Afatech
>>>
>>> And here is the dmesg info I get when I plug it in:
>>>
>>> [ 2981.693805] usb 1-2: USB disconnect, address 2
>>> [ 2991.760091] usb 1-2: new high speed USB device using ehci_hcd and address 4
>>> [ 2991.916044] usb 1-2: configuration #1 chosen from 1 choice
>>>
>>>
>>> Is there anyone out there who might be interested in adding support
>>> for this (or guide me through it)?
>>>
>>>
>>> thanks,
>>> Dagur
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
