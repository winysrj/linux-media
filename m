Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5UCt47V027944
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 08:55:04 -0400
Received: from mout3.freenet.de (mout3.freenet.de [195.4.92.93])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n5UCsm6g023220
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 08:54:48 -0400
Received: from [195.4.92.21] (helo=11.mx.freenet.de)
	by mout3.freenet.de with esmtpa (ID exim) (port 25) (Exim 4.69 #92)
	id 1MLcrH-0004ci-O7
	for video4linux-list@redhat.com; Tue, 30 Jun 2009 14:54:47 +0200
Received: from www7.emo.freenet-rz.de ([194.97.107.210]:37145)
	by 11.mx.freenet.de with esmtpa (ID exim) (port 25) (Exim 4.69 #79)
	id 1MLcrH-00079F-Ie
	for video4linux-list@redhat.com; Tue, 30 Jun 2009 14:54:47 +0200
Received: from www-data by www7.emo.freenet-rz.de with local (Exim 4.67 1
	(Panther_1)) id 1MLcrG-0003zp-PE
	for <video4linux-list@redhat.com>; Tue, 30 Jun 2009 14:54:46 +0200
To: video4linux-list@redhat.com
From: judith.baumgarten@freenet.de
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Message-Id: <E1MLcrG-0003zp-PE@www7.emo.freenet-rz.de>
Date: Tue, 30 Jun 2009 14:54:46 +0200
Content-Transfer-Encoding: 8bit
Subject: PXA270 QCI flag that initiates frame transport
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

Hi list,

I try to use a PXA320 processors Quick Capture Interface but I don't get images. With the help of the driver that exists for PXA270 I figured out, that start and end of frame are as well detected as end of line but apparently the transport of data doesn't start.
I tried to find the responsible code/register and found CIFR[THL_0]. Does anybody know if setting this register causes an interrupt that starts data transport?

If not, which register starts it?

Regards
Judith











#adBox3 {display:none;}



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
