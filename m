Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QFfYcF004717
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 11:41:34 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QFfILN031315
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 11:41:19 -0400
Received: by mu-out-0910.google.com with SMTP id w8so1538782mue.1
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 08:41:17 -0700 (PDT)
Date: Mon, 26 May 2008 17:41:23 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Linux Driver Developers <devel@driverdev.osuosl.org>,
	video4linux-list@redhat.com
Message-ID: <20080526154123.GA22979@ska.dandreoli.com>
References: <20080525020028.GA22425@ska.dandreoli.com>
	<20080526073959.5a624288@gaivota>
	<20080526145830.GA22459@ska.dandreoli.com>
	<20080526121513.60a1ea21@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526121513.60a1ea21@gaivota>
Cc: 
Subject: Re: TW6800 based video capture boards
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

On Mon, May 26, 2008 at 12:15:13PM -0300, Mauro Carvalho Chehab wrote:
> 
> > I have also some thoughts for bttv-risc.c. What is it? It is used
> > to generate any RISC op-codes to be downloaded on the board? It seem
> > responsible for DMA operations.
> 
> Yes, that's the idea. Those chips have a set of risc instructions that needed
> to be loaded. Those risc code will command data send, via DMA, to the
> motherboard.

It looks that also TW6800 has this machinery with similar instructions.
I could start an all-private risc file and let see what happens as
time flows.

> bttv, cx88 and cx23885 drivers share the same risc code,
> provided by btcx-risc.c. bttv-risc.c has some code that is specific for bttv.

btcx-risc.c is not modified bby the upstream patch.

> If you are willing to write a new driver, I suggest you to use a more modern
> driver as a model. I would suggest you to take cx88 as a model.

great ;)

ciao,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
