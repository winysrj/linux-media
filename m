Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35892 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaILBfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 21:35:12 -0400
Message-ID: <54124BDC.3000306@osg.samsung.com>
Date: Thu, 11 Sep 2014 19:26:52 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: "mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	hverkuil@xs4all.nl
CC: linux-media@vger.kernel.org
Subject: v4l2 ioctls
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro/Hans,

I am working on adding sharing construct to dvb-core and v4l2-core.
In the case of dvb I have clean start and stop points to acquire the
tuner and release it. Tuner is acquired from dvb_frontend_start() and
released from dvb_frontend_thread() when thread exits. This works very
well.

The problem with analog case is there are no clear entry and exit
points. Instead of changing ioctls, it will be cleaner to change
the main ioctl entry routine __video_do_ioctl(). Is there an easy
way to tell which ioctls are query only and which are set?

So far I changed the following to check check for tuner token
before they invoke v4l2_ioctl_ops:

v4l_g_tuner()
v4l_s_tuner()
v4l_s_modulator()
v4l_s_frequency()
v4l_s_hw_freq_seek()

This isn't enough looks like, since I see tuner_s_std() getting
invoked and cutting off the dvb stream. I am currently releasing
the tuner from v4l2_fh_exit(), but I don't think that is a good
idea since all these ioctls are independent control paths. Each
ioctl might have to acquire and release it at the end. More on
this below.

For example, xawtv makes several ioctls before it even touches the
tuner to set frequency and starting the stream. What I am looking
for is an ioctl that would signal the intent to hold the tuner.
Is that possible?

The question is can we identify a clean start and stop points
for analog case for tuner ownership??

Would it make sense to treat all these ioctls as independent and
make them acquire and release lock or hold the tuner in shared
mode? Shared doesn't really make sense to me since two user-space
analog apps can interfere with each other.

I am trying avoid changing tuner-core and if at all possible.

I can send the code I have now for review if you like. I have the
locking construct in a good state at the moment. dvb is in good
shape.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
