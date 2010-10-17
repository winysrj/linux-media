Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab0JQVa1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 17:30:27 -0400
Message-ID: <4CBB6AEB.20508@redhat.com>
Date: Sun, 17 Oct 2010 19:30:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [git:v4l-dvb/v2.6.37] [media] Add driver for Siliconfile SR030PC30
 VGA camera
References: <E1P7Yvq-0001kW-Pf@www.linuxtv.org> <201010172214.15773.hverkuil@xs4all.nl>
In-Reply-To: <201010172214.15773.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-10-2010 18:14, Hans Verkuil escreveu:
> On Sunday, October 17, 2010 21:28:29 Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the 
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] Add driver for Siliconfile SR030PC30 VGA camera
>> Author:  Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Date:    Mon Oct 11 13:33:57 2010 -0300
>>
>> Add an I2C/v4l2-subdev driver for Siliconfile SR030PC30 VGA
>> camera sensor with Image Signal Processor. SR030PC30 is
>> the low resolution camera sensor on Samsung Aquila boards.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>  drivers/media/video/Kconfig     |    6 +
>>  drivers/media/video/Makefile    |    1 +
>>  drivers/media/video/sr030pc30.c |  893 +++++++++++++++++++++++++++++++++++++++
>>  include/media/sr030pc30.h       |   21 +
>>  4 files changed, 921 insertions(+), 0 deletions(-)
> 
> It fails to compile with this error:
> 
> drivers/media/video/sr030pc30.c: In function ‘sr030pc30_probe’:
> drivers/media/video/sr030pc30.c:834: error: implicit declaration of function ‘kzalloc’
> drivers/media/video/sr030pc30.c:834: warning: assignment makes pointer from integer without a cast
> drivers/media/video/sr030pc30.c: In function ‘sr030pc30_remove’:
> drivers/media/video/sr030pc30.c:858: error: implicit declaration of function ‘kfree’

Hmm... it is funny that the driver compiled well here, but failed for you...
I've compiled it with allyesconfig. I got just some warnings...

> 
> Here is the patch to fix this:

Applied. Thanks for the fix!

Thanks,
Mauro
