Return-path: <mchehab@localhost>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46575 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1GMPaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 11:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107131118550.2156-100000@iolanthe.rowland.org>
References: <CACVXFVOGiJswRQ+5kJd7HW3Zyow9hrC6+HR=fB5o6o=iH-ca3A@mail.gmail.com>
	<Pine.LNX.4.44L0.1107131118550.2156-100000@iolanthe.rowland.org>
Date: Wed, 13 Jul 2011 23:30:09 +0800
Message-ID: <CACVXFVPJvuzKZetupzBf+GhwZKV10EHjpNUwTz98sweH3xkd4w@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On Wed, Jul 13, 2011 at 11:20 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> Why should system suspend be different from runtime suspend?  Have you

This is also my puzzle, :-)

> compared usbmon traces for the two types of suspend?

Almost same. If I add USB_QUIRK_RESET_RESUME quirk for the device,
the stream data will not be received from the device in runtime pm case,
same with that in system suspend.

Maybe buggy BIOS makes root hub send reset signal to the device during
system suspend time, not sure...

thanks,
-- 
Ming Lei
