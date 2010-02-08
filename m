Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43936 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab0BHPwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 10:52:15 -0500
Date: Mon, 8 Feb 2010 16:52:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pekka Sarnila <sarnila@adit.fi>
Cc: Jiri Slaby <jslaby@suse.cz>,
	Pekka Sarnila <pekka.sarnila@qvantel.com>, crope@iki.fi,
	linux-media@vger.kernel.org, pb@linuxtv.org, js@linuxtv.org
Subject: Re: dvb-usb-remote woes [was: HID: ignore afatech 9016]
In-Reply-To: <4B6C3D79.5080203@adit.fi>
Message-ID: <alpine.LNX.2.00.1002081650260.30967@pobox.suse.cz>
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz> <4B5EFD69.4080802@adit.fi> <alpine.LNX.2.00.1001262344200.30977@pobox.suse.cz>
 <4B671C31.3040902@qvantel.com> <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz> <4B672EB8.3010609@suse.cz> <4B6C3D79.5080203@adit.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Feb 2010, Pekka Sarnila wrote:

> > Can't be HID bus with a specific driver used instead now?
> 
> Well it could, but this way it is much less work and more generic. I use many
> different joysticks, yokes and pedals. And with some generic modifications and
> improvements into generic HID layer and generic input layer all worked well.
> Only joystick layer got to be completely rewritten.
> 
> I did never put this upstream because by the time I got my own patches
> integrated to the (new) kernel, the hid/input layer had developed so much that
> the patches could no more be used in the latest kernel. So I hand applied them
> again, and again kernel had moved on, and so on. Also to argue for patches
> that cover several areas and several maintainers is difficult, and changing a
> lot at once is always risky. So I gave up.
> 
> If anyone is interested, I could take a look again and see if the changes
> could be argued and applied incrementally instead of one big bunch.

Hi Pekka,

yes, we are definitely interested (or at least I am).

The major rewrite of the HID core to be full-fledged bus was done exactly 
so that it's easier to add support for new devices, while keeping the main 
code clean.

Even if you have problems porting the drivers to new infrastructure, you 
can always post wha you have -- I believe that we will be able to sort it 
out quickly.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
