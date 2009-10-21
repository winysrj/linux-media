Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:35087 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZJUXhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 19:37:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: uvcvideo causes ehci_hcd to halt
Date: Thu, 22 Oct 2009 01:38:06 +0200
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0910211052200.2847-100000@iolanthe.rowland.org> <200910211927.00298.laurent.pinchart@ideasonboard.com> <4ADF6A8A.3070109@pardus.org.tr>
In-Reply-To: <4ADF6A8A.3070109@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910220138.06878.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 October 2009 22:09:46 Ozan Çağlayan wrote:
> Laurent Pinchart wrote:
> > Probably because hal opens the device to query its capabilities and
> > closes it right after. The driver submits the interrupt URB when the
> > first user opens the device and cancels it when the last user closes the
> > device.
> 
> So who's guilty now?
> 
> :)

Not me :-)

I don't think there's anything wrong with submitting an interrupt URB and 
canceling it soon after.

-- 
Regards,

Laurent Pinchart
