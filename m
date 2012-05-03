Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58538 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab2ECAnT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 20:43:19 -0400
Subject: Re: [RFC v3 1/2] v4l: Do not use enums in IOCTL structs
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com
Date: Wed, 02 May 2012 20:42:59 -0400
In-Reply-To: <4FA1B27A.2030405@redhat.com>
References: <20120502191324.GE852@valkosipuli.localdomain>
	 <1335986028-23618-1-git-send-email-sakari.ailus@iki.fi>
	 <201205022245.22585.hverkuil@xs4all.nl> <4FA1B27A.2030405@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1336005780.24477.7.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-05-02 at 19:17 -0300, Mauro Carvalho Chehab wrote:

> We can speed-up the conversions, with something like:
> 
> enum foo {
> 	BAR
> };
> 
> if (sizeof(foo) != sizeof(u32))
> 	call_compat_logic().
> 
> I suspect that sizeof() won't work inside a macro. 

sizeof() is evaluated at compile time, after preprocessing. 
It should work inside of a macro.

See the ARRAY_SIZE() macro in include/linux/kernel.h for a well tested
example.

Regards,
Andy



