Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o9IB0Hg0014457
	for <video4linux-list@redhat.com>; Mon, 18 Oct 2010 07:00:17 -0400
Received: from mta-blr1.sasken.com (mta-blr1.sasken.com [203.200.200.72])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9IB04Gh007885
	for <video4linux-list@redhat.com>; Mon, 18 Oct 2010 07:00:05 -0400
From: Rohit Vashist <rohit.vashist@sasken.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Mon, 18 Oct 2010 16:30:00 +0530
Subject: Query regarding V4l2 and VideoBuf buffers
Message-ID: <6F91E0FFDA542149961F7BDED2D2B94B0FC02A1522@EXGMBX01.sasken.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi,

I am writing a modules where i have allocated a buffer using kmalloc.I need to pass this buffer to be accessed by v4l2_driver.
I have my own buffer structure in which i embed my meta data.I want that this buffer to be recognised by v4l2_driver.
Can anyone just tell as to how to corelate this two things?

Thanks a lot


-Regards
 Rohit Vashist

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
