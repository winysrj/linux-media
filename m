Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33862 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbbI1L7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2015 07:59:44 -0400
Received: by labzv5 with SMTP id zv5so11999382lab.1
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2015 04:59:42 -0700 (PDT)
Subject: Re: [git:media_tree/master] [media] rcar_vin: call g_std() instead of
 querystd()
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <E1ZfZpS-0004ra-EU@www.linuxtv.org>
 <5605BF3C.5040309@cogentembedded.com>
 <Pine.LNX.4.64.1509272120240.14212@axis700.grange>
 <20150927170826.5063f729@recife.lan>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56092BAD.3080104@cogentembedded.com>
Date: Mon, 28 Sep 2015 14:59:41 +0300
MIME-Version: 1.0
In-Reply-To: <20150927170826.5063f729@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 9/27/2015 11:08 PM, Mauro Carvalho Chehab wrote:

>>>> This is an automatic generated email to let you know that the following
>>>> patch were queued at the
>>>> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
>>>>
>>>> Subject: [media] rcar_vin: call g_std() instead of querystd()
>>>> Author:  Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>> Date:    Thu Sep 3 20:18:05 2015 -0300
>>>>
>>>> Hans Verkuil says: "The only place querystd can be called  is in the
>>>> QUERYSTD
>>>> ioctl, all other ioctls should use the last set standard." So call the
>>>> g_std()
>>>> subdevice method instead of querystd() in the driver's set_fmt() method.
>>>>
>>>> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
>>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>>     Note that merging this patch without the 2 patches preceding it in the the
>>> series will break the frame capture.
>>
>> Ouch, the other 2 patches were not for me, I wasn't even CC'ed on them,
>> but I guess I should have read patch 0/3, on which I was indeed CC'ed and
>> just have acked this patch instead of pushing it... Mauro, I guess the
>> only two possibilities to fix this now is to also push the other two
>> patches or to revert this one. Sorry about this.

> Well, if the other two patches are OK, then send me a pull request,
> and I'll merge them.

    The adv7180 patch was rejected by Hans. I'm still hoping Lars-Peter will 
look into removing the auto-detect feature from this driver.

MBR, Sergei

