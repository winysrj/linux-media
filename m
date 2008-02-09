Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m19JDTiv031961
	for <video4linux-list@redhat.com>; Sat, 9 Feb 2008 14:13:29 -0500
Received: from smtp-out4.blueyonder.co.uk (smtp-out4.blueyonder.co.uk
	[195.188.213.7])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m19JD8cU018835
	for <video4linux-list@redhat.com>; Sat, 9 Feb 2008 14:13:08 -0500
Received: from [172.23.170.141] (helo=anti-virus02-08)
	by smtp-out4.blueyonder.co.uk with smtp (Exim 4.52)
	id 1JNv8N-0004Kk-Le
	for video4linux-list@redhat.com; Sat, 09 Feb 2008 19:13:07 +0000
Received: from [82.47.98.230] (helo=[192.168.10.10])
	by asmtp-out2.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1JNv8N-0006UA-9I
	for video4linux-list@redhat.com; Sat, 09 Feb 2008 19:13:07 +0000
Message-ID: <47ADFB42.7040503@blueyonder.co.uk>
Date: Sat, 09 Feb 2008 19:13:06 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>	<20080207173926.53b9e0ce@gaivota>	<1202421849.20032.25.camel@pc08.localdom.local>	<9c4b1d600802071528p70de4e55ud582ef66d9ebb3d7@mail.gmail.com>	<1202429587.20032.75.camel@pc08.localdom.local>	<9c4b1d600802080937h3dbbb388s9abb760feb084f4@mail.gmail.com>	<20080208163102.459d0efd@gaivota>
	<47ADE446.1030309@gmail.com>
In-Reply-To: <47ADE446.1030309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: PixelView PlayTV 405 DVD Maker
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

Claudinei Camargo wrote:
> Dear,
> 
> 
> I got the Mauro's tm6000 tree and compiled it against Ubuntu 2.6.22-rt,
> but when I load that module this message come up: xc2028 0-0061: Error:
> firmware tm6000-xc3028.fw not found.  tm6000_xc2028_firmware1.fw and
> tm6000_xc2028_firmware2.fw was put into /lib/firmware. the Readme.first
> says that get_firmware.pl is broken. where i can got that firmware?
> 
> Claudinei
> 
> --

The error says it's looking for a file named tm600-xc3028.fw, may be 
just renaming or copying each of the two files to that filename and 
seeing if one of them works.
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
