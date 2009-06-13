Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bcode.com ([150.101.204.108]:13888 "EHLO mail.bcode.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751090AbZFMApY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 20:45:24 -0400
Date: Sat, 13 Jun 2009 10:45:24 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: GPL code for Omnivision USB video camera available.
Message-Id: <20090613104524.781027d8.erik@bcode.com>
In-Reply-To: <4A31FB0A.8030104@redhat.com>
References: <20090612110228.3f7e42ab.erik@bcode.com>
	<4A31FB0A.8030104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:

> This looks to me like its just ov51x-jpeg made to compile with the
> latest kernel.

Its more than that. This driver supports a number of cameras and the
only one we (bCODE) are really interested in is the ovfx2 driver.

> Did you make any functional changes?

I believe the ovfx2 driver is completely new.

> Also I wonder if you're subscribed to the (low trafic) ov51x-jpeg
> mailinglist, that seems to be the right thing todo for someone who tries
> to get that driver in to the mainline.

Sorry its the ovfx2 that I'm interested in pushing into  the kernel.

> May I ask what cam you have? I could certainly use more people testing
> this.

It looks like this on the USB bus:

    Bus 007 Device 002: ID 05a9:2800 OmniVision Technologies, Inc. 

Cheers,
Erik
-- 
=======================
erik de castro lopo
senior design engineer

bCODE
level 2, 2a glen street
milsons point
sydney nsw 2061
australia

tel +61 (0)2 9954 4411
fax +61 (0)2 9954 4422
www.bcode.com
