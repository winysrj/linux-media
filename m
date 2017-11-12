Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42349 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750948AbdKLVGX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Nov 2017 16:06:23 -0500
Date: Sun, 12 Nov 2017 21:06:21 +0000
From: Sean Young <sean@mess.org>
To: Laurent Caumont <lcaumont2@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
Message-ID: <20171112210621.ioiifofimuuvmzf7@gofer.mess.org>
References: <20171029193121.p2q6dxxz376cpx5y@gofer.mess.org>
 <CACG2urwdnXs2v8hv24R3+sNW6qOifh6Gtt+semez_c8QC58-gA@mail.gmail.com>
 <20171107084245.47dce306@vento.lan>
 <CACG2ury9Ab3pHGVyNLQeOH03TF3r_oeX1h3=AuJ5XzNgjx+yag@mail.gmail.com>
 <20171111105643.ozwukzmdhalxhoho@gofer.mess.org>
 <CACG2urwv1dTtEW5vuspTF5A3t2F1s-iRPZE5SiCt9o8k+k71hA@mail.gmail.com>
 <20171111180159.fb33mc2t467ygfqw@gofer.mess.org>
 <CACG2uryHHu-vvHj0B1wGRYZuczB5_8cbD3LBscaBmbN-LFJQMg@mail.gmail.com>
 <20171111205527.g5dach2rmhlxmr5x@gofer.mess.org>
 <CACG2urxfW-O_AEhOKFApxxSdoSxJRkaTd1TNQ-6jNxouquB2fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACG2urxfW-O_AEhOKFApxxSdoSxJRkaTd1TNQ-6jNxouquB2fA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 12, 2017 at 09:38:47AM +0100, Laurent Caumont wrote:
> Hi Sean,
> 
> Thank you for the changes, It's better like this, I will test it.

Great, thanks. Please let us know if it works, then it can be included.

> Don't you think that a much better way would be to make the kalloc
> directly inside dvb_usb_generic_rw instead of changing each call of
> it? Are you sure there are no other mistake somewhere else ?

That would introduce an extra kmalloc and memcpy in that function, and
for many call sites that would be unnecesary, so it would be inefficient.


Sean
