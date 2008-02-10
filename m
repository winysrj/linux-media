Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1AL5ckL017241
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 16:05:38 -0500
Received: from smtp-out4.blueyonder.co.uk (smtp-out4.blueyonder.co.uk
	[195.188.213.7])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1AL5HfW024208
	for <video4linux-list@redhat.com>; Sun, 10 Feb 2008 16:05:17 -0500
Received: from [172.23.170.141] (helo=anti-virus02-08)
	by smtp-out4.blueyonder.co.uk with smtp (Exim 4.52)
	id 1JOJMS-0000x9-VL
	for video4linux-list@redhat.com; Sun, 10 Feb 2008 21:05:16 +0000
Received: from [80.195.195.227] (helo=[80.195.195.227])
	by asmtp-out5.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1JOJMS-0005Or-H3
	for video4linux-list@redhat.com; Sun, 10 Feb 2008 21:05:16 +0000
Message-ID: <47AF671E.2030509@blueyonder.co.uk>
Date: Sun, 10 Feb 2008 21:05:34 +0000
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Alsa Mixer Settings
Reply-To: Ian.davidson@bigfoot.com
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

I am running Fedora Core 4 and I use the machine to record.  On various 
occasions I have updated the software.  Sometimes ALSA Mixer remembers 
the settings from one boot to another - and sometimes it forgets.  
Currently, it is in a 'forgetting mood' so each time I boot, the 
settings are the same as last time I BOOTED. I change them, but when I 
boot again, there they are back at the old settings again.  (This is not 
zero or maximum, but somewhere in between)

I presume that ALSA Mixer uses some file somewhere to record the 
settings it is going to start with.  Where should I look?

Ian

-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying
objective reality. Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. Facts
supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of
actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury
resulting from memorisation and subsequent use.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
