Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0M7HISx003556
	for <video4linux-list@redhat.com>; Fri, 22 Jan 2010 02:17:18 -0500
Received: from becar.it (93-63-175-90.ip28.fastwebnet.it [93.63.175.90])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0M7H266008736
	for <video4linux-list@redhat.com>; Fri, 22 Jan 2010 02:17:03 -0500
Received: from [192.168.100.14] ([192.168.100.14]) by becar.it (becar.it)
	(MDaemon PRO v10.1.2) with ESMTP id md50000113590.msg
	for <video4linux-list@redhat.com>; Fri, 22 Jan 2010 08:16:58 +0100
Message-ID: <4B5950BE.6060501@becar.it>
Date: Fri, 22 Jan 2010 08:16:14 +0100
From: Fabrizio Bandiera <fabrizio.bandiera@becar.it>
MIME-Version: 1.0
To: Cristiana Tenti <cristenti@gmail.com>
Subject: Re: streamer
References: <13c9a3ca1001211916n558736e9ic8dc17f4dfe99d37@mail.gmail.com>
In-Reply-To: <13c9a3ca1001211916n558736e9ic8dc17f4dfe99d37@mail.gmail.com>
Cc: video4linux-list@redhat.com
Reply-To: fabrizio.bandiera@becar.it
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dear Cristiana,

only a warning for you.

You must have the right speed on USB and also very fast acquire library.

First of all, please check if your USB platform is USB2.0

If you don't have USB 2.0 in your embedded target board you cannot grab 
anything from your cam: there isn't enought throughput

I had the same problem some months ago and i didn't realize why it 
wasn't working.

If you only need to grab a still image i can send a very simple software 
to you that you can cross-compile for your platform.

It's based on V4L standard (so you need such library for your embedded 
platform) and, of course, you need the driver for your USB cam

Bye

Fabrizio

Cristiana Tenti ha scritto:
> Hello,
> I'm a new user :)
>
> I'm working on a simple project and for that I only need to a software for
> uclinux to acquire a raw image from my usb webcam.
> On Ubuntu I'm using STREAMER but I cannot find the source code to install it
> on my uclinux platform.
>
> Anyway I found xawtv and I saw that this usefull software has as tool
> STREAMER.
>
> Do you know if it is possible compile only streamer and not all package of
> xawtv?
>
> Please, if you can help me answer me!!!
>
> Thank you in advance,
>
> Best Regards
>
>   

-- 
--------------------------------------------------

Ing. Fabrizio BANDIERA

SW Manager

Becar srl (gruppo BEGHELLI)
Viale della Pace 1
40050 Monteveglio (Bologna)

Tel.  051-6702242
Fax   051-6702186
Cell. 335-7000409



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
