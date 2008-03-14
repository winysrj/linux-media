Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2EMFCQ3028307
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 18:15:12 -0400
Received: from gaimboi.tmr.com (mail.tmr.com [64.65.253.246])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2EMEaMr002099
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 18:14:37 -0400
Received: from [127.0.0.1] (gaimboi.tmr.com [127.0.0.1])
	by gaimboi.tmr.com (8.12.8/8.12.8) with ESMTP id m2EMKlAv027823
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 18:20:48 -0400
Message-ID: <47DAFA3F.2020406@tmr.com>
Date: Fri, 14 Mar 2008 18:20:47 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: video4linux M/L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: ATI "HDTV Wonder" audio
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

I'm trying to use an HDTV Wonder, using the cx88 chipset, and I am 
getting no sound. Originally I was getting the native sound disabled by 
the card, just putting it in a system. However, by moving the driver 
usiung "index=" in modprobe.conf, I can keep sound for everything except 
the card. It will grab an image just fine, but there's no audio.

Is there a known solution? Google didn't find one in English, and I 
assume that it's as simple as an option in the module load, if I know 
what module to change. I tried the cx88_alsa, and alsamixer sees the 
card, but doesn't capture the sound.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
