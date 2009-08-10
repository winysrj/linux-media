Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7A6q9wS022464
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 02:52:09 -0400
Received: from mail-ew0-f208.google.com (mail-ew0-f208.google.com
	[209.85.219.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7A6ponv007091
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 02:51:50 -0400
Received: by ewy4 with SMTP id 4so1672516ewy.3
	for <video4linux-list@redhat.com>; Sun, 09 Aug 2009 23:51:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090807192045.GK5842@pengutronix.de>
References: <eedb5540908060842rb7e2ac7g920310563fa8ddb4@mail.gmail.com>
	<20090807192045.GK5842@pengutronix.de>
Date: Mon, 10 Aug 2009 08:51:49 +0200
Message-ID: <eedb5540908092351v7b46b392i1a3c697a906c87dd@mail.gmail.com>
From: javier Martin <javier.martin@vista-silicon.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: H.264 format support?
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

2009/8/7 Robert Schwebel <r.schwebel@pengutronix.de>:
> On Thu, Aug 06, 2009 at 05:42:12PM +0200, javier Martin wrote:
>> I have been reading formats supported in V4L2 api and I haven't found
>> H.264 in compressed formats.
>>
>> Do you plan to add a define for this format? If not what would be the
>> problem with it?
>
> If I remember correctly, Freescale has H.264 encoding in the same
> package that also contains MPEG4 stuff, both as gstreamer plugins.
>

Yes, I know Freescale has it integrated in the same package, but the
truth is that in V4L2 there is no definition for H264 output format.
That makes a little difficult for a driver which outputs H.264 to
enter mainline kernel. That is why I am asking for an H.264 output
format definition..

See V4L2 API spec:
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#AEN5634


> Check how it is integrated in OSELAS.Phytec-phyCORE-12-1:
> http://www.pengutronix.de/oselas/bsp/phytec/download/phyCORE/OSELAS.BSP-Phytec-phyCORE-12-1.tar.gz

Thank you for the link, I will take a look at it.

>
> rsc
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>



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
