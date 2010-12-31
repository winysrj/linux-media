Return-path: <mchehab@gaivota>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46733 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0LaPES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 10:04:18 -0500
From: Ben Gamari <bgamari.foss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, aospan@netup.ru
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
In-Reply-To: <4D1DC2DD.6050400@infradead.org>
References: <201012310726.31851.liplianin@netup.ru> <201012311212.19715.laurent.pinchart@ideasonboard.com> <4D1DBE2A.5080003@infradead.org> <201012311230.51903.laurent.pinchart@ideasonboard.com> <4D1DC2DD.6050400@infradead.org>
Date: Fri, 31 Dec 2010 10:04:13 -0500
Message-ID: <8739pec7bm.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 31 Dec 2010 09:47:41 -0200, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > I understand this. However, a complete JTAG state machine in the kernel, plus 
> > an Altera firmware parser, seems to be a lot of code that could live in 
> > userspace.
> 
> Moving it to userspace would mean a kernel driver that would depend on an
> userspace daemon^Wfirmware loader to work. I would NAK such designs.
> 
Why? I agree that JTAG is a lot to place in the kernel and is much
better suited to be in user space. What exactly is your objection to
depending on a userspace utility? There is no shortage of precedent for
loading firmware in userspace (e.g. fx2 usb devices).

> > If I understand it correctly the driver assumes the firmware is in an Altera 
> > proprietary format. If we really want JTAG code in the kernel we should at 
> > least split the file parser and the TAP access code.
> > 
> 
> Agreed, but I don't think this would be a good reason to block the code merge
> for .38.
> 
I agree with the above isn't good reason to block it but if there is
still debate about the general architecture of the code (see above),
then it seems aren't ready yet. The code looks very nice, but I'm not at
all convinced that it needs to be in the kernel. Just my two-tenths of a
cent.

Cheers,
- Ben
