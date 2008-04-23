Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NIO0PR015972
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 14:24:00 -0400
Received: from server01.coframi-rennes.com (mail.coframi-rennes.com
	[213.56.214.254])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NINRJg025252
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 14:23:27 -0400
Received: from [192.168.1.104] (coframi104.coframi-rennes.com [192.168.1.104])
	by server01.coframi-rennes.com (8.12.11/8.12.11) with ESMTP id
	m3NINBCP012647
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 20:23:12 +0200
Message-ID: <480F7E8D.90209@coframi-rennes.com>
Date: Wed, 23 Apr 2008 20:23:09 +0200
From: Ghislain Baudon <gbaudon@coframi-rennes.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: How to write a V4L2 driver to capture MPEG4 / H.263 ?
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

Hi,

I'm writing a V4L2 driver for a card which capture video in a compressed 
MPEG4 (H.263+) format.
In the VIDIOC_ENUM_FMT, I return the following structure:

const struct v4l2_fmtdesc tsmpeg4_formats[] = {
    {
        .index          = 0,
        .type           = V4L2_BUF_TYPE_VIDEO_CAPTURE,
        .flags          = V4L2_FMT_FLAG_COMPRESSED,
        .description    = "Hardware-encoded MPEG-4",
        .pixelformat    = V4L2_PIX_FMT_MPEG,
   }
};

But several applications (GStreamer, VLC) display an error "unknown 
format 1195724877", and close the dialog.
I have the same behavior with the vivi driver.

How do I declare this MPEG4 compressed format in V4L2?

Thanks for your reading,
Dagonux.
-- 
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
