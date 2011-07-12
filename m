Return-path: <mchehab@localhost>
Received: from netrider.rowland.org ([192.131.102.5]:50366 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751054Ab1GLPoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 11:44:54 -0400
Date: Tue, 12 Jul 2011 11:44:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Ming Lei <tom.leiming@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>,
	<linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia
 camera
In-Reply-To: <CACVXFVOL67EjcMxfizC0JR-=wraNTneZicw_OBfCGkseZh7Lig@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107121143500.31381-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Tue, 12 Jul 2011, Ming Lei wrote:

> Hi Laurent,
> 
> After resume from sleep,  all the ISO packets from camera are like below:
> 
> ffff880122d9f400 3527230728 S Zi:1:004:1 -115:1:2568 32 -18:0:1600
> -18:1600:1600 -18:3200:1600 -18:4800:1600 -18:6400:1600 51200 <
> ffff880122d9d400 3527234708 C Zi:1:004:1 0:1:2600:0 32 0:0:12
> 0:1600:12 0:3200:12 0:4800:12 0:6400:12 51200 = 0c8c0000 0000fa7e
> 012f1b05 00000000 00000000 00000000 00000000 00000000
> 
> All are headed with 0c8c0000, see attached usbmon captures.

Maybe this device needs a USB_QUIRK_RESET_RESUME entry in quirks.c.

Alan Stern

