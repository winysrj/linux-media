Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway15.websitewelcome.com ([67.18.94.13]:57001 "HELO
	gateway15.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755230Ab0GBSWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 14:22:06 -0400
Received: from [66.15.212.169] (port=27175 helo=[10.140.5.14])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1OUklr-0007EO-Oz
	for linux-media@vger.kernel.org; Fri, 02 Jul 2010 13:15:27 -0500
Subject: vivi videobuf bug with tvtime
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 11:15:24 -0700
Message-ID: <1278094524.32074.13.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a problem with the tvtime application that affects recent v4l2
drivers.  The tvtime application works fine the first time you run it,
but the second time tvtime is run, the call to VIDIOC_REQBUFS fails with
EBUSY.  

The problem is that tvtime does a VIDIOC_STREAMOFF, then VIDIOC_QBUF a
few times before closing the fd.  This only affects v4l2 drivers that
store the 'struct videobuf_queue vb_vidq' in the dev struct.  It doesn't
affect older drivers that store that struct in the driver fh struct.
The videobuf_reqbufs call is returning from this statement:
videobuf-core.c: in videobuf_reqbufs()
        if (!list_empty(&q->stream)) {
                dprintk(1, "reqbufs: stream running\n");
                retval = -EBUSY;
                goto done;
        }

Is tvtime abusing the API, or is this a videobuf buf?  My opinion is
that applications shouldn't be able to force the driver into an unusable
state.

Here's the debug kernel log starting at the streamoff:
[ 4862.871055] vivi: VIDIOC_STREAMOFF
[ 4862.871061] vivi-000: buffer_release
[ 4862.871063] vivi-000: free_buffer, state: 6
[ 4862.871065] vivi-000: free_buffer: freed
[ 4862.871066] vivi-000: buffer_release
[ 4862.871068] vivi-000: free_buffer, state: 5
[ 4862.871069] vivi-000: free_buffer: freed
[ 4862.871071] vivi-000: buffer_release
[ 4862.871073] vivi-000: free_buffer, state: 5
[ 4862.871074] vivi-000: free_buffer: freed
[ 4862.871076] vivi-000: buffer_release
[ 4862.871077] vivi-000: free_buffer, state: 6
[ 4862.871079] vivi-000: free_buffer: freed
[ 4862.871081] vivi-000: vivi_stop_generating
[ 4862.871087] vivi-000: thread: exit
[ 4862.871108] vivi: VIDIOC_QBUF
[ 4862.871111] vbuf: qbuf: requesting next field
[ 4862.871113] vivi-000: buffer_prepare, field=4
[ 4862.871138] vbuf: qbuf: succeded
[ 4862.871140] vivi: VIDIOC_QBUF
[ 4862.871142] vbuf: qbuf: requesting next field
[ 4862.871144] vivi-000: buffer_prepare, field=4
[ 4862.871167] vbuf: qbuf: succeded
[ 4862.871169] vivi: VIDIOC_QBUF
[ 4862.871171] vbuf: qbuf: requesting next field
[ 4862.871173] vivi-000: buffer_prepare, field=4
[ 4862.871196] vbuf: qbuf: succeded
[ 4862.871198] vivi: VIDIOC_QBUF
[ 4862.871200] vbuf: qbuf: requesting next field
[ 4862.871202] vivi-000: buffer_prepare, field=4
[ 4862.871225] vbuf: qbuf: succeded
[ 4862.871498] vivi-000: vivi_stop_generating
[ 4862.871500] vivi-000: close called (dev=video0)
[ 4865.031222] vivi: VIDIOC_QUERYCAP
[ 4865.031232] vivi: VIDIOC_ENUMINPUT
[ 4865.031235] vivi: VIDIOC_ENUMINPUT
[ 4865.031238] vivi: VIDIOC_ENUMINPUT
[ 4865.031241] vivi: VIDIOC_ENUMINPUT
[ 4865.031244] vivi: VIDIOC_ENUMINPUT
[ 4865.031265] vivi: v4l1 ioctl 'v', dir=r-, #198 (0x800476c6)
[ 4865.031273] vivi: VIDIOC_S_INPUT
[ 4865.031298] vivi: VIDIOC_G_INPUT
[ 4865.031305] vivi: VIDIOC_ENUMINPUT
[ 4865.031312] vivi: VIDIOC_G_STD
[ 4865.031318] vivi: VIDIOC_S_STD
[ 4865.031324] vivi: VIDIOC_G_TUNER
[ 4865.031482] vivi: VIDIOC_S_FMT
[ 4865.031490] vivi: VIDIOC_TRY_FMT
[ 4865.031497] vivi: VIDIOC_REQBUFS
[ 4865.031504] vbuf: reqbufs: stream running
[ 4865.031519] vivi-000: vivi_stop_generating
[ 4865.031525] vivi-000: close called (dev=video0)


