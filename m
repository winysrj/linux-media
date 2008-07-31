Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VJvYIx021689
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 15:57:34 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6VJvMIQ026441
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 15:57:22 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
	<878wvnkd8n.fsf@free.fr>
	<Pine.LNX.4.64.0807271337270.1604@axis700.grange>
	<87tze997uu.fsf@free.fr>
	<Pine.LNX.4.64.0807291902200.17188@axis700.grange>
	<87iqun2ge3.fsf@free.fr>
	<Pine.LNX.4.64.0807310008190.26534@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 31 Jul 2008 21:57:15 +0200
In-Reply-To: <Pine.LNX.4.64.0807310008190.26534@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu\,
	31 Jul 2008 00\:19\:26 +0200 \(CEST\)")
Message-ID: <87tze53jz8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Ok, you're suggesting to add suspend() and resume() to 
> soc_camera_bus_type, right? But are we sure that its resume will be called 
> after both camera (so far i2c) and host (so far platform, can also be PCI 
> or USB...) busses are resumed? If not, we might have to do something 
> similar to scan_add_host() / scan_add_device() - accept signals from the 
> host and the camera and when both are ready actually resume them...

As far as my comprehension goes for resume order :
 - mt9m111 is an i2c client, and so it will always be resumed after i2c bus
 driver
 - mt9m111 registers itself to the soc_camera bus, so soc_camera_bus will be
 resumed after mt9m111
 - pxa27-camera registers to soc_camera_host, so soc_camera_host will be resumed
 after pxa27-camera
 - I didn't check the link between soc_camera_host and soc_camera_bus, but if
 there is one, soc_camera bus is resumed last.

So, if I have it sorted out correctly, soc_camera_bus should hold the suspend()
and resume() functions, which will call icd->ops->suspend() and
icd->ops->resume().

I'm still investigating these points (under test ATM). It does work, but I still
haven't got the formal proof of the ordering ...

Would you by any chance have a little ascii art of all
camera/camera_host/camera_bus ... device graph ? A thing that could easily be
pushed into Documentation/video4linux/... ?

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
