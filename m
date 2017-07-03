Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34059 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbdGCImU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 04:42:20 -0400
Subject: Re: Null Pointer Dereference in mceusb
To: Johan Hovold <johan@kernel.org>, Sebastian <sebastian@iseclab.org>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
References: <CAL8_TH8JTPd5ki-v-+T-Z+VGRg-vfsx=rYMjKq_vbUfTBPff3w@mail.gmail.com>
 <20170601072023.GM6735@localhost>
 <CAL8_TH8xEd0i2VDgZwsh_Jcpt3f4D=xitbKSR_3YYRxek=denA@mail.gmail.com>
 <20170703081019.GA7084@localhost>
From: Lars Melin <larsm17@gmail.com>
Message-ID: <c7dbd628-6176-3a0b-eaec-b8e2549ca50f@gmail.com>
Date: Mon, 3 Jul 2017 15:41:59 +0700
MIME-Version: 1.0
In-Reply-To: <20170703081019.GA7084@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-07-03 15:10, Johan Hovold wrote:
> On Thu, Jun 29, 2017 at 07:41:24PM +0200, Sebastian wrote:
>> Sorry for the long delay, Johan.
>>
>> 2017-06-01 9:20 GMT+02:00 Johan Hovold <johan@kernel.org>:
>>> [ +CC: media list ]
>>>
>>> On Wed, May 31, 2017 at 08:25:42PM +0200, Sebastian wrote:
>>>
>>> What is the lsusb -v output for your device? And have you successfully
>>> used this device with this driver before?
>>>
>>
>> No, the device wasn't successfully used before that- it crashed every time,
>> so I threw away the usb receiver. This is also the reason why I cannot give
>> you the lsusb output. But I can give you the VID:PID -> 03ee:2501 if that
>> is of any help?
> 
> Ok, so it's not necessarily a (recent) regression at least. I can't seem
> to find anyone else posting lsusb -v output for that device
> unfortunately.
> 

Googling "03ee:2501 bDescriptorType" leads us to:
https://sourceforge.net/p/lirc/mailman/message/12852102/

/Lars
