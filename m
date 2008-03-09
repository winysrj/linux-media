Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m298uAL8016918
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 04:56:10 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m298tVNr009538
	for <video4linux-list@redhat.com>; Sun, 9 Mar 2008 04:55:32 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1088174fga.7
	for <video4linux-list@redhat.com>; Sun, 09 Mar 2008 00:55:31 -0800 (PST)
Message-ID: <47D3A5FE.9000803@claranet.fr>
Date: Sun, 09 Mar 2008 09:55:26 +0100
From: Eric Thomas <ethomas@claranet.fr>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <47C40563.5000702@claranet.fr>	<47D24404.9050708@claranet.fr>
	<20080308075929.3ccbd012@gaivota>
In-Reply-To: <20080308075929.3ccbd012@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux <video4linux-list@redhat.com>, g.liakhovetski@pengutronix.de,
	Brandon Philips <bphilips@suse.de>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

Mauro Carvalho Chehab wrote:
> On Sat, 08 Mar 2008 08:45:08 +0100
> Eric Thomas <ethomas@claranet.fr> wrote:
> 
>> Eric Thomas wrote:
>>> Hi all,
>>>
>>> My box runs with kernel 2.6.24 + main v4l-dvb tree from HG.
>>> The card is a Haupauge HVR-3000 running in analog mode only. No *dvd* 
>>> module loaded.
>>> Since this videobuf-dma-sg patch, I face kernel oops in several
>>> situations.
>>> These problems occur with real tv applications, but traces below come
>>> from the capture_example binary from v4l2-apps/test.
> 
> Although I don't believe that this is related to the conversion to generic DMA
> API.

Indeed, or I wouldn't be the only one (?) to complain.

> Anyway, I'm enclosing a patch reverting the changeset. It is valuable if people
> can test to revert this and see if the issue remains.

It does, unsurprisingly to me.
Thanks for the patch.

> I suspect, however, that the bug is on some other place, and it is related to
> some bad locking. It seems that STREAMOFF processing here interrupted by a
> video buffer arrival, at IRQ code.
> 
> PS.: I'm c/c Brandon, since he is working on fixing a bad lock on videobuf_dma.

I guess that the best thing I can do for now is waiting.
If Brandon or someone else wants me to test anything, feel free to
contact me.

Regards,
Eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
