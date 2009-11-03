Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA30LQdM026884
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 19:21:26 -0500
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA30LFu5018581
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 19:21:16 -0500
Received: by bwz6 with SMTP id 6so7099513bwz.11
	for <video4linux-list@redhat.com>; Mon, 02 Nov 2009 16:21:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 17:21:15 -0700
Message-ID: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
From: Neil Johnson <realdealneil@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Subject: Capturing video and still images using one driver
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

video4linux-list,

I am developing on the OMAP3 system using a micron/aptina mt9p031
5-megapixel imager.  This CMOs imager supports full image capture at 5 fps
(2592x1944 pixels) or you can capture subregions using skipping and
binning.  We have proven both capabilities, but would like to be able to
capture both VGA sized video and still images without using separate
drivers.

So far, I have not found any support for capturing large images and video
through a single driver interface.  Does such a capability exist within
v4l2?  One possible way to solve the problem is to allocate N buffers of the
full 5-megapixel size (they end up being 10-MB for each buffer since I'm
using 16-bits per pixel), and then using a small portion of that for video.
These is less desirable since when I'm capturing video, I only need 640x480
size buffers, and I should only need one snapshot buffer at a time (I'm not
streaming them in, just take a snapshot and go back to live video capture).
Is there a way to allocate a side-buffer for the 5-megapixel image and also
allocate "normal" sized buffers for video within the same driver?  Any
recommendations on how to accomplish such a thing?  I would think that
camera-phones using linux would have run up against this.  Thanks,

Neil Johnson
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
