Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5U7bJHM027820
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 03:37:19 -0400
Received: from averel.grnet-hq.admin.grnet.gr (averel.grnet-hq.admin.grnet.gr
	[195.251.29.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n5U7b3Iu009853
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 03:37:04 -0400
Message-Id: <1F215A73-B1A5-42BA-998B-2A8FD014BF0B@admin.grnet.gr>
From: Zenon Mousmoulas <zmousm@admin.grnet.gr>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Date: Tue, 30 Jun 2009 10:37:00 +0300
Subject: hdpvr firmware and controls
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I have a Hauppauge HD PVR (model 1227, revision E2). I have tried  
using it both with the 2.6.30 kernel (debian package) as well as  
2.6.26 with the latest code from the v4l-dvb repo compiled on top.

I have a couple of questions regarding the hdpvr driver:

- First of all, the driver says this, when loading:
hdpvr 7-1:1.0: untested firmware version 0x12, the driver might not work
Should I be worried? I've read about pre-loading the firmware but I  
don't think it applies/makes a difference for these units.

- I've noticed that at least one control is missing among the ones  
listed by v4l2-ctl -l: GOP mode. I haven't used the HD PVR in Windows  
but I think this control is available under some DirectX control  
properties. It is also available in Steven Toth's HDPVR Capture tool  
for MacOS. Is it missing from the v4l driver?

- According to an FAQ by Hauppauge it seems that it is possible to  
select the format of the bitstream the HD PVR delivers: TS, M2TS  
(HDMV) or MP4. I haven't confirmed it but if so, it would also be  
handy to be able to control this.

My goal is to do live streaming using the A/V bitstream as encoded by  
the HD PVR. So far I've had little success because VLC doesn't fully  
understand (0.8.6h) or chokes (0.9.9a) on the MPEG-TS coming from the  
device. I'm looking for other alternatives but I'd also like to try to  
make this as simple as possible (GOP mode = simple, "plain" TS instead  
of HDMV).

Thanks in advance for any suggestions.

Best regards,
Z.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
