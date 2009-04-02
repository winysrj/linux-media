Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:24581 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZDBBmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 21:42:38 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KHG0086AA2ZNH@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Apr 2009 10:42:35 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KHG00G40A2Z19@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Apr 2009 10:42:35 +0900 (KST)
Date: Thu, 02 Apr 2009 10:42:35 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: About the radio-si470x driver for I2C interface
In-reply-to: <4e1455be0904011754l2c51cf2fi6336d07d591cbb71@mail.gmail.com>
To: klimov.linux@gmail.com
Cc: linux-media@vger.kernel.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <49D4180B.4040805@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
 <20090306074604.10926b03@pedra.chehab.org>
 <200903092333.38819.tobias.lorenz@gmx.net>
 <20090309202015.14c78009@pedra.chehab.org>
 <208cbae30903311554v2883b630hf235cea9997207ed@mail.gmail.com>
 <4e1455be0904011754l2c51cf2fi6336d07d591cbb71@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hello
> 
> On Tue, Mar 10, 2009 at 3:20 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> On Mon, 9 Mar 2009 23:33:38 +0100
>> Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
>>
>>> Hi,
>>>
>>>> The proper way is to break radio-si470x into two parts:
>>>>
>>>>     - A i2c adapter driver (similar to what we have on cx88-i2c, for
>>>>       example, plus the radio part of cx88-video);
>>>>     - A radio driver (similar to tea5767.c).
>>>>
>>>> This way, the i2c driver can be used on designs that use a different i2c adapter.
>>> yes, this is why I already capsulated most of the USB functionality into own functions. I awaited that somewhen the si470x is used in the "usual" way by i2c.
>>>
>>> I'm not sure, if we should split the driver into three files (generic/common, usb, i2c) or just implement the new functionality within the same file using macros/defines.
>> It is better to split. It will provide more flexibility.
> 
> Tobias, Joonyoung
> 
> Is there any success on this ?

Hi,

I have tried, but could not do it yet.

Like radio-tea5764.c, radio-si470x driver for I2C interface also was
implemented as the I2C driver, but it has many redundant functions with
the existing radio-si470x for USB interface, so I tried to join two
interfaces but it was a difficult work. I have never seen the linux device
driver probing more than one interface optionally.

-- Joonyoung Shim

> 
> --
> Best regards, Klimov Alexey
> 
> 
> 

