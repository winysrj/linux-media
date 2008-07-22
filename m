Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MBYJFd004739
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 07:34:19 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MBY5JA022282
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 07:34:06 -0400
Message-ID: <4885C791.8030908@hhs.nl>
Date: Tue, 22 Jul 2008 13:42:09 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: [PULL] gspca sonixb improvements (updated!)
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

As discussed before I've taken over maintainer ship of the sonixb (and spca501
and spca561) gspca subdrivers.

Andoni Zubimendi <andoni.zubimendi@gmail.com> is moving very fast today and 
tested if some special cases for his cam were still needed after the ov7630 
unification work. Happily they aren't so this pull request contains one more 
patch which gets rids of some special cases in the sonixb driver for Andoni's cam.

Please pull from http://linuxtv.org/hg/~hgoede/v4l-dvb/
for:

changeset:   8435:902786b1451d
gspca_sonixb sn9c103 + ov7630 autoexposure and cleanup

changeset:   8436:80f6ae943cdf
gspca_sonixb remove non working ovXXXX contrast, hue and saturation ctrls

changeset:   8437:b1a9e9edc9af
gspca_sonixb remove some no longer needed sn9c103+ov7630 special cases


Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
