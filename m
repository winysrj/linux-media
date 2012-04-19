Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45452 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2DSWjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 18:39:10 -0400
Received: by vbbff1 with SMTP id ff1so6053947vbb.19
        for <linux-media@vger.kernel.org>; Thu, 19 Apr 2012 15:39:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WVK=YKGOsB3VV_0B8RRvX0LnTNps1d=zTyV9mdfkirQ8g@mail.gmail.com>
References: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com>
	<4F6DDB10.8000503@redhat.com>
	<CAL9G6WUNp1gHibG74L8VXyJ0KPDYY+amKy3JZ7MBkjB8DBwERA@mail.gmail.com>
	<CALF0-+Uf=1tMKMtOJKEOLiHQ=brkW6JL67A5qtWSJ8uOM3ZfsA@mail.gmail.com>
	<4F8F13D8.5080407@redhat.com>
	<CAL9G6WVK=YKGOsB3VV_0B8RRvX0LnTNps1d=zTyV9mdfkirQ8g@mail.gmail.com>
Date: Fri, 20 Apr 2012 00:39:10 +0200
Message-ID: <CAJ_iqtbVzU9zg_ERvhrbVr1vdgXXhyxJYdAmT0F1h_2ixP-==Q@mail.gmail.com>
Subject: Re: dvb lock patch
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/4/18 Josu Lazkano <josu.lazkano@gmail.com>:
> El día 18 de abril de 2012 21:19, Mauro Carvalho Chehab
> <mchehab@redhat.com> escribió:
>> Em 18-04-2012 15:58, Ezequiel García escreveu:
>>> Josu,
>>>
>>> On Tue, Apr 17, 2012 at 10:30 AM, Josu Lazkano <josu.lazkano@gmail.com> wrote:
>>>> 2012/3/24 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>> [snip]
>>>>>
>>>>> That doesn't sound right to me, and can actually cause race issues.
>>>>>
>>>>> Regards,
>>>>> Mauro.
>>>>
>>>> Thanks for the patch Mauro.
>>>>
>>>
>>> I think Mauro is *not* giving you a patch, rather the opposite:
>>> pointing out that the patch can
>>> cause problems!
>>
>> Yes. The driver will be unreliable with a patch like that, due to
>> race conditions.
>>
>>> Regards,
>>> Ezequiel.
>>
>> Regards,
>> Mauro.
>
> Thanks anyway.
>
> I am looking for a solution to use virtual adapters on MythTV to use
> my satellite provider card on two machines.
> With 2.6.32 kernel is working great, but there is no way to work with
> 3.x kernel.
>
> Is anyone using sasc-ng with latest kernel?
>

Would kernel 3.0.0.15 do?
If so, descriptions on how I did it here:
http://sites.google.com/site/tingox/digitaltv_sascng
http://sites.google.com/site/tingox/asrock_e350m1_xubuntu

Note: these are my work notes, not a how-to!

As you can see, I'm using this patch:
http://kipdola.be/subdomain/linux-2.6.38-dvb-mutex.patch

It seems to work for me (had it running with Kaffeine on encrypted
channesl for two weeks in a row)

HTH
-- 
Regards,
Torfinn Ingolfsen
