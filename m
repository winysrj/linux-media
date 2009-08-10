Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7A6xhRH025791
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 02:59:43 -0400
Received: from mail-ew0-f208.google.com (mail-ew0-f208.google.com
	[209.85.219.208])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7A6xOt3017933
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 02:59:25 -0400
Received: by ewy4 with SMTP id 4so1675187ewy.3
	for <video4linux-list@redhat.com>; Sun, 09 Aug 2009 23:59:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9319940908091109l64530b9cgd2e305ea8127a35a@mail.gmail.com>
References: <eedb5540908060552n43021d5bla6ee655c294307eb@mail.gmail.com>
	<20090807191809.GJ5842@pengutronix.de>
	<9319940908091109l64530b9cgd2e305ea8127a35a@mail.gmail.com>
Date: Mon, 10 Aug 2009 08:59:23 +0200
Message-ID: <eedb5540908092359g27e61389wad4a918f3339ae38@mail.gmail.com>
From: javier Martin <javier.martin@vista-silicon.com>
To: Derek Bouius <dbouius@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Sascha Hauer <sha@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera driver for i.MX27
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

Dear Derek,

>> We have a driver for the phyCORE-i.MX27 board:
>> http://git.pengutronix.de/?p=phytec/linux-2.6.git;a=blob;f=drivers/media/video/mx27_camera.c;h=9e9f4426c3db890e6fc13130e047c65c073aa0b4;hb=refs/heads/phytec-master

Thank you for the pointer to the patch.

> I have just used this driver to interface to a soc imager (Aptina
> mt9p031) on the phyCORE-i.MX27 board. It works for acquiring a 640x480
> video stream quite reliably. I am currently working on getting it to
> be able to capture a full image frame (5MB) as well as various image
> sizes in between. I am running into out of memory issues with the
> dma_alloc_coherent() and not sure what the solution is yet.
>

Maybe you are requesting too much contiguous memory. I don't remember
where that could be changed.

Try also preallocating DMA buffer at init function, we have found
similar problems in the past using Freescale's BSP.

> Derek
>
>>
>> Sascha, can you comment on the status regarding mainline?
>>
>> rsc


-- 
Javier Martin
Vista Silicon S.L.
Universidad de Cantabria
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
