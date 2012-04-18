Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab2DRTT4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 15:19:56 -0400
Message-ID: <4F8F13D8.5080407@redhat.com>
Date: Wed, 18 Apr 2012 16:19:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
CC: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb lock patch
References: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com> <4F6DDB10.8000503@redhat.com> <CAL9G6WUNp1gHibG74L8VXyJ0KPDYY+amKy3JZ7MBkjB8DBwERA@mail.gmail.com> <CALF0-+Uf=1tMKMtOJKEOLiHQ=brkW6JL67A5qtWSJ8uOM3ZfsA@mail.gmail.com>
In-Reply-To: <CALF0-+Uf=1tMKMtOJKEOLiHQ=brkW6JL67A5qtWSJ8uOM3ZfsA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-04-2012 15:58, Ezequiel García escreveu:
> Josu,
> 
> On Tue, Apr 17, 2012 at 10:30 AM, Josu Lazkano <josu.lazkano@gmail.com> wrote:
>> 2012/3/24 Mauro Carvalho Chehab <mchehab@redhat.com>:
> [snip]
>>>
>>> That doesn't sound right to me, and can actually cause race issues.
>>>
>>> Regards,
>>> Mauro.
>>
>> Thanks for the patch Mauro.
>>
> 
> I think Mauro is *not* giving you a patch, rather the opposite:
> pointing out that the patch can
> cause problems!

Yes. The driver will be unreliable with a patch like that, due to
race conditions.

> Regards,
> Ezequiel.

Regards,
Mauro.
