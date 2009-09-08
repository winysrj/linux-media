Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n88IMNKW006291
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 14:22:23 -0400
Received: from mail-bw0-f209.google.com (mail-bw0-f209.google.com
	[209.85.218.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n88IM6gB032089
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 14:22:06 -0400
Received: by bwz5 with SMTP id 5so2807046bwz.3
	for <video4linux-list@redhat.com>; Tue, 08 Sep 2009 11:22:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA69AC6.8020103@swartzlander.org>
References: <alpine.LRH.2.00.0909081237170.4833@rray2>
	<4AA69AC6.8020103@swartzlander.org>
Date: Tue, 8 Sep 2009 14:22:04 -0400
Message-ID: <829197380909081122r70f857bbr2b4369a2ab8d91f5@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ben Swartzlander <ben@swartzlander.org>
Content-Type: text/plain; charset=ISO-8859-1
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

On Tue, Sep 8, 2009 at 1:56 PM, Ben Swartzlander<ben@swartzlander.org> wrote:
> rray_1@comcast.net wrote:
>>
>> I would like to purchase a NTSC/ATSC device that is functional under Linux
>> MY only requirement is receiving FTA broadcast
>> Would y'all recommend a USB device or better to stick with a pci device
>> I have followed this list and have only become more confused
>>
>> Thanks
>> Richard
>
> I have 2 Hauppauge WinTV-HVR-850 USB sticks in my MythTV box (Ubuntu 8.04).
> USB is preferable to PCI for all kinds of reasons. I bought mine here:
> http://www.newegg.com/Product/Product.aspx?Item=N82E16815116031
>
> Note that if you go with this device, you'll need to manually add the
> firmware to your /lib/firmware directory. You can get the firmware here:
> http://www.steventoth.net/linux/xc5000/
>
> There are plenty of other supported devices though. When I was doing my
> research, this page was an extremely useful resource for Linux ATSC
> hardware: http://www.linuxtv.org/wiki/index.php/ATSC_Devices
>
> -Ben

I'm really familiar with the HVR-850, and figured it would be worth
mentioning that the HVR-850 only very recently got analog support in
the Linux driver, and it has some issues with MythTV in particular
(which I haven't had a chance to fix yet).  So if you're planning on
doing analog with MythTV, that may not be a good device to go with
right now.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
