Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1D2Pp5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 11:45:57 -0400
Message-ID: <4DBADCBB.8000107@redhat.com>
Date: Fri, 29 Apr 2011 12:43:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Drew Fisher <drew.m.fisher@gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] gspca - kinect: move communications
 buffers out of stack
References: <E1QFowG-0005SZ-7v@www.linuxtv.org> <20110429172715.4b71dfb6.ospite@studenti.unina.it>
In-Reply-To: <20110429172715.4b71dfb6.ospite@studenti.unina.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-04-2011 12:27, Antonio Ospite escreveu:
> On Fri, 29 Apr 2011 16:42:04 +0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> This is an automatic generated email to let you know that the following patch were queued at the 
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] gspca - kinect: move communications buffers out of stack
>> Author:  Antonio Ospite <ospite@studenti.unina.it>
>> Date:    Thu Apr 21 06:51:34 2011 -0300
>>
> 
> Hi Mauro, actually this one is from Drew Fisher as well, git-am should
> have picked up the additional From header:
> http://www.spinics.net/lists/linux-media/msg31576.html

Gah!

Patchwork suffered a crash. Patches got recovered yesterday, but all of them missed
the e-mail body:
	https://patchwork.kernel.org/patch/724331/

I'm needing to manually edit each patch before applying due to that.

I'll revert the patch and re-apply it with the proper authorship.

> 
>> Move large communications buffers out of stack and into device
>> structure. This prevents the frame size from being >1kB and fixes a
>> compiler warning when CONFIG_FRAME_WARN=1024:
>>
>> drivers/media/video/gspca/kinect.c: In function ‘send_cmd.clone.0’:
>> drivers/media/video/gspca/kinect.c:202: warning: the frame size of 1548 bytes is larger than 1024 bytes
>>
>> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Signed-off-by: Drew Fisher <drew.m.fisher@gmail.com>
>> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>  drivers/media/video/gspca/kinect.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
> 

