Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:55849 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932816Ab2JXRRF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 13:17:05 -0400
Date: Thu, 25 Oct 2012 01:17:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>, linux-usb@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [balbi-usb:i2c-transferred-bytes-on-NACK 7/9]
 drivers/media/i2c/adv7604.c:406:9: warning: initialization makes integer
 from pointer without a cast
Message-ID: <20121024171702.GA6521@localhost>
References: <5087e56f.wwcO2kZCKDOco89b%fengguang.wu@intel.com>
 <20121024132323.GA16927@localhost>
 <20121024133720.GF21735@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024133720.GF21735@arwen.pp.htv.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 24, 2012 at 04:37:20PM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Oct 24, 2012 at 09:23:23PM +0800, Fengguang Wu wrote:
> > Sorry, this should really be CCed to the media list.
> > I'll use the list recommended by get_maintainer.pl in future.
> 
> Actually, I would suggest only testing the following branches from my
> tree:
> 
> dwc3, musb, xceiv, gadget and fixes
> 
> Those are my final branches, everything else is a temporary branch that
> I'm using just so I don't loose some patches, or to make it easy for
> other guys to test patches.

Balbi, thanks for the instructions. I'll limit future tests to the
above branches.

Thanks,
Fengguang
