Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34267 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbcDHO0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Apr 2016 10:26:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id F3DE121B17
	for <linux-media@vger.kernel.org>; Fri,  8 Apr 2016 10:26:01 -0400 (EDT)
Date: Fri, 8 Apr 2016 07:26:00 -0700
From: Greg KH <greg@kroah.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Matthew Giassa <matthew@giassa.net>, linux-media@vger.kernel.org,
	Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: USB xHCI regression after upgrading from kernel 3.19.0-51 to
 4.2.0-34.
Message-ID: <20160408142600.GB4793@kroah.com>
References: <20160407083643.fccade4f64c1f11ce2bc6da07fd9ab91.977bcc175f.wbe@email16.secureserver.net>
 <5707710E.1000907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5707710E.1000907@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 08, 2016 at 10:51:26AM +0200, Hans de Goede wrote:
> Hi,
> 
> It is probably best to resend this mail to
> linux-usb <linux-usb@vger.kernel.org>
> since this is more of a usb problem then a v4l2 problem,
> and all the usb experts are subscribed to that list.

Heh, I told him to send it to linux-media, sorry about that.

greg k-h
