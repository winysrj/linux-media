Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48202 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbbIIIni (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 04:43:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH v1] media: uvcvideo: handle urb completion in a work queue
Date: Wed, 09 Sep 2015 11:43:36 +0300
Message-ID: <1866316.khDarOHzbX@avalon>
In-Reply-To: <55EFEE14.5050100@redhat.com>
References: <Pine.LNX.4.44L0.1509081035070.1533-100000@iolanthe.rowland.org> <55EFEE14.5050100@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 09 September 2015 10:30:12 Hans de Goede wrote:
> On 08-09-15 16:36, Alan Stern wrote:
> > On Tue, 8 Sep 2015, Hans de Goede wrote:
> >> On 09/07/2015 06:23 PM, Mian Yousaf Kaukab wrote:
> >>> urb completion callback is executed in host controllers interrupt
> >>> context. To keep preempt disable time short, add urbs to a list on
> >>> completion and schedule work to process the list.
> >>> 
> >>> Moreover, save timestamp and sof number in the urb completion callback
> >>> to avoid any delays.
> >> 
> >> Erm, I thought that we had already moved to using threaded interrupt
> >> handling for the urb completion a while (1-2 years ?) back. Is this then
> >> still needed ?
> > 
> > We moved to handling URB completions in a tasklet, not a threaded
> > handler.
> 
> Right.
> 
> > (Similar idea, though.)  And the change was made in only one
> > or two HCDs, not in all of them.
> 
> Ah, I was under the impression this was a core change, not a per
> hcd change.

Instead of fixing the issue in the uvcvideo driver, would it then make more 
sense to fix it in the remaining hcd drivers ?

-- 
Regards,

Laurent Pinchart

