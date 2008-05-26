Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QLQhjo021771
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 17:26:43 -0400
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QLQVoD023848
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 17:26:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Mon, 26 May 2008 23:26:30 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805262326.30501.hverkuil@xs4all.nl>
Cc: Michael Schimek <mschimek@gmx.at>
Subject: Need VIDIOC_CROPCAP clarification
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

How should the pixelaspect field of the v4l2_cropcap struct be filled? 
Looking at existing drivers it can be anything from 0/0, 1/1, 54/59 for 
PAL/SECAM and 11/10 for NTSC or the horizontal number of samples/the 
horizontal number of pixels.

However, it is my understanding that the last one as used in bttv is the 
correct interpretation. Meaning that if the horizontal unit used for 
cropping is equal to a pixel (this is the case for most drivers), then 
pixelaspect should be 1/1. If the horizontal unit is different from a 
pixel, then it should be:

(total number of horizontal units) / (horizontal pixels)

So given a crop coordinate X, the corresponding coordinate in pixels 
would be:

X * pixelaspect.denominator / pixelaspect.numerator

This is what bttv does and I'm pretty sure that's when this ioctl was 
introduced.

Assuming this is correct, then the Spec needs to be fixed in several 
places (and drivers too, for that matter):

- all references to the term 'pixel aspect' are incorrect: it has 
nothing to do with the pixel aspect, it is about the ratio between the 
horizontal sampling frequency and the 'pixel frequency'.

- the description of 'bounds' is wrong: "Width and height are defined in 
pixels, the driver writer is free to choose origin and units of the 
coordinate system in the analog domain." This is contradictory: the 
width units are up to the driver so the unit for the width is not 
necessarily a pixel. The way the cropping is setup implies that the 
height and Y coordinates are ALWAYS in line (aka pixel) units. It 
cannot be anything else since that's the way analog video works. You 
can't sample the height of half a line.

- pixelaspect: has nothing to do with the pixel aspect. So the 
references to PAL/SECAM and NTSC are irrelevant.

Comments?

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
