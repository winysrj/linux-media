Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.rtu.lv ([213.175.89.139]:29774 "EHLO mx1.rtu.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbaDDJUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 05:20:13 -0400
From: =?windows-1257?Q?Vit=E2lijs_=C8istovskis?=
	<Vitalijs.Cistovskis@rtu.lv>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Issue with sound recording
Date: Fri, 4 Apr 2014 09:14:19 +0000
Message-ID: <B506BAE614F703439873571E5BD16BF5EEB00C95@DAG1.rtupasts.lan>
Content-Language: lv-LV
Content-Type: text/plain; charset="windows-1257"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

We have an Osprey 210 video capture card, which we want to use with Matterhorn platform for lecture recording purposes. The problem is in the following, osprey card records audio in the “fast” mode. So, when you play the recorded track, speech sounds unnatural and accelerated. The card is installed on the Linux machine (Ubuntu Server 12.04 64-bit). As far as I understand, installation of the additional drivers is not required. All drivers are already included in the Linux kernel. I have tried to record the sound with Ubuntu Sound Recorder tool and gstreamer using different settings of the pipeline, the result was the same.  Despite of the problem with the audio, video records normally. That’s why we record sound separately using the default mainboard audio input, but it is not a good solution. The default mainboard audio input records sound with noises (I have tried to change the alsamixer settings, but it not helped much) and sound is a little behind video, too.  I think that if we will resolve the problem with osprey card, then a problem with the audio and video synchronization would disappear and the level of noise would be reduced. 

What could be the reason of issue related to audio recording in accelerated mode? Maybe some advice related to the noise reducing, too? Thanks!


Regards,
Vitalijs