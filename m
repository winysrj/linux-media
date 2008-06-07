Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m572T9RT007843
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 22:29:09 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m572SvQh025996
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 22:28:57 -0400
From: Andy Walls <awalls@radix.net>
To: mschimek@gmx.at
In-Reply-To: <1212791383.17465.742.camel@localhost>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
	<200805270853.31287.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
	<1212791383.17465.742.camel@localhost>
Content-Type: text/plain; charset=utf-8
Date: Fri, 06 Jun 2008 22:28:38 -0400
Message-Id: <1212805718.3168.99.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Need VIDIOC_CROPCAP clarification
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

On Sat, 2008-06-07 at 00:29 +0200, Michael Schimek wrote:

> As Daniel wrote, another way to view this is that the active portion of
> the video is about 52 µs wide. At 12.27 MHz (for NTSC square pixels) one
> would sample or "crop" 638 pixels over this period.


Actually since the NTSC line frequency is

Fh = 4.5 MHz/286 ~= 15.73426 kHz

so

1/Fh ~= 63.5556 usec

thus the active part of an NTSC line is actually

(1/Fh - 10.9 us) ~= 52.65556 usec


At the NTSC 12 3/11 MHz square pixel sampling rate that's actually

(1/Fh - 10.9 us) * 12 3/11 MHz = (286/4.5 MHz - 10.9 us) * 12 3/11 MHz =
646.22727 samples

It's slightly above and close, to the VGA screen width of 640 pixels,
with ~3 pixels of active video lost on each of the left and right
edge.  

-Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
