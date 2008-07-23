Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6NC8h99022900
	for <video4linux-list@redhat.com>; Wed, 23 Jul 2008 08:08:43 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6NC88xi014706
	for <video4linux-list@redhat.com>; Wed, 23 Jul 2008 08:08:09 -0400
Message-ID: <48872112.8070205@hhs.nl>
Date: Wed, 23 Jul 2008 14:16:18 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: [PULL] libv4l 0.3.7 release,
	add spca505/6 and spca508 format support
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

Hi Mauro,

The spca505/506/508 drivers still do some in kernel format conversion. JF Moine 
  is planning on ripping those out and asked me to add support for converting 
from the raw cam formats into something usefull to libv4l.

Thus I've just pushed a new libv4l to my tree, please pull from 
http://linuxtv.org/hg/~hgoede/v4l-dvb/
for this, note my tree also still contains 4 gspca-sonixb patches, as reported 
before.

changeset:   8435:902786b1451d
gspca_sonixb sn9c103 + ov7630 autoexposure and cleanup

changeset:   8436:80f6ae943cdf
gspca_sonixb remove non working ovXXXX contrast, hue and saturation ctrls

changeset:   8437:b1a9e9edc9af
gspca_sonixb remove some no longer needed sn9c103+ov7630 special cases

changeset:   8438:58294e459717
gspca_sonixb remove one more no longer needed special case from the code

changrset:   8439:e84b4fbc4322
libv4l 0.3.7 release, add spca505/6 and spca508 format support

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
