Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38220 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754687AbdCaOHH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 10:07:07 -0400
Date: Fri, 31 Mar 2017 10:07:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oliver Neukum <oneukum@suse.com>
cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        David Mosberger <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
In-Reply-To: <1490907435.11920.11.camel@suse.com>
Message-ID: <Pine.LNX.4.44L0.1703311000310.2199-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017, Oliver Neukum wrote:

> Am Donnerstag, den 30.03.2017, 11:55 -0400 schrieb Alan Stern:
> > 
> > I'm pretty sure that usb-storage does not do this, at least, not when 
> > operating in its normal Bulk-Only-Transport mode.  It never tries to 
> > read the results of an earlier transfer after carrying out a later 
> > transfer to any part of the same buffer.
> 
> The storage driver takes buffers as the block layer (or sg) provide
> them, does it not?

Yes.  But it does not read the data from an earlier transfer after 
carrying out a later transfer on the same buffer.

The only possible example would be if the sense buffer for a command 
occupied part of the same block as the data buffer.  But this can't 
happen, because the sense buffer is allocated separately by its own 
kzalloc_node() call in scsi_init_request().

Alan Stern
