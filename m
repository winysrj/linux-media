Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45D2ikP003596
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 09:02:44 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m45D2KR3028738
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 09:02:20 -0400
Message-ID: <481F0558.2020106@hni.uni-paderborn.de>
Date: Mon, 05 May 2008 15:02:16 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0805051422170.5648@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0805051422170.5648@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [Q] cross-compiling from mercurial sources
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

Guennadi Liakhovetski schrieb:
> Hi, how is one supposed to cross-compile v4l drivers from the mercurial 
> sources? After looking at v4l/Makefile I tried "make ARCH=... 
> CROSS_COMPILE=... SRCDIR=<path-to-kernel>", but it didn't work very well - 
> lots of redefines, and it tried to compile all drivers, which cannot work 
> either, since, e.g., this platform (arm) doesn't have PCI.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>   
Hi,

I first used menuconfig to select the drivers and then set dot-config=1

Regards
    Stefan

-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Heinz Nixdorf Institute
University of Paderborn 
System and Circuit Technology 
Fürstenallee 11
D-33102 Paderborn (Germany)

office : F0.415
phone  : + 49 5251 - 60 6342
fax    : + 49 5251 - 60 6351

mailto : hbmeier@hni.upb.de

www    : http://wwwhni.upb.de/sct/mitarbeiter/hbmeier


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
