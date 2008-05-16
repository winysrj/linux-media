Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4GFZeu3031013
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 11:35:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4GFZR7I031624
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 11:35:27 -0400
Date: Fri, 16 May 2008 12:34:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: dean <dean@sensoray.com>
Message-ID: <20080516123454.5e8f897e@gaivota>
In-Reply-To: <482D9FFA.9030402@sensoray.com>
References: <20080514205927.GA13134@kroah.com>
	<20080515235102.756407d3@gaivota> <482D9FFA.9030402@sensoray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
	linux-usb@vger.kernel.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
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

On Fri, 16 May 2008 07:53:46 -0700
dean <dean@sensoray.com> wrote:

> >Btw, I noticed the lack of Dean's SOB. Is this intentional?  
> It's not intentional, I can sign off on it. 

Thanks. Please send your SOB at the next version.

> I have a few other questions.  First, is Video for Linux version 1 going 
> to be obsoleted soon?

We intend to, but people are currently lacking time to port old drivers to V4L2.

>  Do the V4L1 compatibility routines still work in 
> the latest driver?

V4L1 compat will still be kept for some time after the end of V4L1 drivers.

>  I had problems running the VIVI (virtual video 
> driver) driver with VideoLan/VLC 0.8.6a-f, but it worked with VLC 9.0 
> with the new V4L2 interface.

VLC V4L1 implementation were broken. It first starts DMA and streaming, then,
it calls some ioctls that changes the buffer size. The compat handler doesn't
accept this behaviour, since it would cause buffer overflow. AFAIK, only bttv
driver used to support this behaviour. On V4L1 mode, bttv were allocating
enough memory for the maximum resolution. So, subsequent buffer changes works
properly. 

It would be valuable if you could work on a safe way to implement backward
compat for this broken behaviour. In this case, you would need to change the
compat implementation at videobuf, and let v4l1-compat module to be aware that
it is safe to allow buffer size changes.

Yet, this seems to much work for something that should be already removed from
kernel (V4L1).

> "videodev: "s2255v" has no release callback. Please fix your driver for 
> proper sysfs support, see http://lwn.net/Articles/36850/"

> Should we get rid of the warning message above? It's also been present 
> in VIVI for quite a few kernel releases.

The message doesn't cause any harm, but the better is to fix this also. This
were already corrected at the latest vivi versions.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
