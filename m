Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1BDAnuB007624
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 08:10:49 -0500
Received: from smtp-out3.blueyonder.co.uk (smtp-out3.blueyonder.co.uk
	[195.188.213.6])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1BDAQLl025705
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 08:10:26 -0500
Received: from [172.23.170.144] (helo=anti-virus03-07)
	by smtp-out3.blueyonder.co.uk with smtp (Exim 4.52)
	id 1JOYQT-0008Gn-JE
	for video4linux-list@redhat.com; Mon, 11 Feb 2008 13:10:25 +0000
Received: from [82.47.98.230] (helo=[192.168.10.10])
	by asmtp-out1.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1JOYQT-0003QM-3P
	for video4linux-list@redhat.com; Mon, 11 Feb 2008 13:10:25 +0000
Message-ID: <47B04940.2070706@blueyonder.co.uk>
Date: Mon, 11 Feb 2008 13:10:24 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
MIME-Version: 1.0
To: Video 4 Linux Mailing List <video4linux-list@redhat.com>
References: <47AF8BE4.80001@lockie.ca>
In-Reply-To: <47AF8BE4.80001@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: OV511 driver in linux-2.6.24.1
Reply-To: sboyce@blueyonder.co.uk
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

James Lockie wrote:
> I am trying to compile a new kernel but I can't find the OV511 driver.
> 
> -- 
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 

Unless it was temporarily dropped:-
/usr/src/linux-2.6.24-git22/drivers/media/video/ov511.c

# grep OV5 /usr/src/linux-2.6.24-git22/.config
CONFIG_USB_OV511=m

Depending on the type of camera, also check out
http://www.rastageeks.org/ov51x-jpeg/index.php/Ov51xJpegHackedSource
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
