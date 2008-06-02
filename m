Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m527eQVq009619
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 03:40:26 -0400
Received: from web50208.mail.re2.yahoo.com (web50208.mail.re2.yahoo.com
	[206.190.38.49])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m527e8pV003403
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 03:40:09 -0400
Date: Mon, 2 Jun 2008 00:40:02 -0700 (PDT)
From: Fabrice Nansi <fabricenansi@yahoo.com>
To: Gilles GIGAN <gilles.gigan@gmail.com>, video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <33802.59481.qm@web50208.mail.re2.yahoo.com>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re : Detecting webcam unplugging
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

Hi Gilles,

----- Message d'origine ----
> De : Gilles GIGAN <gilles.gigan@gmail.com>
> À : video4linux-list@redhat.com
> Envoyé le : Lundi, 2 Juin 2008, 8h49mn 02s
> Objet : Detecting webcam unplugging
> 
> Hi all,
> I have written a small app which uses V4L1 & V4L2 to do streaming captures
> from video sources (mostly webcams).
> Capture works perfectly. However, if a webcam is unplugged during the
> capture, the app hangs on ioctl(VIDIOCSYNC) if the source uses a V4L1 driver
> whereas, for V4L2, the ioctl(VIDIOC_DQBUF) fails instead of just hanging.
> So, is there a reliable way to detect when a V4L1 video source has become
> unavailable ?
> I tested my app with the following V4L1 drivers:
> gspca (01.00.20) and qc-usb (0.6.6)
> 
> Thanks,
> Gilles
> --

You can solve your problem using the HAL daemon (http://www.freedesktop.org/wiki/Software/hal).
The HAL library provides 2 callbacks LibHalDeviceAdded and LibHalDeviceRemoved and a function libhal_device_property_watch_all() that you can use.

Regards.
Fabrice


__________________________________________________
Do You Yahoo!?
En finir avec le spam? Yahoo! Mail vous offre la meilleure protection possible contre les messages non sollicités 
http://mail.yahoo.fr Yahoo! Mail 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
