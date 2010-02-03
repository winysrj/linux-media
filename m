Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50846 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0BCU6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 15:58:10 -0500
Received: by bwz19 with SMTP id 19so528774bwz.28
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 12:58:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B69E193.6040206@arcor.de>
References: <4B673790.3030706@arcor.de> <4B688507.606@redhat.com>
	 <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com>
	 <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>
	 <4B69D8CC.2030008@arcor.de> <4B69D9AF.4020309@arcor.de>
	 <4B69DB9D.90609@redhat.com> <4B69E193.6040206@arcor.de>
Date: Wed, 3 Feb 2010 15:58:07 -0500
Message-ID: <829197381002031258w23689c32hf2de28ed5e58f025@mail.gmail.com>
Subject: Re: [PATCH 4/15] - tm6000.h
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 3:50 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> Am 03.02.2010 21:25, schrieb Mauro Carvalho Chehab:
>> This one is a very obscure patch. What are you doing this patch and why?
>>
>> Stefan Ringel wrote:
>>
>>> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>>
>>> --- a/drivers/staging/tm6000/tm6000.h
>>> +++ b/drivers/staging/tm6000/tm6000.h
>>> @@ -90,12 +97,14 @@ enum tm6000_core_state {
>>>      DEV_MISCONFIGURED = 0x04,
>>>  };
>>>
>>> +#if 1
>>>  /* io methods */
>>>  enum tm6000_io_method {
>>>      IO_NONE,
>>>      IO_READ,
>>>      IO_MMAP,
>>>  };
>>> +#endif
>>>
>>>
> ? different between git and hg ? not mine

Stefan,

The patches *you submitted* included this "#if 1".  Regardless of
whether it's differences between git and hg or some other weird merge
bug, you are responsible for the patches you submit.  You should be
reviewing each patch before sending it, and if it contains things you
do not understand why they are there, then you need to resolve those
inconsistencies before submitting the patch.

Reviewing each patch individually before sending also helps avoid
avoid things like submitting patches which make arbitrary/unnecessary
whitespace changes.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
