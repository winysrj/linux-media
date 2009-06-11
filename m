Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760318AbZFKTVy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 15:21:54 -0400
Message-ID: <4A3159AD.4070201@redhat.com>
Date: Thu, 11 Jun 2009 21:23:25 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Joe Belford <joebelford@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: SPCA505 and 506 with X10 VA11A
References: <246c01f50906081845j4d8d062enbd9644edb0cf4d1d@mail.gmail.com>
In-Reply-To: <246c01f50906081845j4d8d062enbd9644edb0cf4d1d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/09/2009 03:45 AM, Joe Belford wrote:
> I have an X10 VA11A I'd like to get working with V4L2.  As some are
> probably aware this device shares a vendor/product id with another
> webcam that uses the spca505 module.  I've been through the source for
> these modules and noticed the fixme's and was wondering If someone
> could suggest a starting point to get this working.

If you plug it in on a system with a recent kernel and libv4l installed
and then try to use it, what happens ?

If it shares the usb-id it most likely actually has an spca505 IC, and
chances are it just works.

Regards,

Hans
