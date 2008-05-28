Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4S2Jx4S020483
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 22:19:59 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4S2JlOq016610
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 22:19:48 -0400
Date: Wed, 28 May 2008 04:19:13 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Andy Walls <awalls@radix.net>
Message-ID: <20080528021912.GA789@daniel.bse>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
	<200805270853.31287.hverkuil@xs4all.nl>
	<1211930655.3197.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1211930655.3197.18.camel@palomino.walls.org>
Cc: v4l <video4linux-list@redhat.com>, Michael Schimek <mschimek@gmx.at>
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

Just looking at the intended usage of struct v4l2_cropcap and ignoring
most of the descriptions in the standard, I would explain it this way:

struct v4l2_crop x = {
  type,
  { 0, 0,
    v4l2_cropcap.pixelaspect.numerator,
    v4l2_cropcap.pixelaspect.denominator
  }
};

defines a square region on (or outside) the screen.
This does not take into account anamorphic 16:9 transmissions.

There is no information in v4l2_cropcap on how to map these values to
pixels. The mapping has to be done with VIDIOC_S_FMT.

v4l2_cropcap tells us how to calculate the DAR for a crop region.
v4l2_format defines how to calculate the PAR from the DAR.

The height of defrect should correspond to the active picture area.
In case of 625-line PAL/SECAM it should represent 576 lines.
It follows that
width = defrect.height * 4/3
        * v4l2_cropcap.pixelaspect.numerator
        / v4l2_cropcap.pixelaspect.denominator;
covers 52탎 of a 64탎 PAL/SECAM line.
52탎 equals 702 BT.601 pixels.

The defrect.left+defrect.width/2 should be the center of the active picture
area. This is 36.5탎 after OH (start of horizontal sync) for PAL/SECAM
according to BT.1700.

These microsecond calculations can of course only be done if v4l2_std_id is
a known standard.

If it is unknown, the application only knows that defrect looks good and
how to scale the image to get the aspect ratio right.

All of this is how I think it should work, not necessarily how it is
standardized.

Many people use 480 lines instead of 486 lines for the active region in NTSC
and if there are inconsistencies in drivers, application may degrade the
picture by scaling. Therefore it would be nice if at least analog vertical
resolution was mapped 1:1 to cropping regions per standard.
Not doing so would make sense only if there was a tv standard where the
image is drawn column-wise.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
