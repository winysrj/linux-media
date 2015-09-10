Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48870 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbbIJIAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 04:00:40 -0400
From: "Kaukab, Yousaf" <yousaf.kaukab@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@osg.samsung.com" <mchehab@osg.samsung.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH v1] media: uvcvideo: handle urb completion in a work
 queue
Date: Thu, 10 Sep 2015 08:00:28 +0000
Message-ID: <B1AFEC30BE3ADF488E833B59904F5C321D99E686@IRSMSX107.ger.corp.intel.com>
References: <2075897.6pASZPILMt@avalon>
 <Pine.LNX.4.44L0.1509091226310.2045-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1509091226310.2045-100000@iolanthe.rowland.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Wednesday, September 9, 2015 6:30 PM
> To: Laurent Pinchart
> Cc: Hans de Goede; Kaukab, Yousaf; linux-media@vger.kernel.org;
> mchehab@osg.samsung.com; linux-usb@vger.kernel.org
> Subject: Re: [PATCH v1] media: uvcvideo: handle urb completion in a work
> queue
> 
> On Wed, 9 Sep 2015, Laurent Pinchart wrote:
> 
> > > > Instead of fixing the issue in the uvcvideo driver, would it then
> > > > make more sense to fix it in the remaining hcd drivers ?
> > >
> > > Unfortunately that's not so easy.  It involves some subtle changes
> > > related to the way isochronous endpoints are handled.  I wouldn't
> > > know what to change in any of the HCDs, except the ones that I maintain.
> >
> > I'm not saying it would be easy, but I'm wondering whether it makes
> > change to move individual USB device drivers to work queues when the
> > long term goal is to use tasklets for URB completion anyway.
> 
> I'm not sure that this is a long-term goal for every HCD.  For instance, there
> probably isn't much incentive to convert a driver if its host controllers can only
> run at low speed or full speed.
> 

I can convert this patch to use tasklets instead and only schedule the
tasklet if urb->complete is called in interrupt context. This way, hcd
using tasklet or not, uvc driver behavior will be almost same. Only
difference is that local interrupts will still be enabled when tasklet 
scheduled from uvc driver is executing the completion function.

This patch can be dropped once all hcd's start using tasklets for the
completion callback (if that ever happens).

BR,
Yousaf
