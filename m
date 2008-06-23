Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NMXt3P019138
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 18:33:55 -0400
Received: from mailrelay001.isp.belgacom.be (mailrelay001.isp.belgacom.be
	[195.238.6.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NMXiGi005051
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 18:33:44 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-uvc-devel@lists.berlios.de
Date: Tue, 24 Jun 2008 00:33:40 +0200
References: <485F7A42.8020605@vidsoft.de>
In-Reply-To: <485F7A42.8020605@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806240033.41145.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: [Linux-uvc-devel] Thread safety of ioctls
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

Hi Gregor,

On Monday 23 June 2008, Gregor Jasny wrote:
> Hi,
>
> in our video conference application the grabbing (QBUF, DQBUF) is done
> in a separate thread. The main thread is responsible for the user
> interface and queries the controls, input and current standard values
> from time to time.
>
> With the latest uvc driver (r217) and vanilla Linux 2.6.25.6 I've
> noticed the strange behavior that the grabbing thread hangs in the DQBUF
> ioctl. If I remove the control queries from the gui thread everything is
> working fine. After the first hang of the driver, even luvcview hangs at
> the buffer operation.
>
> With the bttv driver everything works fine. I'll test vivi and pwc
> driver later.
>
> My systems are a i686 and one amd64 system with one Logitech 9000 and
> one Microsoft NX-6000. I've tried to create a simple testcase, but
> suprinsingly this testcase works fine.
>
> Can I enable more logging than setting the trace parameter to 0xfff?

No without adding more printk's to the driver, which I encourage you to do.

> Have you any idea what went wrong here?

Not really. The ioctl handler is protected by the big kernel lock, so ioctls 
are currently not reentrant.

Could you give more information about the hardware you are using (webcam, SMP 
system) ? Please report kernel log message printed by the UVC driver as well.

> Is the V4L2-API designed to be thread safe?

There is no mention of thread safety in the V4L2 spec, so one can always argue 
that thread safety is not required for V4L2 drivers :-)

Most drivers are probably not designed with thread safety in mind, and I'm 
pretty sure lots of race conditions still lie in the depth of V4L(2) drivers. 
In the long term all those bugs should be fixed, and drivers should support 
multi-threaded applications without crashing or misbehaving.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
