Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2RLvqSB005326
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 17:57:52 -0400
Received: from mail11b.verio-web.com (mail11b.verio-web.com [204.202.242.87])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n2RLvPjd004677
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 17:57:30 -0400
Received: from mx15.stngva01.us.mxservers.net (204.202.242.101)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 4-0776831044
	for <video4linux-list@redhat.com>; Fri, 27 Mar 2009 17:57:24 -0400 (EDT)
Message-ID: <49CD4BC2.9010702@sensoray.com>
Date: Fri, 27 Mar 2009 14:57:22 -0700
From: dean <dean@sensoray.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: VIVI driver issue with xawtv resize in low resolution mode
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

xawtv and/or libv4l2 is unmapping the V4L2 buffers before stopping the 
stream.  This causes xawtv and/or libv4l2 to retry VIDIOC_STREAMOFF 
multiple times before failing and the stream does not get restarted.

Tested on Ubuntu 8.10 with kernel upgraded to 2.6.29 and with 
v4l-dvb-b1596c6517c9.


To reproduce (does not fail if running with XV extensions):

1) load vivi driver
2) xawtv -noxv -nodga -noxv-image -c /dev/video0  (where video0 is vivi 
device, xawtv-3.95)
3) Resize the xawtv window.
4) Video output will stop and will not restart.

Should VIDIOC_STREAMOFF return -EINVAL if the stream is already off?  Is 
it ok to return 0 if the stream was turned off by an user application 
unmapping the buffers before stopping the stream?  In this example, 
videobuf_vm_close in videobuf-vmalloc.c is called before 
vidioc_streamoff in vivi.c.  videobuf_vm_close stops streaming in 
videobuf-vmalloc.c such that -EINVAL is returned on any subsequent 
VIDIOC_STREAMOFF ioctls. xawtv will not resume streaming in this case. 
This also affects other drivers using videobuf-vmalloc.  A possible 
workaround is the following(not an official patch) code below:

static int vidioc_streamoff(struct file *file, void *priv, enum 
v4l2_buf_type i)
{
	struct vivi_fh  *fh = priv;

	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
		return -EINVAL;
	if (i != fh->type)
		return -EINVAL;
	return videobuf_streamoff(&fh->vb_vidq);
}

to:

static int vidioc_streamoff(struct file *file, void *priv, enum 
v4l2_buf_type i)
{
	struct vivi_fh  *fh = priv;

	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
		return -EINVAL;
	if (i != fh->type)
		return -EINVAL;
	(void) videobuf_streamoff(&fh->vb_vidq);
	return 0;
}




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
