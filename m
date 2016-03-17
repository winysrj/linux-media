Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:46150 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112AbcCQKxn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 06:53:43 -0400
Date: Thu, 17 Mar 2016 10:53:40 +0000
From: Sean Young <sean@mess.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: reduce size of struct ir_raw_event
Message-ID: <20160317105340.GA10247@gofer.mess.org>
References: <56E9CDAE.2040200@gmail.com>
 <20160316222826.GA6635@gofer.mess.org>
 <56EA517B.5030903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56EA517B.5030903@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 17, 2016 at 07:40:59AM +0100, Heiner Kallweit wrote:
> Am 16.03.2016 um 23:28 schrieb Sean Young:
> > On Wed, Mar 16, 2016 at 10:18:38PM +0100, Heiner Kallweit wrote:
> >> +	u8		pulse:1;
> >> +	u8		reset:1;
> >> +	u8		timeout:1;
> >> +	u8		carrier_report:1;
> > 
> > Why are you changing the type of the bitfields? 
> > 
> I did this to make sure that the compiler uses one byte for
> the bit field. When testing gcc also used just one byte when
> keeping the original "unsigned" type for the bit field members.
> Therefore it wouldn't be strictly neeeded.
> 
> But I'm not sure whether it's guaranteed that the compiler packs a
> bit field to the smallest possible data type and we can rely on it.
> AFAIK C99 is a little more specific about this implementation detail of
> bit fields but C89/C90 is used for kernel compilation.

It might be worth reading about structure packing rules rather than
guessing.


Sean
