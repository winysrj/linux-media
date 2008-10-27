Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9RGJdIc019228
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 12:19:39 -0400
Received: from mail11e.verio-web.com (mail11e.verio-web.com [204.202.242.84])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9RGIXIi001364
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 12:19:00 -0400
Received: from mx120.stngva01.us.mxservers.net (198.173.112.49)
	by mail11e.verio-web.com (RS ver 1.0.95vs) with SMTP id 3-051784313
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 12:18:33 -0400 (EDT)
From: Pete Eberlein <pete@sensoray.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Mon, 27 Oct 2008 09:18:32 -0700
Message-Id: <1225124312.4423.21.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: saa7134 empress: simultaneous capture
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

I'm working with a board that has a saa7134 chip with a go7007 mpeg
encoder.  I've modified the saa7134 driver to detect the board and load
the saa7134 go7007 driver from GregKH's staging patch.  I think this
works similar to the saa7134 empress driver.

The raw video is on /dev/video0 and the mpeg compressed video is
on /dev/video1.  Video capture from each video device works fine
individually, but when I try to capture from both devices
simultaneously, the mpeg compressed stream goes blank (select timeout -
as if there is no video signal.)

Can anyone tell me if simultaneous capture works for a saa7134 empress
based board?  Is there a reason I shouldn't expect this to work?

Thanks.
-- 
Pete Eberlein
Sensoray Co., Inc.
Email: pete@sensoray.com
http://www.sensoray.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
