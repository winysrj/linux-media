Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42870 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S933904AbdC3O0e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 10:26:34 -0400
Date: Thu, 30 Mar 2017 10:26:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oliver Neukum <oneukum@suse.com>
cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Mosberger <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        GregKroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        John Youn <johnyoun@synopsys.com>,
        Roger Quadros <rogerq@ti.com>,
        Linux Doc MailingList <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be
 aligned
In-Reply-To: <1490878570.11920.6.camel@suse.com>
Message-ID: <Pine.LNX.4.44L0.1703301024090.2186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017, Oliver Neukum wrote:

> > Btw, I'm a lot more concerned about USB storage drivers. When I was
> > discussing about this issue at the #raspberrypi-devel IRC channel,
> > someone complained that, after switching from the RPi downstream Kernel
> > to upstream, his USB data storage got corrupted. Well, if the USB
> > storage drivers also assume that the buffer can be continuous,
> > that can corrupt data.

> 
> They do assume that.

Wait a minute.  Where does that assumption occur?

And exactly what is the assumption?  Mauro wrote "the buffer can be 
continuous", but that is certainly not what he meant.

Alan Stern
