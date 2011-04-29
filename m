Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760173Ab1D2QcQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 12:32:16 -0400
Message-ID: <4DBAE789.5000606@redhat.com>
Date: Fri, 29 Apr 2011 13:30:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Drew Fisher <drew.m.fisher@gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] gspca - kinect: move communications
 buffers out of stack
References: <E1QFowG-0005SZ-7v@www.linuxtv.org>	<20110429172715.4b71dfb6.ospite@studenti.unina.it>	<4DBADCBB.8000107@redhat.com> <20110429181604.df0e6de8.ospite@studenti.unina.it>
In-Reply-To: <20110429181604.df0e6de8.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-04-2011 13:16, Antonio Ospite escreveu:
> On Fri, 29 Apr 2011 12:43:55 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> Em 29-04-2011 12:27, Antonio Ospite escreveu:
>>> On Fri, 29 Apr 2011 16:42:04 +0200
>>> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>>
>>>> This is an automatic generated email to let you know that the following patch were queued at the 
>>>> http://git.linuxtv.org/media_tree.git tree:
>>>>
>>>> Subject: [media] gspca - kinect: move communications buffers out of stack
>>>> Author:  Antonio Ospite <ospite@studenti.unina.it>
>>>> Date:    Thu Apr 21 06:51:34 2011 -0300
>>>>
>>>
>>> Hi Mauro, actually this one is from Drew Fisher as well, git-am should
>>> have picked up the additional From header:
>>> http://www.spinics.net/lists/linux-media/msg31576.html
>>
>> Gah!
>>
>> Patchwork suffered a crash. Patches got recovered yesterday, but all of them missed
>> the e-mail body:
>> 	https://patchwork.kernel.org/patch/724331/
>>
>> I'm needing to manually edit each patch before applying due to that.
>>
> 
> Just FYI, gmane stores a raw representation of messages which can be
> used with git-am, take:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/31735
> and add /raw at the end of the URL.

Good to know about the /raw mode of gmane.

I have also my own copy of the patches, but the thing is that the control I use here to know
what patches are still pending is based on patchwork. With pathwork.kernel.org broken,
my legs are also broken :/

After finishing to apply the current stuff there, I intend to think on another process that
won't make me dependent on a software/hardware where I cannot rely on it, nor fix the issues
directly. So, I'm thinking on abandoning the usage of patchwork, but the point is: what other
alternatives are left?

> 
>> I'll revert the patch and re-apply it with the proper authorship.
>>
> 
> Thanks a lot.
> 
> Best regards,
>    Antonio
> 

