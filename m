Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0PLOnqf027211
	for <video4linux-list@redhat.com>; Sun, 25 Jan 2009 16:24:49 -0500
Received: from smtp-out3.blueyonder.co.uk (smtp-out3.blueyonder.co.uk
	[195.188.213.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0PLOX09010221
	for <video4linux-list@redhat.com>; Sun, 25 Jan 2009 16:24:33 -0500
Received: from [172.23.170.141] (helo=anti-virus02-08)
	by smtp-out3.blueyonder.co.uk with smtp (Exim 4.52)
	id 1LRCT2-00020R-U9
	for video4linux-list@redhat.com; Sun, 25 Jan 2009 21:24:32 +0000
Received: from [82.46.193.134] (helo=[82.46.193.134])
	by asmtp-out1.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1LRCT2-0000vq-Em
	for video4linux-list@redhat.com; Sun, 25 Jan 2009 21:24:32 +0000
Message-ID: <497CD894.7070101@blueyonder.co.uk>
Date: Sun, 25 Jan 2009 21:24:36 +0000
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Capturing to AVI using streamer
Reply-To: ian.davidson@bigfoot.com
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

I used to capture video to AVI format using streamer on a single 
processor system running Fedora Core 4.  I would set up streamer to run 
for 40 minutes - but at a convenient time stop streamer using Ctrl-C 
(according to the documentation) and the AVI file would be 'wrapped up' 
nicely.  I could take the AVI file to a Windows machine and edit the 
captured video.

I am now using streamer as before but on a dual processor system running 
Fedora 9.  I get an AVI file but some editing software is unable to find 
the video stream.

Is this a problem caused by a) the change of hardware or b) the change 
of software?

Ian

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
