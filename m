Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QDfvpw012834
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 09:41:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QDfj4e020084
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 09:41:45 -0400
Date: Mon, 26 May 2008 10:41:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080526104130.355b6f41@gaivota>
In-Reply-To: <200805072252.16704.tobias.lorenz@gmx.net>
References: <200805072252.16704.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 1/2] v4l2: hardware frequency seek ioctl interface
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

On Wed, 7 May 2008 22:52:16 +0200
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:

> Hi Mauro,
> Hi Keith,
> 
> based on the radio hardware frequency seek patch from Keith, I propose the following patch.
> Mainly it introduces a new ioctl VIDIOC_S_HW_FREQ_SEEK.
> The following options can be set: seek_upward, wrap_around.
> I removed the start_freq from the original proposal, as I see no use case for it.
> Usually you want to start searching at the current frequency and if not VIDIOC_S_FREQUENCY can be used.
> 
> The first part of the patch contains the driver independent part of VIDIOC_S_HW_FREQ_SEEK.
> The second part of the patch contains a modification to the radio-si470x driver to support the new ioctl.
> 
> Testing of the new interface was done by a modified version of fmseek from the fmtools package, that I can provide on request.
> Hardware specific options to change the seek behaviour are implemented using private video controls.
> For this it was necessary to introduce a new header file for the radio-si470x private video control definitions, but I also moved all hardware register definitions to it.
> 
> The current patch is against linux-2.6.25.
> I can provide one against the current mercurial version on request.

The patch itself looks good. However, there are several codingstyle errors. Please run checkpatch.pl against it and send me again, having the pointed issues fixed.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
