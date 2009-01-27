Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:38289 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbZA0RSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 12:18:20 -0500
Received: by qyk4 with SMTP id 4so7353365qyk.13
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 09:18:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19a3b7a80901270915k21729403w1f2f9be019ae9112@mail.gmail.com>
References: <COL108-W41AFFE7632E1F6055B53F8D9CC0@phx.gbl>
	 <19a3b7a80901270915k21729403w1f2f9be019ae9112@mail.gmail.com>
Date: Tue, 27 Jan 2009 12:18:18 -0500
Message-ID: <412bdbff0901270918w71c5e8c3k4600a527602a59fa@mail.gmail.com>
Subject: Re: [linux-dvb] Dallas Texas ATSC scan file
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: linux-media@vger.kernel.org
Cc: mkrufky@linuxtv.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Christoph,

These should not be committed.  For ATSC, there is a well known list
of frequencies, and they should not vary by region.  Committing this
will only result in confusion, since scanning the entire spectrum only
takes a few minutes and the list of known transponders could change
over time.

Devin

On Tue, Jan 27, 2009 at 12:15 PM, Christoph Pfister
<christophpfister@gmail.com> wrote:
> Mike,
>
> Can I have your $0.02, please?
>
> Thanks,
>
> Christoph
>
> 2009/1/24 Jorge Canas <jcanas2000@hotmail.com>:
>> # DALLAS TX ATSC center frequencies, use if in doubt
>>
>> A 189028615 8VSB
>> A 473028615 8VSB
>> A 497028615 8VSB
>> A 503028615 8VSB
>> A 533028615 8VSB
>> A 569028615 8VSB
>> A 581028615 8VSB
>> A 599028615 8VSB
>> A 605028615 8VSB
>> A 629028615 8VSB
>> A 635028615 8VSB
>> A 641028615 8VSB
>> A 659028615 8VSB
>> A 665028615 8VSB
>> A 677028615 8VSB
>> A 695028615 8VSB
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>



-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
