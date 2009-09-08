Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n88Hug44007087
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 13:56:42 -0400
Received: from homiemail-a11.g.dreamhost.com (caiajhbdcaib.dreamhost.com
	[208.97.132.81])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n88HuPUg028222
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 13:56:25 -0400
Message-ID: <4AA69AC6.8020103@swartzlander.org>
Date: Tue, 08 Sep 2009 13:56:22 -0400
From: Ben Swartzlander <ben@swartzlander.org>
MIME-Version: 1.0
To: rray_1@comcast.net
References: <alpine.LRH.2.00.0909081237170.4833@rray2>
In-Reply-To: <alpine.LRH.2.00.0909081237170.4833@rray2>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: NTSC/ATSC device recommendation
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

rray_1@comcast.net wrote:
> I would like to purchase a NTSC/ATSC device that is functional under 
> Linux
> MY only requirement is receiving FTA broadcast
> Would y'all recommend a USB device or better to stick with a pci device
> I have followed this list and have only become more confused
>
> Thanks
> Richard

I have 2 Hauppauge WinTV-HVR-850 USB sticks in my MythTV box (Ubuntu 
8.04). USB is preferable to PCI for all kinds of reasons. I bought mine 
here: http://www.newegg.com/Product/Product.aspx?Item=N82E16815116031

Note that if you go with this device, you'll need to manually add the 
firmware to your /lib/firmware directory. You can get the firmware here: 
http://www.steventoth.net/linux/xc5000/

There are plenty of other supported devices though. When I was doing my 
research, this page was an extremely useful resource for Linux ATSC 
hardware: http://www.linuxtv.org/wiki/index.php/ATSC_Devices

-Ben

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
