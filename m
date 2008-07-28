Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SMaTPm027240
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 18:36:29 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SMZoqv018245
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 18:35:51 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1597233nfc.21
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 15:35:50 -0700 (PDT)
From: "H. Willstrand" <h.willstrand@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <488E46BC.10104@gmail.com>
References: <488721F2.5000509@hhs.nl> <20080728214927.GA21280@vidsoft.de>
	<488E4090.5020600@gmail.com> <20080728221628.GB21280@vidsoft.de>
	<488E46BC.10104@gmail.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 00:35:20 +0200
Message-Id: <1217284520.3371.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>,
	Brandon Philips <bphilips@suse.de>, SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
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

Hi!

I think the memory allocation is wrong, you have NBUFFERS = 2 but
memset( ... ) only allocates for 1 buffer.

Regards,
H.Willstrand

On Tue, 2008-07-29 at 00:22 +0200, Jiri Slaby wrote:
> On 07/29/2008 12:16 AM, Gregor Jasny wrote:
> > ioctl(3, VIDIOC_REQBUFS or VT_DISALLOCATE, 0x7fffbfda0060) = 2
> > 
> > Huh? Something evils seems to be going on in V4L2 land.
> > I've spotted the following lines in videobuf-core.c:videobuf_reqbufs
> > 
> >         req->count = retval;
> > 
> >  done:
> >         mutex_unlock(&q->vb_lock);
> >         return retval;
> > 
> > That would explain the retval '2'. It seems a retval = 0; statement is missing here for the success case.
> 
> Actually positive ioctl retval used to be often considered as OK in the past 
> (and this approach is still used in few char drivers).
> 
> But according to v4l docco, it isn't permitted here. Anyway I wouldn't place it 
> in videobuf-core.c, but in vivi code; letting this decision on Mauro (CCed) ;).
> 
> _______________________________________________
> V4L2-library mailing list
> V4L2-library@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l2-library

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
