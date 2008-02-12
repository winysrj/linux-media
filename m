Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1C4FiYI011257
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 23:15:44 -0500
Received: from smtp5.clear.net.nz (smtp5.clear.net.nz [203.97.33.68])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1C4FARV028705
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 23:15:11 -0500
Received: from zaphod (121-72-250-62.cable.telstraclear.net [121.72.250.62])
	by smtp5.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0JW300H0NYH7RT30@smtp5.clear.net.nz> for
	video4linux-list@redhat.com; Tue, 12 Feb 2008 17:15:08 +1300 (NZDT)
Date: Tue, 12 Feb 2008 17:17:59 +1300
From: Eliot Blennerhassett <linux@audioscience.com>
To: video4linux-list@redhat.com
Message-id: <200802121717.59498.linux@audioscience.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
Subject: V4L2 support card with multiple radio tuners,
 each supporting multiple bands?
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

I am presently working on updating the V4L driver for our tuner cards to V4L2, 
and need some help with a few details...
pointers to existing relevant sourcecode would be a fine start!

These cards 
http://audioscience.com/internet/products/tuner_cards/tunercards.htm have up 
to 8 radio and/or TV (audio only) tuners . There may be a mix of tuners on 
the card.

Each tuner may be capable of receiving more than one band or standard eg 
(AM/FM) (FM/TV-NTSC) (TV-PAL) (TV-multistandard)

Our current V4L1 driver creates a separate device for each tuner.  
I think V4L2 still doesn't support multiple radio tuners?  Is there any reason 
why radio tuners are treated differently from tv tuners in this respect?

The V4L1 tuner capabilities reports the number of bands supported as 
video_capability.channels. Then during query video_tuner.tuner is used to 
enumerate the name, range etc of each band.

Is there an equivalent for V4L2?

Are there any examples of V4L2 drivers for radio tuners about. I don't think 
any of the current in-kernel drivers have been converted?

thanks

-- 
--
Eliot Blennerhassett
www.audioscience.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
