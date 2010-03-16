Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f211.google.com ([209.85.218.211]:48654 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab0CPQph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 12:45:37 -0400
Received: by bwz3 with SMTP id 3so166841bwz.29
        for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 09:45:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37db8fe3121673cfbdce84e1de5ee844.squirrel@webmail.xs4all.nl>
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C7FCA3BF@bssrvexch01.BS.local>
	 <4B9E1931.8060006@redhat.com>
	 <b320a5b9ff16d1df8ecc6272a7fe2c14.squirrel@webmail.xs4all.nl>
	 <4B9E5EF1.2000600@redhat.com>
	 <e1551c2096f8616e8b01344b1af51a51.squirrel@webmail.xs4all.nl>
	 <4B9E6DC4.5010301@redhat.com>
	 <1268695849.3081.16.camel@palomino.walls.org>
	 <000e01cac4f1$50b1ea40$f215bec0$%osciak@samsung.com>
	 <37db8fe3121673cfbdce84e1de5ee844.squirrel@webmail.xs4all.nl>
Date: Tue, 16 Mar 2010 12:45:31 -0400
Message-ID: <829197381003160945k7c48b347wfe5c0a06204f9105@mail.gmail.com>
Subject: Re: Magic in videobuf
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <p.osciak@samsung.com>, Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 16, 2010 at 12:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> That is my opinion, yes. However, there is one case where this is actually
> useful. Take for example the function videobuf_to_dma in
> videobuf-dma-sg.c. This is called by drivers and it makes sense that that
> function should double-check that the videobuf_buffer is associated with
> the dma_sg memtype.
>
> But calling this 'magic' is a poor choice of name. There is nothing magic
> about it, in this case it is just an identifier of the memtype. And there
> may be better ways to do this check anyway.

It's funny, because when I saw the word "magic", I knew *exactly* what
it did.  The notion of putting a magic value at the top of a structure
is not that uncommon (although you don't see it in Linux much).  I've
seen it done many times over the years (all using the term "magic"
which is why I knew what it did).  The cases where it is really
helpful is when you have lots of (void *) pointers in your buffer
management code, as it lets you detect cases where a function gets
passed the wrong buffer type (which wouldn't fail a compile time due
to the void * pointer).  And by using different magic values for
different structure types, in many cases it will give you a hint where
the problem is (because you would now know *what* type of structure
got passed into the function).

That said, these sorts of cases usually aren't usually intended to
catch *random* memory corruption as they are to help isolate problems
in buffer handling code.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
