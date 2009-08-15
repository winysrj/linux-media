Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7FLoScA017834
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 17:50:28 -0400
Received: from smtp.bluecom.no (smtp.bluecom.no [193.75.75.28])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7FLo9Y7026783
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 17:50:09 -0400
Received: from localhost.localdomain (c7F6F47C1.dhcp.bluecom.no
	[193.71.111.127])
	by smtp.bluecom.no (Postfix) with ESMTP id 4180910D6DFB
	for <video4linux-list@redhat.com>;
	Sat, 15 Aug 2009 23:48:13 +0200 (CEST)
Message-ID: <4A872D3F.6020003@ntnu.no>
Date: Sat, 15 Aug 2009 23:48:47 +0200
From: Haavard Holm <haavard.holm@ntnu.no>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Varying frame rate
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


Hello,

  I am writing an application that capture video/pictures from a webcam.
My program is built on moinejf.free.fr/*svv*.*c*
which again is built on v4l2spec.bytesex.org/v4l2spec/*capture*.*c*

OS is linux 2.6.29.6-217.2.3.fc11.x86_64
Webcam is "Logitech Quickcam Pro for Notebooks" (046d:0991)

My obeservation is : Depending on what my camera focus on, the framerate
varies from 5 to 15 fps. I have tried several times, same result.

Why is that. How can I avoid this ?

Best regards

Håvard Holm

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
