Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57356 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZKDRNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 12:13:02 -0500
Received: by bwz27 with SMTP id 27so9098960bwz.21
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 09:13:06 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Nov 2009 10:13:05 -0700
Message-ID: <3d7d5c150911040913i5486bd07r3a465a2f7d2d5a3e@mail.gmail.com>
Subject: still image capture with video preview
From: Neil Johnson <realdealneil@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

linux-media,

I previously posted this on the video4linux-list, but linux-media
seems a more appropriate place.

I am developing on the OMAP3 system using a micron/aptina mt9p031
5-megapixel imager.  This CMOs imager supports full image capture
(2592x1944 pixels) or you can capture subregions using skipping and
binning.  We have proven both capabilities, but would like to be able
to capture both VGA sized video and still images without using
separate drivers.

So far, I have not found any support for capturing large images and
video through a single driver interface.  Does such a capability exist
within v4l2?  One possible way to solve the problem is to allocate N
buffers of the full 5-megapixel size (they end up being 10-MB for each
buffer since I'm using 16-bits per pixel), and then using a small
portion of that for video.  This is less desirable since when I'm
capturing video, I only need 640x480 size buffers, and I should only
need one snapshot buffer at a time (I'm not streaming them in, just
take a snapshot and go back to live video capture).  Is there a way to
allocate a side-buffer for the 5-megapixel image and also allocate
"normal" sized buffers for video within the same driver?  Any
recommendations on how to accomplish such a thing?  I would think that
camera-phones using linux would have run up against this.  Thanks,

Neil Johnson
