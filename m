Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n02K3ujX010292
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 15:03:56 -0500
Received: from mho-01-bos.mailhop.org (mho-01-bos.mailhop.org [63.208.196.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n02K3flZ006142
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 15:03:42 -0500
Received: from c-65-96-52-55.hsd1.vt.comcast.net ([65.96.52.55]
	helo=homer.edgehp.net)
	by mho-01-bos.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <DEPontius@edgehp.net>)
	id 1LIqFA-0008di-ER
	for video4linux-list@redhat.com; Fri, 02 Jan 2009 20:03:40 +0000
Received: from [192.168.154.40] (anastasia.edgehp.net [192.168.154.40])
	by homer.edgehp.net (Postfix) with ESMTP id 6258914CDD
	for <video4linux-list@redhat.com>; Fri,  2 Jan 2009 15:03:39 -0500 (EST)
Message-ID: <495E7328.6080600@edgehp.net>
Date: Fri, 02 Jan 2009 15:03:52 -0500
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: cx18 short-term resource available
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

Every now and then I fix my sister-in-law an her husband's computer, and 
every now and then they give me their cast-offs.  I also have 2 HVR-1600 
cards and 2 SA4250C set-top boxes, only 1 of each in active use.  So for 
a few months, I can bring back online a spare system, and can use some 
spare time to assist.  I'll have to reinstall the machine, but it has a 
valid XP-Home license, and can easily be made dual-boot.

So I have:
Dell Dimension 2300, HVR2300, SA4250C, and can temporarily dedicate all 
of this hardware to assist developers.  I know cx18 work seems to be 
proceeding quite well on its own, but I also know that the IR blaster 
seems to need work.  If I can be of assistance, please let me know.  I 
can join the LIRC list, if appropriate.

Related, to Andy Walls,
A few months back you were helping me, we couldn't find my tuner, and I 
was essentially nowhere without that.  I took both HVR-1600 cards over 
to a friend's house, and we plugged them into a WinXP machine, installed 
drivers, and also got nowhere with either card.

I brought them home, plugged the second (the one I hadn't tried, yet) 
card into my machine, and it was fully functional.  Then I plugged in 
the first, and it was fully functional, as well.  In the past week I 
read more, and learned how to scan for ATSC stations, and so far have 
only QVC, but that's enough to verify that that side of one of the cards 
works.  (I'll have to replug to test the ATSC on the other card, and 
I've been leaving my hardware alone during the cold - and staticy snap.)

Anyway, both cards work, I don't know if it was that they touched a 
Windows machine and some secret bits got flipped by the Windows driver, 
or if all I needed was a simple replug in the first place.

Question:
Under MythTV, the HVR-1600 seems - fuzzy.  My main card, a PixelPro, 
seems sharper, though there are more artifacts in the video, also.  The 
HVR-1600 seems cleaner, just fuzzy.  However, when I look at the 
HVR-1600 video at native resolution, it seems quite good and the 
fuzziness appears to be gone.

Do you know if this an artifact of how MythTV scales video to 
fullscreen, or if there is something in the settings I should tweak?  I 
have noticed that MythTV captures on the PixelPro at 480x480 by default, 
and at that resolution HVR-1600 captures are less than half the file 
size.  Changing the HVR-1600 captures to 720x480 improves things 
somewhat, and the files are still smaller.

Thanks,
Dale Pontius

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
