Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8NIVAZj008008
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 14:31:10 -0400
Received: from d1.scratchtelecom.com (69.42.52.179.scratchtelecom.com
	[69.42.52.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8NIUNwf023352
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 14:30:51 -0400
Received: from vegas (CPE00a02477ff82-CM001225d885d8.cpe.net.cable.rogers.com
	[99.249.154.65])
	by d1.scratchtelecom.com (8.13.8/8.13.8/Debian-3) with ESMTP id
	m8NIUMsk014868
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 14:30:22 -0400
Received: from lawsonk (helo=localhost)
	by vegas with local-esmtp (Exim 3.36 #1 (Debian)) id 1KiCeR-0000qG-00
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 14:30:19 -0400
Date: Tue, 23 Sep 2008 14:30:18 -0400 (EDT)
From: Keith Lawson <lawsonk@lawson-tech.com>
To: video4linux-list@redhat.com
In-Reply-To: <e1077a62ea0e09bf49282395ebcefe75.squirrel@www.lockie.ca>
Message-ID: <alpine.DEB.1.10.0809231428180.1930@vegas>
References: <alpine.DEB.1.10.0809231317360.1930@vegas>
	<e1077a62ea0e09bf49282395ebcefe75.squirrel@www.lockie.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Subject: Re: TM6010/TM5600 firmware file(s)
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



On Tue, 23 Sep 2008, James wrote:

> On Tue, September 23, 2008 1:20 pm, Keith Lawson wrote:
>> Hello,
>>
>>
>> I've searched high and low for firmware files or tridvid.sys to work
>> witha tm5600 chipset capture card I have and have not been able to find
>> the firmware or the Windows driver. Can anyone point me in the right
>> direction to find the firmware that will work with Mauro's tm6010 module?
>>
>> Thanks,
>> Keith.
> http://driverscollection.com/?H=Trident TM5600 USB TV&By=Chronos
>>

Ah, thank you! I've been pulling my hair out trying to find that driver.

I was able to get the firmware out using dd commands from 
http://www.linuxtv.org/v4lwiki/index.php/Trident_TM6000. I'll test the 
when I get home tonight.

Out of curiosity how does one determine the "skip" and "count" parameters 
for dd to extract the firmware?

Keith.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
