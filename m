Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3Di4kk020250
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 08:44:04 -0500
Received: from tomts31-srv.bellnexxia.net (tomts31.bellnexxia.net
	[209.226.175.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3Di1la025704
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 08:44:01 -0500
Received: from toip41-bus.srvr.bell.ca ([67.69.240.42])
	by tomts31-srv.bellnexxia.net
	(InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP id
	<20081203134356.CBNZ1756.tomts31-srv.bellnexxia.net@toip41-bus.srvr.bell.ca>
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 08:43:56 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 3 Dec 2008 08:43:33 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB101208170EDF1510@Colmatec004.COLMATEC.INT>
In-Reply-To: <200812021820.21645.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: V4L2 PIXEL buffer conversion
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

About processing some frames from

static void process_image (const void * p, unsigned int size)

I did some conversion from
const void * p TO char *

to treat buffers.

But I would like opinion about conversion from :

const void * p TO int []

because I am using a JNI entry point for my V4L2 C and would like to compare values between 0-255

but if u do something like

char 4 - char 5

this will not turn -1

this will turn 255.

And inside java I don't want to cast values and prefer to work with proper int types.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
