Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34601 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0KOMGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 07:06:31 -0500
Received: by fxm6 with SMTP id 6so1660103fxm.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 04:06:30 -0800 (PST)
Date: Mon, 15 Nov 2010 13:05:59 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	stefano.pompa@gmail.com
Subject: Re: Hauppauge WinTV MiniStick IR in 2.6.36 - [PATCH]
Message-ID: <20101115120559.GA9845@linux-m68k.org>
References: <20101115112746.GB6607@linux-m68k.org> <AANLkTi=DEJ4ku24vhsWcmY=w0oaycxsoTrYV7AfJzqUM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=DEJ4ku24vhsWcmY=w0oaycxsoTrYV7AfJzqUM@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Nov 15, 2010 at 01:55:00PM +0200, Anca Emanuel wrote:
> On Mon, Nov 15, 2010 at 1:27 PM, Richard Zidlicky <rz@linux-m68k.org> wrote:
> > Hi,
> <snip>
> > What is the way to achieve the effect without recompiling the kernel - is there any?
> 
> On Ubuntu kernel list Chao Zhang asked the same question.
> Answer:
> [quote]
> You might find following links useful:
> 
> http://tldp.org/LDP/lkmpg/2.6/html/x181.html
> http://www.cyberciti.biz/tips/build-linux-kernel-module-against-installed-kernel-source-tree.html
> [/quote]

thanks, personally I have no problem with recompiling the kernel and doing it anyways
- I was hoping the new IR framework has something equivalent to a loadkeys. Maybe even 
loadkeys would work? Not tried yet and it certainly would require some work to define
the keymaps and such.

In any case for the average user there must be something better than patching the kernel.

Richard
