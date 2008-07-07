Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67JfYDB015594
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:41:34 -0400
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67JfMWv031087
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 15:41:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Mon, 7 Jul 2008 21:41:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072141.03344.hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>, michael@mihu.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Proposed removal of the dpc7146 driver
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

Hi all,

If no one objects, then I propose to remove this driver in kernel 2.6.28 
and announce its removal by adding the following notice to the 2.6.27 
feature-removal-schedule.txt document:

What:   V4L2 dpc7146 driver
When:   September 2008
Why:    Old driver for the dpc7146 demonstration board that is no longer 
relevant. The last time this was tested on actual hardware was probably 
around 2002. Since this is a driver for a demonstration board the 
decision was made to remove it rather than spending a lot of effort 
continually updating this driver to stay in sync with the latest 
internal V4L2 or I2C API.
Who:    Hans Verkuil <hverkuil@xs4all.nl>


Michael Hunold, the author of this driver, agrees with my assessment 
that this driver is no longer relevant.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
