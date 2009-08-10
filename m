Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7ACFNXb019345
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 08:15:23 -0400
Received: from mail-fx0-f205.google.com (mail-fx0-f205.google.com
	[209.85.220.205])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7ACF6T9012348
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 08:15:06 -0400
Received: by fxm1 with SMTP id 1so2106340fxm.7
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 05:15:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090810072513.GL6108@pengutronix.de>
References: <eedb5540908060552n43021d5bla6ee655c294307eb@mail.gmail.com>
	<20090807191809.GJ5842@pengutronix.de>
	<9319940908091109l64530b9cgd2e305ea8127a35a@mail.gmail.com>
	<eedb5540908092359g27e61389wad4a918f3339ae38@mail.gmail.com>
	<20090810072513.GL6108@pengutronix.de>
Date: Mon, 10 Aug 2009 08:15:05 -0400
Message-ID: <9319940908100515w21d38a5bs6c6a552b07498fc4@mail.gmail.com>
From: Derek Bouius <dbouius@gmail.com>
To: Sascha Hauer <sha@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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

On Mon, Aug 10, 2009 at 3:25 AM, Sascha Hauer<sha@pengutronix.de> wrote:
> Hi,
>
> On Mon, Aug 10, 2009 at 08:59:23AM +0200, javier Martin wrote:
>> Dear Derek,
>>
>> >> We have a driver for the phyCORE-i.MX27 board:
>> >> http://git.pengutronix.de/?p=phytec/linux-2.6.git;a=blob;f=drivers/media/video/mx27_camera.c;h=9e9f4426c3db890e6fc13130e047c65c073aa0b4;hb=refs/heads/phytec-master
>>
>> Thank you for the pointer to the patch.
>>
>> > I have just used this driver to interface to a soc imager (Aptina
>> > mt9p031) on the phyCORE-i.MX27 board. It works for acquiring a 640x480
>> > video stream quite reliably. I am currently working on getting it to
>> > be able to capture a full image frame (5MB) as well as various image
>> > sizes in between. I am running into out of memory issues with the
>> > dma_alloc_coherent() and not sure what the solution is yet.
>> >
>>
>> Maybe you are requesting too much contiguous memory. I don't remember
>> where that could be changed.
>
> It's CONSISTENT_DMA_SIZE.
>
That did the trick.
Thanks, Derek


> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
