Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44554 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaGVBFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 21:05:09 -0400
Message-ID: <53CDB8C1.8000203@iki.fi>
Date: Tue, 22 Jul 2014 04:05:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] SDR stuff
References: <53C874F8.3020300@iki.fi> <20140721205005.28e2e784.m.chehab@samsung.com> <53CDAB73.8050108@iki.fi> <20140721215140.35935811.m.chehab@samsung.com>
In-Reply-To: <20140721215140.35935811.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2014 03:51 AM, Mauro Carvalho Chehab wrote:
> Em Tue, 22 Jul 2014 03:08:19 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> So what. Those were mostly WARNING only and all but long lines were some
>> new checks added to checkpatch recently. chekcpatch gets all the time
>> new and new checks, these were added after I have made that driver. I
>> will surely clean those later when I do some new changes to driver and
>> my checkpatch updates.
>
> Antti,
>
> I think you didn't read my comments in the middle of the checkpatch stuff.
> Please read my email again. I'm not requiring you to fix the newer checkpatch
> warning (Missing a blank line after declarations), and not even about the
> 80-cols warning. The thing is that there are two issues there:
>
> 1) you're adding API bits at msi2500 driver, instead of moving them
>     to videodev2.h (or reusing the fourcc types you already added there);

If you look inside driver code, you will see those defines are not used 
- but commented out. It is simply dead definition compiler optimizes 
away. It is code I used on my tests, but finally decided to comment out 
to leave some time add those later to API. I later moved 2 of those to 
API, that is done in same patch serie.

No issue here.

> 2) you're handling jiffies wrong inside the driver.
>
> As you may know, adding a driver at staging is easier than at the main
> tree, as we don't care much about checkpatch issues (and not even about
> some more serious issues). However, when moving stuff out of staging,
> we review the entire driver again, to be sure that it is ok.

That jiffie check is also rather new and didn't exists time drive was 
done. Jiffie is used to calculate debug sample rate. There is multiple 
times very similar code piece, which could be optimized to one. My plan 
merge all those ~5 functions to one and use jiffies using macros as 
checkpatch now likes. I don't see meaningful fix it now as you are going 
to rewrite that stuff in near future in any case.


Silencing all those checkpatch things is not very hard job though. If 
you merge that stuff to media/master I can do it right away (I am 
running older kernel and older checkpatch currently).


regards
Antti

-- 
http://palosaari.fi/
