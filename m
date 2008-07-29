Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TLqeqU006867
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 17:52:40 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TLqQec017497
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 17:52:27 -0400
Message-ID: <488F9320.8050202@hhs.nl>
Date: Wed, 30 Jul 2008 00:01:04 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Announcing libv4l 0.3.8
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

Hi All,

Here is release 0.3.8:
http://people.atrpms.net/~hdegoede/libv4l-0.3.8.tar.gz

This release has the following changes (some small tweaks left and right for 
more to the spec behavior, none of this fixes any known bugs).

libv4l-0.3.8
------------
* work around wrong REQUEST_BUFFERS ioctl return code from certain drivers
* add pkg-config (.pc) files for easier detection if libv4l is available
* check capabilities for streaming, if the driver cannot do streaming don't
   insert ourselves between the application and the driver
* intercept get capabilites and report read capability (which we always offer)
* query buffer: indicate the mapping state of our (fake) buffer in the flags

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
