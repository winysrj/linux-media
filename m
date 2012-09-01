Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52116 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2IAOWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 10:22:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Landley <rob@landley.net>,
	LMML <linux-media@vger.kernel.org>, hverkuil@xs4all.nl
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
Date: Sat, 01 Sep 2012 16:22:30 +0200
Message-ID: <8524664.XGp3WDre5y@avalon>
In-Reply-To: <20120901095707.GB6348@valkosipuli.retiisi.org.uk>
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com> <CA+V-a8tNnevox8OcXc_jxDzHdrxdF9Z-Nf2Rn0QaBsnM=n5CfA@mail.gmail.com> <20120901095707.GB6348@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 01 September 2012 12:57:07 Sakari Ailus wrote:
> On Wed, Aug 29, 2012 at 08:11:50PM +0530, Prabhakar Lad wrote:

[snip]

> > For test pattern you meant control to enable/disable it ?
> 
> There are two approaches I can think of.
> 
> One is a menu control which can be used to choose the test pattern (or
> disable it). The control could be standardised but the menu items would have
> to be hardware-specific since the test patterns themselves are not
> standardised.

Agreed. The test patterns themselves are highly hardware-specific.

>From personal experience with sensors, most devices implement a small, fixed 
set of test patterns that can be exposed through a menu control. However, some 
devices also implement more "configurable" test patterns. For instance the 
MT9V032 can generate horizontal, vertical or diagonal test patterns, or a 
uniform grey test pattern with a user-configurable value. This would then 
require two controls.

> The alternative is to have a boolean control to enable (and disable) the
> test pattern and then a menu control to choose which one to use. Using or
> implemeting the control to select the test pattern isn't even strictly
> necessary to get a test pattern out of the device: one can enable it without
> knowing which one it is.
> 
> So which one would be better? Similar cases include V4L2_CID_SCENE_MODE
> which is used to choose the scene mode from a list of alternatives. The main
> difference to this case is that the menu items of the scene mode control
> are standardised, too.
> 
> I'd be inclined to have a single menu control, even if the other menu items
> will be device-specific. The first value (0) still has to be documented to
> mean the test pattern is disabled.
> 
> Laurent, Hans: what do you think?

A menu control with value 0 meaning test pattern disabled has my preference as 
well.

-- 
Regards,

Laurent Pinchart

