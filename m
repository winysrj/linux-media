Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:50204 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754355Ab2JUCTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 22:19:09 -0400
Date: Sat, 20 Oct 2012 22:19:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
cc: bp@alien8.de, <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <security@kernel.org>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
In-Reply-To: <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
Message-ID: <Pine.LNX.4.44L0.1210202215350.5948-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 20 Oct 2012, Artem S. Tashkinov wrote:

> You don't get me - I have *no* VirtualBox (or any proprietary) modules running
> - but I can reproduce this problem using *the same system running under* VirtualBox
> in Windows 7 64.
> 
> It's almost definitely either a USB driver bug or video4linux driver bug:

Does the same thing happen with earlier kernel versions?

What about if you unload snd-usb-audio or ehci-hcd?

Alan Stern

