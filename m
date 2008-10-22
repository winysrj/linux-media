Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9MK8Vqj026105
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 16:08:31 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9MK8CI7024559
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 16:08:12 -0400
Received: by ti-out-0910.google.com with SMTP id 24so1670855tim.7
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 13:08:11 -0700 (PDT)
Message-ID: <65b651b40810221308g2642db2aq3f95d60b991cf375@mail.gmail.com>
Date: Thu, 23 Oct 2008 01:38:11 +0530
From: "Rakesh Peter" <raxpeter@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <65b651b40810201228k435cff91x58a67417eb0882c2@mail.gmail.com>
MIME-Version: 1.0
References: <65b651b40810201228k435cff91x58a67417eb0882c2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: TM5600/XC2028 based USB Tv Tuner
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

Hello there...

I've been trying to get my Enter Multimedia E-220U USB TV Tuner Stick up and
running in Linux. I've downloaded your dev-branch on the same from linuxtv
mercurial repository. But I'm yet to figure out how to go about extracting
the firmware from the device driver.

The driver file found in the CD is uploaded here:

http://www.esnips.com/doc/b042f5cd-1eca-4616-a875-5f7791eabd8d/e220u-driver

The photos of the device is available at:

http://www.flickr.com/photos/31592772@N04/

For lsusb, the device is showing up as

Bus 005 Device 007: ID 6000:560a

If you can provide me some idea on how to proceed with detecting and
extracting the firmware content, it will be great.

Awaiting your kind response...

Regards,

Rakesh Peter
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
