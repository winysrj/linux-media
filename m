Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44028 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751098AbcIOTN6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 15:13:58 -0400
Date: Thu, 15 Sep 2016 15:13:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Wade Berrier <wberrier@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, <linux-media@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: mceusb xhci issue?
In-Reply-To: <20160910195811.GA4941@berrier.lan>
Message-ID: <Pine.LNX.4.44L0.1609151447410.1396-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 10 Sep 2016, Wade Berrier wrote:

> On Thu Aug 11 16:18, Alan Stern wrote:
> > I never received any replies to this message.  Should the patch I 
> > suggested be merged?
> >
> 
> Hello,
> 
> I applied this updated patch to the fedora23 4.7.2 kernel and the mceusb
> transceiver works as expected.

Thank you for testing.  Can you provide the "lsusb -v" output for the
troublesome IR transceiver?

Alan Stern

