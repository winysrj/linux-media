Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UDwHKR013958
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 09:58:17 -0400
Received: from smtp-out5.blueyonder.co.uk (smtp-out5.blueyonder.co.uk
	[195.188.213.8])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6UDw3sL023039
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 09:58:03 -0400
Message-ID: <4890737B.9070907@blueyonder.co.uk>
Date: Wed, 30 Jul 2008 14:58:19 +0100
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Cards detected but not functioning under xawtv
Reply-To: Ian.Davidson@bigfoot.com
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

This message is posted on behalf of George Leonard

Hi all

have made modifications to modprobe.conf

if i then run xawtv -hwscan i get the below.

but when i open xawtv i get a black screen.

opensuse 10.3.
Linux suse-left 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC i686 
i686 i386 GNU/Linux

Kodicom 4400R



suse-left:~ # xawtv -hwscan
This is xawtv-3.95, running on Linux/i686 (2.6.22.5-31-default)
looking for available devices
/dev/video0: OK                         [ -device /dev/video0 ]
    type : v4l2
    name : BT878 video (Kodicom 4400R (sla
    flags: overlay capture 

/dev/video1: OK                         [ -device /dev/video1 ]
    type : v4l2
    name : BT878 video (Kodicom 4400R (mas
    flags: overlay capture 

/dev/video2: OK                         [ -device /dev/video2 ]
    type : v4l2
    name : BT878 video (Kodicom 4400R (sla
    flags: overlay capture 

/dev/video3: OK                         [ -device /dev/video3 ]
    type : v4l2
    name : BT878 video (Kodicom 4400R (sla
    flags: overlay capture 

suse-left:~ #

Continue

here is the screen output when i run xawtv


suse-left:~ # xawtv
This is xawtv-3.95, running on Linux/i686 (2.6.22.5-31-default)
WARNING: Your X-Server has no DGA support.
WARNING: couldn't find framebuffer base address, try manual
         configuration ("v4l-conf -a <addr>")
ioctl: VIDIOC_OVERLAY(int=1): Invalid argument

ioctl: VIDIOC_OVERLAY(int=1): Invalid argument


suse-left:~ # cd /dev/
suse-left:/dev # ls -la video*
lrwxrwxrwx 1 root root      6 Jul 29 17:41 video -> video0
crw-rw---- 1 root video 81, 0 Jul 29 17:41 video0
crw-rw---- 1 root video 81, 1 Jul 29 17:41 video1
crw-rw---- 1 root video 81, 2 Jul 29 17:41 video2
crw-rw---- 1 root video 81, 3 Jul 29 17:41 video3
suse-left:/dev #



 

 

 

________________________________________

George Leonard  | Senior Sales Consultant -- Core & HA Database 
Technology Architecture - MRD

Phone + 27.11.319 4304 | FAX +27.11.319 4600 | Mobile +27.82 655 2466

Oracle Technology Sale Consulting

eMail: george.leonard@oracle.com

-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
