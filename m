Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:56018 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbaDBURH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 16:17:07 -0400
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3F002TF70I5H60@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Apr 2014 16:17:06 -0400 (EDT)
Message-id: <533C703E.8040607@samsung.com>
Date: Wed, 02 Apr 2014 14:17:02 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
MIME-version: 1.0
To: media-workshop@linuxtv.org, linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>
Subject: [Proposal] media mini-summit - Linux media power management -
 problems, challenges and fixes
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am requesting that the following presentation/discussion to be added 
to the media mini-summit agenda. The intent is to do a very short 
presentation and leave time for discussion.

Linux media power management - problems, challenges and fixes

Media devices can be very complex to support in software - for example, 
a small USB TV stick is packed with several components providing the 
functionality to tune, stream analog and/or digital video and audio. 
Some hybrid devices support both analog, and digital TV tuning 
capability with or without a remote control capability. A single TV 
device, which connects to the PC on a USB bus, could have one or more 
I2C buses internally to implement tuning and remote control features.

On Linux, several individual component drivers come together to provide 
full functionality on these media devices. For instance, a single 
digital USB TV stick will have a USB driver that acts as the front-end 
for several Linux TV media infrastructure components such as: Digital 
Video Broadcasting (dvb), Audio, and Video4linux (v4l2). Each of these 
extensions initialize and control their set of registers on the device 
with the aid of additional tuner and remote control drivers. As you can 
see, the infrastructure supporting one of these devices is complex and 
handling suspend/resume within the OS quickly becomes a challenge. It 
won't come as a too much of a surprise to hear that most media drivers 
don't handle power management properly. This is due to the lack of a 
good PM infrastructure inside the media core, as well as driver bugs in 
their suspend and resume code paths. This work also includes using 
devres infrastructure work to handle shared media resources such as 
tuner, demux etc.

In this presentation, we will discuss what is being done to address 
these issues and also present an overview of PM infrastructure being 
considered for future kernel releases.

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
