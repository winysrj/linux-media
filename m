Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ7TmLK024463
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 02:29:48 -0500
Received: from mx7.orcon.net.nz (mx7.orcon.net.nz [219.88.242.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJ7TXxR003927
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 02:29:33 -0500
Received: from Debian-exim by mx7.orcon.net.nz with local (Exim 4.69)
	(envelope-from <lennon@orcon.net.nz>) id 1LDZng-0003a0-CX
	for video4linux-list@redhat.com; Fri, 19 Dec 2008 20:29:32 +1300
From: Craig Whitmore <lennon@orcon.net.nz>
To: Norman Specht <nospam@foopara.de>
In-Reply-To: <494B4CAC.7070706@foopara.de>
References: <494B4CAC.7070706@foopara.de>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 20:29:31 +1300
Message-Id: <1229671771.25835.99.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: creating a new device
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

On Fri, 2008-12-19 at 08:26 +0100, Norman Specht wrote:
> Hi,
> 
> i'm trying to develop a image preprocessor which takes the image from a
> webcam (e.g /dev/video0), modifies it and render it to a second
> device (e.g /dev/myVideo0).
> 
> Grabbing the picture from the webcam isn't the problem but my problem is: How can i create a device which behaves like a webcam?
> 
> I'm running a ubuntu 8.10, and i tried including the kernel headers (media/v4l2-common.h, etc.) in many different ways to make my g++ compile my program. Is there some special way to do this?

google for dvbloopback..

Thanks


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
