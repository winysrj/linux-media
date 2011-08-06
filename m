Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49600 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1HFXi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 19:38:26 -0400
Date: Sun, 7 Aug 2011 02:38:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: ISP CCDC freeze-up on STREAMON
Message-ID: <20110806233821.GW32629@valkosipuli.localdomain>
References: <1309422713-18675-1-git-send-email-michael.jones@matrix-vision.de>
 <201107201047.11972.laurent.pinchart@ideasonboard.com>
 <4E3BB8E0.3000406@matrix-vision.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3BB8E0.3000406@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Fri, Aug 05, 2011 at 11:33:20AM +0200, Michael Jones wrote:
> Hi Laurent,
> 
> On 07/20/2011 10:47 AM, Laurent Pinchart wrote:
...
> > I've tested this with a serial CSI-2 sensor and a parallel sensor (MT9V032, in 
> > both 8-bit and 10-bit modes, albeit with SGRBG8 instead of GREY for the 8-bit 
> > mode), and I can't reproduce the issue.
> > 
> > I thought I've asked you already but can't find this in my mailbox, so I 
> > apologize if I have, but could you try increasing vertical blanking and see if 
> > it helps ?
> > 
> 
> I think that was the first time you suggested that. Indeed, if I stretch
> out the time between frames, the problem goes away. I haven't tested it
> precisely to see how long it needs to be to work correctly. But what
> does this tell me? This isn't a very appealing fix as 1) I would have to

What works and what does not (in ISO units preferrably)?

Sometimes (at least) sensor minimum vertival blanking is enough.

-- 
Sakari Ailus
sakari.ailus@iki.fi
