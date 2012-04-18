Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41558 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2DRUNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 16:13:16 -0400
Received: by wibhq7 with SMTP id hq7so1062173wib.1
        for <linux-media@vger.kernel.org>; Wed, 18 Apr 2012 13:13:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F8F13D8.5080407@redhat.com>
References: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com>
	<4F6DDB10.8000503@redhat.com>
	<CAL9G6WUNp1gHibG74L8VXyJ0KPDYY+amKy3JZ7MBkjB8DBwERA@mail.gmail.com>
	<CALF0-+Uf=1tMKMtOJKEOLiHQ=brkW6JL67A5qtWSJ8uOM3ZfsA@mail.gmail.com>
	<4F8F13D8.5080407@redhat.com>
Date: Wed, 18 Apr 2012 22:13:14 +0200
Message-ID: <CAL9G6WVK=YKGOsB3VV_0B8RRvX0LnTNps1d=zTyV9mdfkirQ8g@mail.gmail.com>
Subject: Re: dvb lock patch
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El día 18 de abril de 2012 21:19, Mauro Carvalho Chehab
<mchehab@redhat.com> escribió:
> Em 18-04-2012 15:58, Ezequiel García escreveu:
>> Josu,
>>
>> On Tue, Apr 17, 2012 at 10:30 AM, Josu Lazkano <josu.lazkano@gmail.com> wrote:
>>> 2012/3/24 Mauro Carvalho Chehab <mchehab@redhat.com>:
>> [snip]
>>>>
>>>> That doesn't sound right to me, and can actually cause race issues.
>>>>
>>>> Regards,
>>>> Mauro.
>>>
>>> Thanks for the patch Mauro.
>>>
>>
>> I think Mauro is *not* giving you a patch, rather the opposite:
>> pointing out that the patch can
>> cause problems!
>
> Yes. The driver will be unreliable with a patch like that, due to
> race conditions.
>
>> Regards,
>> Ezequiel.
>
> Regards,
> Mauro.

Thanks anyway.

I am looking for a solution to use virtual adapters on MythTV to use
my satellite provider card on two machines.
With 2.6.32 kernel is working great, but there is no way to work with
3.x kernel.

Is anyone using sasc-ng with latest kernel?

Kind regards.

-- 
Josu Lazkano
