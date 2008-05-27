Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 27 May 2008 13:31:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20080527133100.6a9302fb@gaivota>
In-Reply-To: <20080527094144.1189826a@bike.lwn.net>
References: <20080522223700.2f103a14@core> <20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Tue, 27 May 2008 09:41:44 -0600
Jonathan Corbet <corbet@lwn.net> wrote:


> > A next step would be to move the drivers to use the serialized one. 
> 
> So we're replacing the big kernel lock with the big v4l2 lock.  That
> might help the situation, but you'd need to be sure to serialize
> against other calls (open(), for example) which are also currently done
> under the BKL.

True, but on a quick analysis, I suspect that this is already somewhat broken
on some drivers.

Since the other methods don't explicitly call BKL (and, AFAIK, kernel open
handler don't call it neither), if a program 1 is opening a device and
initializing some data, and a program 2 starts doing ioctl, interrupting
program 1 execution in the middle of a data initialization procedure, you may
have a race condition, since some devices initialize some device global data
during open [1].

[1] For example: cx88 and saa7134 will change some data structures if you open
a device via /dev/radio or via /dev/video. So, if program 1 opens as radio and
program 2 opens as video, you may have a race condition. A way to fix this is to
initialize such structs only by the first program that is opening the device,
and serialize a concurrent open.

> > IMO, we need to create a multi-thread stress userspace tool for
> > checking the locks at the ioctls. There are a few testing utils at
> > mercurial tree, under v4l2-apps/test. This can be a starting point
> > for this tool. Also, Brandon improved one of those tools to work with
> > multithread.
> 
> I don't think that stress tools are the way to eliminate the BKL.
> You'll never find all the problems that way.  There's really no way to
> avoid the task of actually *looking* at each driver and ensuring that
> it has its act together with regard to locking.

True. Yet, just looking at the code may not be enough, since people make
mistakes. The recent changes at videobuf lock showed this. The lock fix
patches caused several new locking issues.

It is safer to have a tool to test and stress the driver before going to
production.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
