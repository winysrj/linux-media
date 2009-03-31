Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:32881 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763998AbZCaWyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 18:54:50 -0400
Received: by fxm2 with SMTP id 2so2677067fxm.37
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 15:54:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090309202015.14c78009@pedra.chehab.org>
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
	 <20090306074604.10926b03@pedra.chehab.org>
	 <200903092333.38819.tobias.lorenz@gmx.net>
	 <20090309202015.14c78009@pedra.chehab.org>
Date: Wed, 1 Apr 2009 02:54:47 +0400
Message-ID: <208cbae30903311554v2883b630hf235cea9997207ed@mail.gmail.com>
Subject: Re: About the radio-si470x driver for I2C interface
From: Alexey Klimov <klimov.linux@gmail.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>,
	Joonyoung Shim <dofmind@gmail.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

On Tue, Mar 10, 2009 at 3:20 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Mon, 9 Mar 2009 23:33:38 +0100
> Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
>
>> Hi,
>>
>> > The proper way is to break radio-si470x into two parts:
>> >
>> >     - A i2c adapter driver (similar to what we have on cx88-i2c, for
>> >       example, plus the radio part of cx88-video);
>> >     - A radio driver (similar to tea5767.c).
>> >
>> > This way, the i2c driver can be used on designs that use a different i2c adapter.
>>
>> yes, this is why I already capsulated most of the USB functionality into own functions. I awaited that somewhen the si470x is used in the "usual" way by i2c.
>>
>> I'm not sure, if we should split the driver into three files (generic/common, usb, i2c) or just implement the new functionality within the same file using macros/defines.
>
> It is better to split. It will provide more flexibility.

Tobias, Joonyoung

Is there any success on this ?

-- 
Best regards, Klimov Alexey
