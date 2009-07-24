Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:54159 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZGXHbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 03:31:18 -0400
Date: Fri, 24 Jul 2009 10:20:53 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: New tree with final (?) string control implementation
Message-ID: <20090724072053.GA32642@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <200907232354.46673.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907232354.46673.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jul 23, 2009 at 11:54:46PM +0200, ext Hans Verkuil wrote:
> Hi Eduardo,
> 
> I've prepared a new tree:
> 
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-strctrl

good.

> 
> This contains the full string control implementation, including updates to 
> the v4l2-spec, based on the RFC that I posted on Monday.

Right.

> 
> Can you prepare your si4713 patches against this tree and verify that 
> everything is working well?

Sure, I've been off work last two weeks. But now I'm back and will get this
task soon.

> 
> If it is, then I can make a pull request for this tree and soon after that 
> you should be able to merge your si4713 driver as well. If I'm not mistaken 
> the string controls API is the only missing bit that prevents your driver 
> from being merged.

Yeah. There use to have three dependencies: subdev changes (i2c), modulator
capabilities and ext ctl string support. I recall now that subdev is already
merged. I'm not sure about the modulator support.

> 
> Thanks,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
