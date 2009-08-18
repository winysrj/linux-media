Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:50305 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758714AbZHRLAq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 07:00:46 -0400
Date: Tue, 18 Aug 2009 13:00:41 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] au0828: experimental support for Syntek Teledongle
 [05e1:0400]
Message-ID: <20090818110041.GA14710@linuxtv.org>
References: <bc18792f0908171325s391d9e36nb0ce20f40017678@mail.gmail.com>
 <37219a840908171359m152363a2ub377abe6e27ff237@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840908171359m152363a2ub377abe6e27ff237@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 17, 2009 at 04:59:42PM -0400, Michael Krufky wrote:
> 
> variations, nobody has ever verified that the GPIO programming is safe
> to use, and there is no way to prevent the potentially harmful code
> from running on the wrong device.
> 
> I, personally, do not want the responsibility of explaining to users
> that their usb sticks may be damaged because of code that got merged

I would be interested to know if someone _actually_ managed
to break their hardware by using buggy drivers.  IANAL but
I think that consumer electronics hardware which can be damaged by
software is broken by design.  A vendor selling such hardware is
stupid because people would return the broken hardware and get
a replacement.  I don't see how a vendor could proof that the device
was not damaged by an obscure bug in the Windows driver to get
around their responsibility to replace broken hardware within
the warranty period.


Johannes
