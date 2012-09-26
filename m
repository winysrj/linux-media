Return-path: <linux-media-owner@vger.kernel.org>
Received: from eterpe-smout.broadpark.no ([80.202.8.16]:62216 "EHLO
	eterpe-smout.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2IZUan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 16:30:43 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from ignis-smin.broadpark.no ([80.202.8.11])
 by eterpe-smout.broadpark.no
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0MAZ002GS2738B00@eterpe-smout.broadpark.no> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 21:30:39 +0200 (CEST)
Received: from alstadheim.priv.no ([178.164.66.9]) by ignis-smin.broadpark.no
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTPSA id <0MAZ00IPY273ID60@ignis-smin.broadpark.no> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 21:30:39 +0200 (CEST)
Received: from alstadheim.priv.no (localhost [127.0.0.1])
	by signed.alstadheim.priv.no (Postfix) with ESMTP id 1416220158	for
 <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 21:30:39 +0200 (CEST)
Received: from [192.168.2.29] (sorgen.alstadheim.priv.no [192.168.2.29])
	(Authenticated sender: hakon)	by submission.alstadheim.priv.no (Postfix)
 with ESMTPSA id D853F200DE	for <linux-media@vger.kernel.org>; Wed,
 26 Sep 2012 21:30:38 +0200 (CEST)
Message-id: <506357DE.2040707@alstadheim.priv.no>
Date: Wed, 26 Sep 2012 21:30:38 +0200
From: =?ISO-8859-1?Q?H=E5kon_Alstadheim?= <hakon@alstadheim.priv.no>
To: linux-media@vger.kernel.org
Subject: Hang in Technotrend TT-connect CT-3650
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all, I'm new to the list so feel free to direct me somewhere else if 
the following is OT.

I get a hard lock on my machine, no response to Alt-Sysrq T, dead to the 
world,  when running the mentioned card with a Conax cam to record 
encrypted DVB-T channels. I have had the thing running through a night 
and recording a couple of shows, but mostly it locks up within seconds 
from the start of recording, with no pattern that I can see

I am running gentoo, and I have tried both the latest stable kernel with 
its modules, the latest unstable kernel with its modules and the modules 
from git as per 
<http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers>, 
the "Basic" approach. My current kernel is:

# uname -a
Linux medisin 3.5.4-gentoo #1 PREEMPT Wed Sep 26 14:23:09 CEST 2012 i686 
Intel(R) Pentium(R) 4 CPU 2.00GHz GenuineIntel GNU/Linux

Should I maybe loose the "preempt" ?

The last messages I get in my logs is

mythbackend: TVRecEvent tv_rec.cpp:3989 (TuningNewRecorder) - TVRec(7): 
rec->GetPathname(): '/apub/media/mythtv/2201_20120926203000.mpg'

kernel: [   98.144753] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x00

debug: medisin kernel: [   98.144753] ttusb2: tt3650_ci_read_cam_control 
0x01 -> 0 0x00

Everything up to that point seems hunky dory, such as 30 seconds earlier :
[   54.232760] ttusb2: tt3650_ci_init
[   59.244586] ttusb2: tt3650_ci_slot_reset 0
[   61.447592] ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x00
[   61.447842] ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x00
[   71.045833] ttusb2: tt3650_ci_set_video_port 0 0
[   71.047997] ttusb2: tt3650_ci_slot_reset 0
[   73.156515] ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x1d
[   73.156765] ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x04
[   71.045833] ttusb2: tt3650_ci_set_video_port 0 0
[   71.047997] ttusb2: tt3650_ci_slot_reset 0
.... and these go on ...

I have miles of logs, just tell me what to post :-)

Other interesting points about the system, in no particular order the 
box is a fairly old system, which has had some issues. I have repaced 
some popped caps, I believe I found them all. I have removed the usb 
flat-bed scanner so the draw on power should be /less/ than before, 
considering the Technotrend has its own power. I have made sure that 
lsusb says usb 2.0 on the bus.  What else should I check ?

Whith hope, Håkon :-)


