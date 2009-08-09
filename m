Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n79IAWYF000754
	for <video4linux-list@redhat.com>; Sun, 9 Aug 2009 14:10:32 -0400
Received: from mail-bw0-f209.google.com (mail-bw0-f209.google.com
	[209.85.218.209])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n79I9nZJ004345
	for <video4linux-list@redhat.com>; Sun, 9 Aug 2009 14:09:50 -0400
Received: by bwz5 with SMTP id 5so957476bwz.3
	for <video4linux-list@redhat.com>; Sun, 09 Aug 2009 11:09:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090807191809.GJ5842@pengutronix.de>
References: <eedb5540908060552n43021d5bla6ee655c294307eb@mail.gmail.com>
	<20090807191809.GJ5842@pengutronix.de>
Date: Sun, 9 Aug 2009 14:09:49 -0400
Message-ID: <9319940908091109l64530b9cgd2e305ea8127a35a@mail.gmail.com>
From: Derek Bouius <dbouius@gmail.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

On Fri, Aug 7, 2009 at 3:18 PM, Robert
Schwebel<r.schwebel@pengutronix.de> wrote:
> On Thu, Aug 06, 2009 at 02:52:31PM +0200, javier Martin wrote:
>> we are trying to develop a soc-camera host driver for the i.MX27 cpu
>> and include it in mainline kernel.
>> We have read that there is an out-of-tree patch for this. Maybe if
>> someone could point us to it we could use as a base for our
>> development.
>
> We have a driver for the phyCORE-i.MX27 board:
> http://git.pengutronix.de/?p=phytec/linux-2.6.git;a=blob;f=drivers/media/video/mx27_camera.c;h=9e9f4426c3db890e6fc13130e047c65c073aa0b4;hb=refs/heads/phytec-master
I have just used this driver to interface to a soc imager (Aptina
mt9p031) on the phyCORE-i.MX27 board. It works for acquiring a 640x480
video stream quite reliably. I am currently working on getting it to
be able to capture a full image frame (5MB) as well as various image
sizes in between. I am running into out of memory issues with the
dma_alloc_coherent() and not sure what the solution is yet.

Derek

>
> Sascha, can you comment on the status regarding mainline?
>
> rsc
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
