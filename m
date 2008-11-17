Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAHIjNBE013930
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 13:45:23 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAHIjAH7029313
	for <video4linux-list@redhat.com>; Mon, 17 Nov 2008 13:45:11 -0500
Message-ID: <4921BCF4.90707@hhs.nl>
Date: Mon, 17 Nov 2008 19:50:28 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: 
Subject: libv4l release: 0.5.4
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

And another release, fixing some cams which can only do 640x480 not working and 
adding a new dest format (making mplayer defaults happy).

libv4l-0.5.4
------------
* Don't report DQBUF errors when errno is EAGAIN, this fixes flooding the
   screen with errors when applications use non blocking mode
* Add support for downscaling to make apps which want low resolutions
   (skype, spcaview) happy when used with cams which can only do high
   resolutions (by Lukáš Karas <lukas.karas@centrum.cz>).
* Add support for converting to YV12 planar (next to the already supported
   YU12 / I420)
* Implement RGB/BGR24 -> YU/YV12 conversion


Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.4.tar.gz

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
