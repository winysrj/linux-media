Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QEvwIt025904
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 10:57:58 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QEvcL6016929
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 10:57:39 -0400
Received: from tschai.lan (cm-84.208.69.186.getinternet.no [84.208.69.186])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id m3QEvcM4023451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>;
	Sat, 26 Apr 2008 16:57:38 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Sat, 26 Apr 2008 16:57:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804261657.37708.hverkuil@xs4all.nl>
Subject: Is PAL-N supported by an NTSC tuner?
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

I am trying to figure out which analog TV standards are supported by a 
card with an NTSC tuner. Most cards come in two variants: one with an 
NTSC tuner and one with a PAL/SECAM tuner. However, it is not as clear 
to me which of the more obscure PAL standards require an NTSC tuner.

I know that an NTSC tuner is required for PAL-M and PAL-Nc, but what 
about PAL-N?

PAL-60 and NTSC 4.43 are never broadcast, so these play no role when it 
comes to tuner support.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
