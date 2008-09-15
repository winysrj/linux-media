Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8FBkpji019577
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 07:46:52 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8FBkeLE030252
	for <video4linux-list@redhat.com>; Mon, 15 Sep 2008 07:46:40 -0400
Message-ID: <48CE4B24.30902@hhs.nl>
Date: Mon, 15 Sep 2008 13:46:44 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: libv4l release: 0.5.0
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

libv4l-0.5.0
------------
* Add support for enumerating framesizes and frameintervals of emulated
   formats when the driver supports it for the real format
* Make sure the video device always gets opened RW even if the application
   asks for RO
* Add Genius E-Messenger 112 (093a:2476) to list of cams which have their
   sensor upside down

Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.0.tar.gz

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
