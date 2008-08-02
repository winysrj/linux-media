Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72Ax16G017067
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 06:59:01 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72AwnEd026041
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 06:58:49 -0400
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id DB35132A6F0
	for <video4linux-list@redhat.com>;
	Sat,  2 Aug 2008 12:58:48 +0200 (CEST)
Received: from velvet (mur31-2-82-243-122-54.fbx.proxad.net [82.243.122.54])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 99A7632A851
	for <video4linux-list@redhat.com>;
	Sat,  2 Aug 2008 12:58:48 +0200 (CEST)
To: video4linux-list@redhat.com
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 02 Aug 2008 12:58:47 +0200
Message-ID: <87hca34ra0.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [RFC] soc_camera: endianness between camera and its host
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

Modern camera chips provide ways to invert their data output, as well in colors
swap as in byte order. To be more precise, the one I know (mt9m111) enables :
 - swapping Red and Blue in RGB formats
 - swapping first and second byte in RGB formats
 - swapping Cb and Cr in YUV formats
 - swapping chrominance and luminance in YUV formats

This swap is necessary to adapt the camera chip output to the capture
interface. For example, pxa_camera on pxa27x CPUs expects RGB and YUV formats
in a very specific order. This order is not the default one on mt9m111 chip, so
the mt9m111 driver has to have a way to know how to order its output.

The question I have is where to put such information, so that board specific
code (arch/arm/mach-pxa/xxx.c) can setup this for a dedicated camera chip ?

One easy way would be to put it in soc_camera_link, but is it the right place ?

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
