Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7SA4dEe029249
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 06:04:40 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7SA4Qap014012
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 06:04:27 -0400
Message-ID: <48B67ACA.4090700@hhs.nl>
Date: Thu, 28 Aug 2008 12:15:38 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: gspca-usb-ids.patch
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

Hi,

USB-id shuffle:
-remove USB-id's from zc0301 for cams for which zc0301.c does not support
  the sensor
-remove USB-id's from sn9c102 for cams where sn9c102 does not support the
  bridge sensor combination
-no longer make inclusion of usb id's removed from zc0301 and sn9c102
  conditional in gspca
-fix conditional inclusion of USB-id's in gspca to also work when the
  conflicting drivers are build as a module
-add a number of USB-id's to gspca from various windows .inf files:
0c45:608f from generic sonix sn9c103 inf file (+ ov7630 which we support)
041e:4022 from creative webcam nx pro, same as already supported 041e:401e
0ac8:0301 from generic zc0301 driver which supports many sensors
10fd:804d from typhoon webshot driver (also FlyCAM-USB 300 plus)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
