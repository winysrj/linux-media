Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36821 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZEZM1I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 08:27:08 -0400
Message-ID: <4A1BE040.8020707@redhat.com>
Date: Tue, 26 May 2009 14:27:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	moinejf@free.fr
Subject: Re: gspca: Logitech QuickCam Messenger worked last with external
 gspcav1-20071224
References: <Pine.LNX.4.64.0905261335050.4810@axis700.grange> <4A1BD76E.4020603@redhat.com> <Pine.LNX.4.64.0905261404290.4810@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0905261404290.4810@axis700.grange>
Content-Type: multipart/mixed;
 boundary="------------060403010909040509060904"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060403010909040509060904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



On 05/26/2009 02:08 PM, Guennadi Liakhovetski wrote:
> On Tue, 26 May 2009, Hans de Goede wrote:
>
>> First of all, which app are you using to test the cam ? And are you using that
>> app in combination with libv4l ?
>
> xawtv, no, it doesn't use libv4l, but it works with the old
> gspcav1-20071224. Ok, maybe it used a different v4l version, but I have
> v4l1_compat loaded.
>

xawtv has known bugs making it not work with gspca (or many other
properly implemented v4l drivers that is). Now those bugs are fixed in
some distro's but this might very well be the cause. Try using ekiga
(together with LD_PRELOAD=..../v4l1compat.so)

>> Also why do you say the original driver used to identify it as a tas5130cxx,
>> the dmesg lines you pasted from gspcav1 also say it is a HV7131R
>
> In the old sources you see
>
> 	switch (vendor) {
> 	...
> 	case 0x046d:		/* Logitech Labtec */
> 	...
> 		switch (product) {
> 		...
> 		case 0x08da:
> 			spca50x->desc = QCmessenger;
> 			spca50x->bridge = BRIDGE_ZC3XX;
> 			spca50x->sensor = SENSOR_TAS5130CXX;
> 			break;
>

Hmm, weird it still prints that other message then. Anyways please
try with another application both with and without the force_sensor
parameter.

Regards,

Hans

p.s.

I've attached a patch to xawtv which I use in Fedora's packages.

--------------060403010909040509060904
Content-Type: text/plain;
 name="xawtv-3.95-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xawtv-3.95-fixes.patch"

diff -Nrbu xawtv-3.95/libng/plugins/drv0-v4l2.c xawtv-3.95-OK/libng/plugins/drv0-v4l2.c
--- xawtv-3.95/libng/plugins/drv0-v4l2.c	2005-02-11 20:56:24.000000000 +0300
+++ xawtv-3.95-OK/libng/plugins/drv0-v4l2.c	2008-08-26 19:27:18.000000000 +0400
@@ -91,6 +91,7 @@
     struct ng_video_fmt            fmt_me;
     struct v4l2_requestbuffers     reqbufs;
     struct v4l2_buffer             buf_v4l2[WANTED_BUFFERS];
+    int                            buf_v4l2_size[WANTED_BUFFERS];
     struct ng_video_buf            buf_me[WANTED_BUFFERS];
     unsigned int                   queue,waiton;
 
@@ -166,7 +167,7 @@
     int rc;
 
     rc = ioctl(fd,cmd,arg);
-    if (0 == rc && ng_debug < 2)
+    if (rc >= 0 && ng_debug < 2)
 	return rc;
     if (mayfail && errno == mayfail && ng_debug < 2)
 	return rc;
@@ -768,6 +769,7 @@
     /* get it */
     memset(&buf,0,sizeof(buf));
     buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+    buf.memory = V4L2_MEMORY_MMAP;
     if (-1 == xioctl(h->fd,VIDIOC_DQBUF,&buf, 0))
 	return -1;
     h->waiton++;
@@ -812,6 +814,7 @@
 	h->buf_v4l2[i].memory = V4L2_MEMORY_MMAP;
 	if (-1 == xioctl(h->fd, VIDIOC_QUERYBUF, &h->buf_v4l2[i], 0))
 	    return -1;
+	h->buf_v4l2_size[i] = h->buf_v4l2[i].length;
 	h->buf_me[i].fmt  = h->fmt_me;
 	h->buf_me[i].size = h->buf_me[i].fmt.bytesperline *
 	    h->buf_me[i].fmt.height;
@@ -865,12 +868,16 @@
 	    ng_waiton_video_buf(&h->buf_me[i]);
 	if (ng_debug)
 	    print_bufinfo(&h->buf_v4l2[i]);
-	if (-1 == munmap(h->buf_me[i].data,h->buf_me[i].size))
+	if (-1 == munmap(h->buf_me[i].data, h->buf_v4l2_size[i]))
 	    perror("munmap");
     }
     h->queue = 0;
     h->waiton = 0;
 
+    /* unrequest buffers (only needed for some drivers) */
+    h->reqbufs.count = 0;
+    xioctl(h->fd, VIDIOC_REQBUFS, &h->reqbufs, EINVAL); 
+
     /* turn on preview (if needed) */
     if (h->ov_on != h->ov_enabled) {
 	h->ov_on = h->ov_enabled;
@@ -907,6 +914,17 @@
     fmt->width        = h->fmt_v4l2.fmt.pix.width;
     fmt->height       = h->fmt_v4l2.fmt.pix.height;
     fmt->bytesperline = h->fmt_v4l2.fmt.pix.bytesperline;
+    /* struct v4l2_format.fmt.pix.bytesperline is bytesperline for the
+       main plane for planar formats, where as we want it to be the total 
+       bytesperline for all planes */
+    switch (fmt->fmtid) {
+        case VIDEO_YUV422P:
+          fmt->bytesperline *= 2;
+          break;
+        case VIDEO_YUV420P:
+          fmt->bytesperline = fmt->bytesperline * 3 / 2;
+          break;
+    }
     if (0 == fmt->bytesperline)
 	fmt->bytesperline = fmt->width * ng_vfmt_to_depth[fmt->fmtid] / 8;
     h->fmt_me = *fmt;

--------------060403010909040509060904--
