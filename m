Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50096 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab0CKRwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 12:52:24 -0500
Date: Thu, 11 Mar 2010 09:52:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
Message-ID: <20100311175214.GB7467@core.coreip.homeip.net>
References: <4B99104B.3090307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B99104B.3090307@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Mar 11, 2010 at 12:46:19PM -0300, Mauro Carvalho Chehab wrote:
> In order to allow userspace programs to autoload an IR table, a link is
> needed to point to the corresponding input device.
> 
> $ tree /sys/class/irrcv/irrcv0
> /sys/class/irrcv/irrcv0
> |-- current_protocol
> |-- input -> ../../../pci0000:00/0000:00:0b.1/usb1/1-3/input/input22
> |-- power
> |   `-- wakeup
> |-- subsystem -> ../../../../class/irrcv
> `-- uevent
> 
> It is now easy to associate an irrcv device with the corresponding
> device node, at the input interface.
> 

I guess the question is why don't you make input device a child of your
irrcvX device? Then I believe driver core will link them properly. It
will also ensure proper power management hierarchy.

That probably will require you changing from class_dev into device but
that's the direction kernel is going to anyway.

Thanks.

-- 
Dmitry
