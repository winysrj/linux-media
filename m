Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bcode.com ([150.101.204.108]:18324 "EHLO mail.bcode.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbZFDBwQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 21:52:16 -0400
Date: Thu, 4 Jun 2009 11:52:16 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: linux-media@vger.kernel.org
Cc: Erik =?UTF-8?B?QW5kcsOpbg==?= <erik.andren@gmail.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: Creating a V4L driver for a USB camera
Message-Id: <20090604115216.513cc41c.erik@bcode.com>
In-Reply-To: <alpine.LNX.2.00.0906032014530.17538@banach.math.auburn.edu>
References: <20090603141350.04cde59b.erik@bcode.com>
	<62e5edd40906022318l230992b7n34e5178b7e1a7d46@mail.gmail.com>
	<20090604100110.c837c3df.erik@bcode.com>
	<alpine.LNX.2.00.0906032014530.17538@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 4 Jun 2009 11:28:38 +1000
Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:

> If this is the case, then it ought not to be terribly difficult to write a 
> basic driver. If you wanted still camera support, with which I have a bit 
> more experience than with streaming support,

Yep, only interested in still images ATM.

> Of course, I said above "basic" driver. That does not include things like 
> color balance, contrast, or brightness controls. Such would probably take 
> a little bit longer.

Als need contol over things like this. We have pretty good control
over the lighting the camera works under so we tweak contrast/brightness/
whatever in the camera to provide the bext possible image to the image
processing.

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
