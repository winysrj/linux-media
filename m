Return-path: <video4linux-list-bounces@redhat.com>
Received: from shell.devel.redhat.com (shell.devel.redhat.com [10.10.36.195])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id
	mBOJuu0Z013970
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 14:56:56 -0500
Received: from shell.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by shell.devel.redhat.com (8.13.8/8.13.8) with ESMTP id mBOJuuSd013210
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 14:56:56 -0500
Received: (from alan@localhost)
	by shell.devel.redhat.com (8.13.8/8.13.8/Submit) id mBOJuua6013209
	for video4linux-list@redhat.com; Wed, 24 Dec 2008 14:56:56 -0500
Date: Wed, 24 Dec 2008 14:56:56 -0500
From: Alan Cox <alan@redhat.com>
To: video4linux-list Mailing List <video4linux-list@redhat.com>
Message-ID: <20081224195656.GA12626@shell.devel.redhat.com>
References: <20081224140706.GA475@geppetto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224140706.GA475@geppetto>
Subject: Re: V4L1: what's the meaning of video_window.chromakey?
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

On Wed, Dec 24, 2008 at 03:07:06PM +0100, Stefano Sabatini wrote:
> My guess is that V4L is using the simplest possible chromakeying
> algorithm, so that it copies each pixel from the capture buffer to
> the destination buffer with a value different from
> video_window.chromakey.

Chroma key is supported just for hardware that does it. Mostly old ISA hardware
could do chromakey overlay but nothing else. I think the PMS is the only card
with V4L1 one support that ever had chromakey in a production kernel.

Its also analogue side chromakey so "kind of the same shade as" rather than
24bit match.

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
