Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <balrogg@gmail.com>) id 1LHWek-0001lO-KI
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 05:56:41 +0100
Received: by rv-out-0506.google.com with SMTP id b25so5038443rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 29 Dec 2008 20:56:34 -0800 (PST)
Message-ID: <fb249edb0812292056u32019ddbt4dc29de03a938368@mail.gmail.com>
Date: Tue, 30 Dec 2008 05:56:33 +0100
From: "andrzej zaborowski" <balrogg@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <fb249edb0812292050s2e3e46a0u8588d79cf3cf858e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <fb249edb0812292050s2e3e46a0u8588d79cf3cf858e@mail.gmail.com>
Subject: [linux-dvb] V4L2 Bug and/or Bad Docs for VIDIOC_REQBUFS ioctl()
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

[Forwarding from a coder who wants to be anonymous]

The documentation at:

 http://v4l2spec.bytesex.org/spec-single/v4l2.html#VIDIOC-REQBUFS

says that the VIDIOC_REQBUFS ioctl(), used to initiate memory mapping
or user pointer i/o on V4L2 devices, returns a 0 upon success, or a -1
on error, and sets errno to either EBUSY or EINVAL. The code, however,
does not follow this logic.

In /usr/src/linux/drivers/media/video/videobuf-core.c, in the function

 int videobuf_reqbufs(struct videobuf_queue *q, \
                      struct v4l2_requestbuffers *req);

If an error occours, "return -EINVAL" is called. If an error does not
occour, execution reaches the following statement:

 retval = __videobuf_mmap_setup(q, count, size, req->memory);

followed by:

 req->count = retval;

and:

 return retval;

So, the value being returned, upon success, is the value returned from
the call to __videobuf_mmap_setup(). Looking inside the code for this
function, the buffers are setup inside a for() loop, and the last value
of "i" used as a counter for that loop is returned. In other words, the
buffers allocated count is returned.

So, is the documentation wrong ? or is the code wrong ?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
