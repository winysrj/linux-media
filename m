Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9NCAFGH021758
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 08:10:15 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9NCA1Wf030904
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 08:10:02 -0400
Message-ID: <49006A60.3090906@hhs.nl>
Date: Thu, 23 Oct 2008 14:13:20 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: libv4l release: 0.5.2
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

<and once more with the correct subject, sorry for the spam>

Hi All,

Nothing special just a small bugfix release mainly fixing some bad interactions
between the pwc driver and libv4l (due to pwc driver bugs). More in general
this release makes libv4l more robust against drivers who promise they can
handle foo when calling try_fmt and then actually give you bar when you do a s_fmt.

libv4l-0.5.2
------------
* Add Philips SPC210NC to list of cams with upside down sensor, reported by
   Rieker Flaik
* Work around some drivers (pwc) not properly reflecting what one gets after a
   s_fmt in their try_fmt answer
* Check that s_fmt atleast gives us the width, height and pixelformat try_fmt
   promised us, and if not disable conversion
* Only check width, height and pixelformat when checking if we are doing
   conversion, instead of doing a memcmp, as that are the only things which
   the convert code checks
* Take into account that the buffers only contain half of the lines when
   field is V4L2_FIELD_ALTERNATE

Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.2.tar.gz

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
