Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55163 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1FGGmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 02:42:43 -0400
Received: by iwn34 with SMTP id 34so3758837iwn.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 23:42:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=fj+DSDNnJ+C43GenpBheOkoL23Q@mail.gmail.com>
References: <BANLkTik8JCCB2zri7nAmTX+gvUwOunbYcg@mail.gmail.com>
	<BANLkTi=fj+DSDNnJ+C43GenpBheOkoL23Q@mail.gmail.com>
Date: Tue, 7 Jun 2011 08:42:42 +0200
Message-ID: <BANLkTinwGfJ08j58z8sS19ZBmCYOxX=-Eg@mail.gmail.com>
Subject: Re: EM28188 and TDA18271HDC2
From: Kristoffer Edwardsson <krisse02@gmail.com>
To: Magnus Alm <magnus.alm@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Yes they do but closed drivers. as there is a em28xx project in kernel
with support for other empia drivers I just wanted to contribute with
device information.

On Mon, Jun 6, 2011 at 3:58 PM, Magnus Alm <magnus.alm@gmail.com> wrote:
> Hi!
>
> Doesn't Sundtek make their own closed drivers?
>
> 2011/6/6 Kristoffer Edwardsson <krisse02@gmail.com>:
>> HI
>>
>> I Noticed the em28xx driver in kernel but the EM28188 is not supported.
>>
>> I dont know if it can be supported but here is some info about the device.
>> Its a DVB-CT hybrid device without analog from Sundtek.
>>
>>
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               2.00
>>  bDeviceClass            0 (Defined at Interface level)
>>  bDeviceSubClass         0
>>  bDeviceProtocol         0
>>  bMaxPacketSize0        64
>>  idVendor           0xeb1a eMPIA Technology, Inc.
>>  idProduct          0x51b2
>>  bcdDevice            1.00
>>  iManufacturer           0
>>  iProduct                1 USB 28185 Device
>>  iSerial                 2 ODVBTB
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>
>> //Kristoffer
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
