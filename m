Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB2MdBdZ026899
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 17:39:11 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB2McniY024441
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 17:38:50 -0500
Message-ID: <4935BA81.7010007@hhs.nl>
Date: Tue, 02 Dec 2008 23:45:21 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: libv4l release: 0.5.6 (The fix "the UVC release" release)
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

So after 2 days of debugging (many thanks for the patience of all reporters and 
for all the tests they have run) I've finally managed to pinpoint and fix a 
nasty (and stupid, completely my fault) bug in the special try_fmt handling for 
uvc cams.

This bug is present in the 0.5.5 and 0.5.6 releases every one is urged to 
upgrade to 0.5.7 asap!

The problem is that the enumframesize results try_fmt replacement for uvccams 
was dependend upon the enumframesize results being sorted in a particular 
order, which happened to be the case with my test cam.

This was causing issues with quite a few uvc cams, this release fixes this.

libv4l-0.5.7
------------
* Fix a nasty (and stupid) bug in the special try_fmt handling for UVC cams
* Add some more verbose logging of various calls when asking libv4l to log
   calls to a file, to assist in (future) debugging

Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.7.tar.gz

Regards,

Hans




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
