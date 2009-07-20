Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40121 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZGTLU6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 07:20:58 -0400
Subject: Re: Regression 2.6.31:  ioctl(EVIOCGNAME) no longer returns device
 name
From: Andy Walls <awalls@radix.net>
To: Mark Lord <lkml@rtr.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org
In-Reply-To: <4A637EB9.5040004@rtr.ca>
References: <1247862937.10066.21.camel@palomino.walls.org>
	 <20090719144749.689c2b3a@hyperion.delvare> <4A6316F9.4070109@rtr.ca>
	 <20090719145513.0502e0c9@hyperion.delvare> <4A631B41.5090301@rtr.ca>
	 <4A631CEA.4090802@rtr.ca> <4A632FED.1000809@rtr.ca>
	 <20090719190833.29451277@hyperion.delvare> <4A63656D.4070901@rtr.ca>
	 <4A637212.2000002@rtr.ca> <20090719193952.GC17495@dtor-d630.eng.vmware.com>
	 <4A637EB9.5040004@rtr.ca>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 07:21:16 -0400
Message-Id: <1248088876.3143.2.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-07-19 at 16:14 -0400, Mark Lord wrote:
> Dmitry Torokhov wrote:
> > On Sun, Jul 19, 2009 at 03:20:50PM -0400, Mark Lord wrote:

> > Should be fixed by f936601471d1454dacbd3b2a961fd4d883090aeb in the
> > for-linus branch of my tree.
> ..
> 
> Peachy.  Push it, or post it here and I can re-test with it.
> 
> (does anyone else find it spooky that a google search for the
>  above commit id actually finds Dmitry's email quoted above ?
>  Mere seconds after he posted it for the very first time ??)

Not since he's using a Gmail account, no.  Google probably indexes it on
the way in.  Very effcient.

The google is reading ur e-mail...


-Andy



