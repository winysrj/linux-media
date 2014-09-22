Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37074 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbaIVQkT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 12:40:19 -0400
Message-ID: <542050F1.5020009@osg.samsung.com>
Date: Mon, 22 Sep 2014 10:40:17 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: au0828_init_tuner() called without dev lock held
References: <54204ECC.7070806@osg.samsung.com> <5420503E.7010608@xs4all.nl>
In-Reply-To: <5420503E.7010608@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2014 10:37 AM, Hans Verkuil wrote:
> On 09/22/2014 06:31 PM, Shuah Khan wrote:
>> Hi Hans and Mauro,
>>
>> While I was making changes for media token work, I noticed there are
>> several places au0828_init_tuner() gets called without holding dev lock.
> 
> au0828 sets the lock pointer in struct video_device to the dev lock.
> That means that all v4l2 ioctl calls are serialized in v4l2_ioctl()
> in v4l2-dev.c. So these calls *do* hold the device lock.
> 
> Not au0828_v4l2_resume() though, that's not an ioctl op.
> 

Good. I will go ahead and fix au0828_v4l2_resume() to do
it right.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
