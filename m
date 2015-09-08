Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42293 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755180AbbIHOgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2015 10:36:53 -0400
Date: Tue, 8 Sep 2015 10:36:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
	<laurent.pinchart@ideasonboard.com>, <linux-media@vger.kernel.org>,
	<mchehab@osg.samsung.com>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v1] media: uvcvideo: handle urb completion in a work
 queue
In-Reply-To: <55EEDA4E.50504@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1509081035070.1533-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 8 Sep 2015, Hans de Goede wrote:

> Hi,
> 
> On 09/07/2015 06:23 PM, Mian Yousaf Kaukab wrote:
> > urb completion callback is executed in host controllers interrupt
> > context. To keep preempt disable time short, add urbs to a list on
> > completion and schedule work to process the list.
> >
> > Moreover, save timestamp and sof number in the urb completion callback
> > to avoid any delays.
> 
> Erm, I thought that we had already moved to using threaded interrupt
> handling for the urb completion a while (1-2 years ?) back. Is this then
> still needed ?

We moved to handling URB completions in a tasklet, not a threaded
handler.  (Similar idea, though.)  And the change was made in only one
or two HCDs, not in all of them.

Alan Stern

