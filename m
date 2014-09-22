Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37068 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbaIVQbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 12:31:36 -0400
Message-ID: <54204ECC.7070806@osg.samsung.com>
Date: Mon, 22 Sep 2014 10:31:08 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: au0828_init_tuner() called without dev lock held
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Mauro,

While I was making changes for media token work, I noticed there are
several places au0828_init_tuner() gets called without holding dev lock.

vidioc_s_std(), vidioc_g_tuner(), vidioc_s_tuner(), vidioc_streamon()
au0828_v4l2_resume()

Some of these might be intended since au0828_init_tuner() invokes
s_std. All of these changes including the au0828_init_tuner() itself
were added in ea86968fb91471493ccac7d8f2a65bc65db6803b

au0828_v4l2_resume() also does this and this one for sure needs fixing
very likely. I am not sure about the others. Thoughts??

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
