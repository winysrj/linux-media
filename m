Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59027 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756775Ab2ECXCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 19:02:46 -0400
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com
Date: Thu, 03 May 2012 19:02:21 -0400
In-Reply-To: <4FA25C65.2020700@redhat.com>
References: <20120502191324.GE852@valkosipuli.localdomain>
	 <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi>
	 <201205022245.22585.hverkuil@xs4all.nl> <4FA1B27A.2030405@redhat.com>
	 <1336005780.24477.7.camel@palomino.walls.org> <4FA25C65.2020700@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1336086148.2496.4.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-05-03 at 07:22 -0300, Mauro Carvalho Chehab wrote:
> Em 02-05-2012 21:42, Andy Walls escreveu:
> > On Wed, 2012-05-02 at 19:17 -0300, Mauro Carvalho Chehab wrote:

> >> I suspect that sizeof() won't work inside a macro. 
> > 
> > sizeof() is evaluated at compile time, after preprocessing. 
> > It should work inside of a macro.
> 
> I tried to compile this small piece of code:
> 
> enum foo { BAR };
> #if sizeof(foo) != sizeof(int)
> void main(void) { printf("different sizes\n"); }
> #else
> void main(void) { printf("same size\n"); }
> #endif

Oh, I misunderstood what you intended when you said "work inside a
macro".

You are correct.  I would not expect sizeof() to work in a condition
evaluated by the preprocessor.  Only the compiler can properly compute
sizeof(), after the preprocessor has done it's work -- unless someone
builds a much smarter, multiple-pass preprocessor.



> > See the ARRAY_SIZE() macro in include/linux/kernel.h for a well tested
> > example.
> 
> ARRAY_SIZE() doesn't have an #if on it.

Correct.  My example is irrelevant, because I didn't understand what you
meant.

Sorry for the noise.

Regards,
Andy



