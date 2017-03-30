Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43145 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934033AbdC3U6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:58:15 -0400
Message-ID: <1490907435.11920.11.camel@suse.com>
Subject: Re: [PATCH 22/22] usb: document that URB transfer_buffer should be
 aligned
From: Oliver Neukum <oneukum@suse.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: David Mosberger <davidm@egauge.net>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        GregKroah-Hartman <gregkh@linuxfoundation.org>,
        linux-rpi-kernel@lists.infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        John Youn <johnyoun@synopsys.com>,
        Roger Quadros <rogerq@ti.com>,
        Linux Doc MailingList <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Date: Thu, 30 Mar 2017 22:57:15 +0200
In-Reply-To: <Pine.LNX.4.44L0.1703301152300.1555-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1703301152300.1555-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 30.03.2017, 11:55 -0400 schrieb Alan Stern:
> 
> I'm pretty sure that usb-storage does not do this, at least, not when 
> operating in its normal Bulk-Only-Transport mode.  It never tries to 
> read the results of an earlier transfer after carrying out a later 
> transfer to any part of the same buffer.

The storage driver takes buffers as the block layer (or sg) provide
them, does it not?

	Regards
		Oliver
