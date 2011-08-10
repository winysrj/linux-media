Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:14654 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab1HJJgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 05:36:36 -0400
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: nitesh moundekar <niteshmoundekar@gmail.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Date: Wed, 10 Aug 2011 12:36:29 +0300
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <4E410342.3010502@gmail.com> <CAF5T7d=h=BBhmFNs3EBPMGzKAJg_fciq=iB_GKQGDB+oiL+XAg@mail.gmail.com>
In-Reply-To: <CAF5T7d=h=BBhmFNs3EBPMGzKAJg_fciq=iB_GKQGDB+oiL+XAg@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201108101236.29745.tuukka.toivonen@intel.com>
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, August 09, 2011 06:36:19 pm nitesh moundekar wrote:
> I am worried about direction v4l2 is taking. It looks against the basic
> principle of driver i.e. hardware abstraction. 

There definitely should be an API which is hardware independent.
However, the problem is that the hardware is so flexible that an
hardware independent API needs to be necessarily enforce policies
and possibly do complex image processing which is against the kernel
philosophy and belongs to userspace.

As I see it, it is necessary to provide more or less HW-dependent
API to kernel V4L2. What we need is an userspace library abstracting
that to simple HW-independent API. I think that libv4l is a very
good way to do that, since it still provides the V4L2 interface
but can do things in userspace.

- Tuukka
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

