Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SMGgkq017251
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 18:16:42 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SMGUOD009063
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 18:16:30 -0400
Date: Tue, 29 Jul 2008 00:16:28 +0200
To: Jiri Slaby <jirislaby@gmail.com>
Message-ID: <20080728221628.GB21280@vidsoft.de>
References: <488721F2.5000509@hhs.nl> <20080728214927.GA21280@vidsoft.de>
	<488E4090.5020600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E4090.5020600@gmail.com>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	v4l2 library <v4l2-library@linuxtv.org>, Brandon Philips <bphilips@suse.de>
Subject: Re: [V4l2-library] Messed up syscall return value
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

On Mon, Jul 28, 2008 at 11:56:32PM +0200, Jiri Slaby wrote:
> On 07/28/2008 11:49 PM, Gregor Jasny wrote:
> >I've observed strange behavior in the REQBUFS ioctl for the non-emulated
> >case.
> >
> >I've debugged the problem to the line:
> >result = syscall(SYS_ioctl, devices[index].fd, VIDIOC_REQBUFS, req);
> >
> >Here the value 2 get stored into result, although the kernel driver
> >returned success (at least it does not complain loudly in the logs).
> >
> strace and ltrace will help in this case I guess. Could you provide them for
> your testcases?

Sure:

ioctl(3, VIDIOC_QUERYCAP or VT_OPENQRY, 0x7fffbfd9fdd0) = 0
ioctl(3, VIDIOC_G_FMT or VT_SENDSIG, 0x7fffbfd9fd00) = 0
ioctl(3, VIDIOC_ENUM_FMT or VT_SETMODE, 0x7fffbfd9fc40) = 0
ioctl(3, VIDIOC_ENUM_FMT or VT_SETMODE, 0x7fffbfd9fc40) = -1 EINVAL (Invalid argument)
ioctl(3, VIDIOC_TRY_FMT, 0x7fffbfda0080) = 0
ioctl(3, VIDIOC_S_FMT or VT_RELDISP, 0x7fffbfd9fd40) = 0
ioctl(3, VIDIOC_REQBUFS or VT_DISALLOCATE, 0x7fffbfda0060) = 2

Huh? Something evils seems to be going on in V4L2 land.
I've spotted the following lines in videobuf-core.c:videobuf_reqbufs

        req->count = retval;

 done:
        mutex_unlock(&q->vb_lock);
        return retval;

That would explain the retval '2'. It seems a retval = 0; statement is missing here for the success case.

Gregor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
