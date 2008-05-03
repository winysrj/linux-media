Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m43JdWmA011833
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 15:39:32 -0400
Received: from mylar.outflux.net (mylar.outflux.net [69.93.193.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m43JdMsC003019
	for <video4linux-list@redhat.com>; Sat, 3 May 2008 15:39:22 -0400
Date: Sat, 3 May 2008 12:39:03 -0700
From: Kees Cook <kees@outflux.net>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080503193903.GM12850@outflux.net>
References: <20080417012354.GH18929@outflux.net>
	<200804212310.47130.laurent.pinchart@skynet.be>
	<20080421214717.GJ18865@outflux.net>
	<200804250055.45118.laurent.pinchart@skynet.be>
	<20080428072655.GB782@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428072655.GB782@plankton.ifup.org>
Cc: video4linux-list@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] v4l: Introduce "stream" attribute for persistent
	video4linux device nodes
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

Hi Brandon,

On Mon, Apr 28, 2008 at 12:26:55AM -0700, Brandon Philips wrote:
> Kees: I don't have a device that creates multiple device nodes.  Please
> test with ivtv.  :D

Unfortunately, this doesn't work with ivtv -- each device has a streamid
of 0.  (video0, video24, video32 all on the same PCI path reported
stream 0)

Note that I backported this to 2.6.24 to test, so perhaps I did
something wrong.  I will double-check...

-Kees

-- 
Kees Cook                                            @outflux.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
