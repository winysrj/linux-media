Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2VIaGxB011684
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 14:36:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2VIa56a018500
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 14:36:05 -0400
Date: Mon, 31 Mar 2008 15:35:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080331153555.6adca09b@gaivota>
In-Reply-To: <20080329052559.GA4470@plankton.ifup.org>
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
	<20080329052559.GA4470@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 9] videobuf fixes
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

On Fri, 28 Mar 2008 22:25:59 -0700
Brandon Philips <brandon@ifup.org> wrote:

> > I've opened 3 mplayer windows, reading /dev/video0. I closed the second one and
> > opened again. I got an error:
> 
> Shouldn't V4L2 devices not be able to stream to multiple applications at
> once?  Quoting the spec:
> 
> "V4L2 drivers should not support multiple applications reading or
> writing the same data stream on a device by copying buffers, time
> multiplexing or similar means. This is better handled by a proxy
> application in user space. When the driver supports stream sharing
> anyway it must be implemented transparently. The V4L2 API does not
> specify how conflicts are solved."
> 
> How about this patch?

The patch is wrong. 

V4L2 API states that it should be possible for a driver to have multiple opens[1]. Most drivers support this. There are two main usages for multiple open:

	1) a driver may open the device for streaming, while another thread or userspace app will open to configure. This is generally the way I use here to test video controls: I open "qv4l2" (under v4l2-apps/util) while streaming. This way, I can test any changes at the driver, without needing to have the feature implemented at the userspace app;

	2) you can see a program with an userspace app and record the stream with another app. Both xawtv and xdtv do this, when you ask for record: They call mencoder, asking it to read from /dev/video0. This way, you'll have the tv app reading, using mmap() or overlay methods, while mencoder is calling read() to receive the stream.

In fact, at least bttv, cx88 and saa7134 allows multiple opens for streaming. They have a limit, due to driver/hardware constraints: You cannot open two transfers of the same type. But you can open one overlay, one mmap() and one read() at the same time.

While I don't have much concerns of not allowing multiple streaming on vivi for the same device (since you can ask vivi to create several different virtual devices, by using "n_devs" modprobe parameter), for sure videobuf should keep supporting this feature, otherwise it will break the other drivers that relies on this feature. Yet, vivi should allow multiple open to allow "panel" applications, to be compliant with V4L2 API.

[1] From V4L2 API doc, rev 0.24:

"1.1.3. Multiple Opens

In general, V4L2 devices can be opened more than once. When this is supported by the driver, users can for example start a "panel" application to change controls like brightness or audio volume, while another application captures video and audio. In other words, panel applications are comparable to an OSS or ALSA audio mixer application. When a device supports multiple functions like capturing and overlay simultaneously, multiple opens allow concurrent use of the device by forked processes or specialized applications.

Multiple opens are optional, although drivers should permit at least concurrent accesses without data exchange, i. e. panel applications. This implies open() can return an EBUSY error code when the device is already in use, as well as ioctl() functions initiating data exchange (namely the VIDIOC_S_FMT ioctl), and the read() and write() functions."

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
