Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7QFtMVa006256
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 11:55:22 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7QFsiBe012997
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 11:55:03 -0400
Message-ID: <48B429D9.7000900@hhs.nl>
Date: Tue, 26 Aug 2008 18:05:45 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Announcing libv4l 0.4.1
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

Some assorted fixes, and support for Pixart cams JPEG's (which are non standard 
JPEG's) together with some gspca kernel changes this means that we now have 
working pac7302 and pac7311 webcams!

Go grab the new release here
http://people.atrpms.net/~hdegoede/libv4l-0.4.1.tar.gz

Full list of changes:

libv4l-0.4.1
------------
* When the driver supports read() and we are not converting let the driver
   handle read() instead of emulating it with mmap mode
* Fix errors and warnings when compiling with ICC (Gregor Jasny)
* Add support to libv4lconvert for rotating images 90 (for Pixart 7302 cams)
   or 180 (Philips SPC200NC / Philips SPC300NC) degrees
* Add support for Pixart custom JPEG format
* Hide non public symbols (Gregor Jasny)
* Fix and enable x86_64 asm jpeg decompress helper functions (Gregor Jasny)

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
