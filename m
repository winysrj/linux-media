Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356Ab1ECB1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 21:27:21 -0400
Message-ID: <4DBF59D7.5030707@redhat.com>
Date: Mon, 02 May 2011 22:26:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] dvb-usb return device errors
 to demuxer
References: <E1QH07c-0003fV-LJ@www.linuxtv.org> <1304372045.4781.8.camel@localhost>
In-Reply-To: <1304372045.4781.8.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-05-2011 18:34, Malcolm Priestley escreveu:
> On Mon, 2011-05-02 at 22:51 +0200, Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the 
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] dvb-usb return device errors to demuxer
>> Author:  Malcolm Priestley <tvboxspy@gmail.com>
>> Date:    Sat Apr 16 13:30:32 2011 -0300
>>
>> Return device errors to demuxer from on/off streamming and
>>  pid filtering.
>>
>> Please test this patch with all dvb-usb devices.
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>  drivers/media/dvb/dvb-usb/dvb-usb-dvb.c |   32 ++++++++++++++++++++----------
>>  1 files changed, 21 insertions(+), 11 deletions(-)
>>
> 
> This patch was originally marked Not Applicable on the Patchwork server.

Patchwork is not reliable, unfortunately. Over the last weeks, we've
found several troubles with it, like:
	- patches applied there got lost due to mysql corruption;
	- patches not caught by patchwork;
	- patchwork on a read-only status;
	- patchwork loosing status changes;
	- patchwork lack of availability;
	- patches body/SOB/From: lost.

So, I'm needing to recover manually some patches. That's why I ended to
recover v1 of your patch.
> 
> It was replaced by dvb-usb return device errors to demuxer v2.
> https://patchwork.kernel.org/patch/713651/

Thanks for pointing it to me. 

I noticed it after applying the first version, but I had to take a break.

Anyway, I've just applied the diff between v1 and v2 as a new patch. 
I'll try to remember about that when submitting upstream, in order 
to merge both.

Thanks,
Mauro
