Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ7Qrp7023694
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 02:26:53 -0500
Received: from smtp-out003.kontent.com (smtp-out003.kontent.com [81.88.40.217])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJ7Qdov002714
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 02:26:39 -0500
Received: from [192.168.178.22] (hlle-4db81efc.pool.einsundeins.de
	[77.184.30.252])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: foopara_de_004@smtp-out.kontent.com)
	by smtp-out.kontent.com (Postfix) with ESMTP id 2788140015A0
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 08:26:37 +0100 (CET)
Message-ID: <494B4CAC.7070706@foopara.de>
Date: Fri, 19 Dec 2008 08:26:36 +0100
From: Norman Specht <nospam@foopara.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Subject: creating a new device
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

Hi,

i'm trying to develop a image preprocessor which takes the image from a
webcam (e.g /dev/video0), modifies it and render it to a second
device (e.g /dev/myVideo0).

Grabbing the picture from the webcam isn't the problem but my problem is: How can i create a device which behaves like a webcam?

I'm running a ubuntu 8.10, and i tried including the kernel headers (media/v4l2-common.h, etc.) in many different ways to make my g++ compile my program. Is there some special way to do this?

Bye

Norman Specht

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
