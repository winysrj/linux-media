Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53FEk33010035
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:14:46 -0400
Received: from vesta.asc.rssi.ru (vesta.asc.rssi.ru [193.232.12.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53FEXIw006782
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:14:34 -0400
Received: from vesta.asc.rssi.ru (localhost [127.0.0.1])
	by vesta.asc.rssi.ru (8.12.7/8.12.7/SuSE Linux 0.6) with ESMTP id
	m53Ff3lq007483
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 19:41:03 +0400
Received: (from kostyuk@localhost)
	by vesta.asc.rssi.ru (8.12.7/8.12.7/Submit) id m53Ff20M007482
	for video4linux-list@redhat.com; Tue, 3 Jun 2008 19:41:02 +0400
From: Sergey Kostyuk <kostyuk@vesta.asc.rssi.ru>
Date: Tue, 03 Jun 2008 19:41:02 +0400
To: video4linux-list@redhat.com
Message-ID: <4845660E.mail5RL112CPN@vesta.asc.rssi.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: v4l API question: any support for HDTV is possible?
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

Hello

The TV-encoders provide capabilies concerning analog video signal of standart PAL, SECAM
and NTSC. That standards are described quite exhaustively by v4l2_std_id.

Some modern HDTV-encoders use more complicated video standards. Is it possible to
set parameters of HDTV-output device by v4linux API?

I am expecting that HDTV-parameters must include the thing like: H & V frequency, width & height,
misc H & V sync intervals, pixel frequency and interlaced and progressive to describe custom
HDTV-signal.

Im working at open-source drivers for devices with HDTV-capabilities:
http://sourceforge.net/projects/opensigma/

The second question:
could we add new type of output video devices (field type in v4l2_output structure):
V4L2_OUTPUT_TYPE_DIGITAL_OVERLAY
to describe digital output of my multimedia-board?

Sergey
/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
