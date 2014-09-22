Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3846 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaIVQhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 12:37:42 -0400
Message-ID: <5420503E.7010608@xs4all.nl>
Date: Mon, 22 Sep 2014 18:37:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>,
	"mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: au0828_init_tuner() called without dev lock held
References: <54204ECC.7070806@osg.samsung.com>
In-Reply-To: <54204ECC.7070806@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2014 06:31 PM, Shuah Khan wrote:
> Hi Hans and Mauro,
> 
> While I was making changes for media token work, I noticed there are
> several places au0828_init_tuner() gets called without holding dev lock.

au0828 sets the lock pointer in struct video_device to the dev lock.
That means that all v4l2 ioctl calls are serialized in v4l2_ioctl()
in v4l2-dev.c. So these calls *do* hold the device lock.

Not au0828_v4l2_resume() though, that's not an ioctl op.

Regards,

	Hans

> 
> vidioc_s_std(), vidioc_g_tuner(), vidioc_s_tuner(), vidioc_streamon()
> au0828_v4l2_resume()
> 
> Some of these might be intended since au0828_init_tuner() invokes
> s_std. All of these changes including the au0828_init_tuner() itself
> were added in ea86968fb91471493ccac7d8f2a65bc65db6803b
> 
> au0828_v4l2_resume() also does this and this one for sure needs fixing
> very likely. I am not sure about the others. Thoughts??
> 
> -- Shuah
> 

