Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SMYGvD026087
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 18:34:16 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SMY5QQ017315
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 18:34:05 -0400
Date: Tue, 29 Jul 2008 00:34:03 +0200
To: Jiri Slaby <jirislaby@gmail.com>
Message-ID: <20080728223403.GC21280@vidsoft.de>
References: <488721F2.5000509@hhs.nl> <20080728214927.GA21280@vidsoft.de>
	<488E4090.5020600@gmail.com>
	<20080728221628.GB21280@vidsoft.de> <488E46BC.10104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488E46BC.10104@gmail.com>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l2 library <v4l2-library@linuxtv.org>
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

On Tue, Jul 29, 2008 at 12:22:52AM +0200, Jiri Slaby wrote:
> Actually positive ioctl retval used to be often considered as OK in the past
> (and this approach is still used in few char drivers).
> 
> But according to v4l docco, it isn't permitted here. Anyway I wouldn't 
> place it
> in videobuf-core.c, but in vivi code; letting this decision on Mauro (CCed) 
> ;).

What happens to negative retvals like -EINVAL? Get they somewhere truncated to -1 and
errno set?

Just curious,
Gregor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
