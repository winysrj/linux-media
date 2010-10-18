Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8280 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0JRM6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 08:58:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LAH006DQLCTR000@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Oct 2010 13:58:05 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LAH006QYLCS1X@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Oct 2010 13:58:05 +0100 (BST)
Date: Mon, 18 Oct 2010 14:58:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [git:v4l-dvb/v2.6.37] [media] Add driver for Siliconfile SR030PC30
 VGA camera
In-reply-to: <201010172214.15773.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4CBC445C.5000903@samsung.com>
References: <E1P7Yvq-0001kW-Pf@www.linuxtv.org>
 <201010172214.15773.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hello Hans,

On 10/17/2010 10:14 PM, Hans Verkuil wrote:
> On Sunday, October 17, 2010 21:28:29 Mauro Carvalho Chehab wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the 
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] Add driver for Siliconfile SR030PC30 VGA camera
>> Author:  Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Date:    Mon Oct 11 13:33:57 2010 -0300
>>
[snip]
> It fails to compile with this error:
> 
> drivers/media/video/sr030pc30.c: In function ‘sr030pc30_probe’:
> drivers/media/video/sr030pc30.c:834: error: implicit declaration of function ‘kzalloc’
> drivers/media/video/sr030pc30.c:834: warning: assignment makes pointer from integer without a cast
> drivers/media/video/sr030pc30.c: In function ‘sr030pc30_remove’:
> drivers/media/video/sr030pc30.c:858: error: implicit declaration of function ‘kfree’
> 
> Here is the patch to fix this:
[snip]
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 

Thank you for fixing this. I will definitely improve my test environment
so this kind of errors do not appear in the future.

Regards,
Sylwester

-- 
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center
