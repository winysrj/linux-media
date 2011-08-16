Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1HPAVZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 20:21:25 -0400
Message-ID: <4E49B7F5.4010609@redhat.com>
Date: Mon, 15 Aug 2011 17:21:09 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
References: <4E303E5B.9050701@samsung.com> <20110809231806.GA5926@valkosipuli.localdomain> <4E41CF28.9050406@redhat.com> <201108151445.38650.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108151445.38650.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-08-2011 05:45, Laurent Pinchart escreveu:
> Hi Mauro,

>> After having it there properly working and tested independently, we may
>> consider patches removing V4L2 interfaces that were obsoleted in favor of
>> using the libv4l implementation, of course using the Kernel way of
>> deprecating interfaces. But doing it before having it, doesn't make any
>> sense.
> 
> Once again we're not trying to remove controls, but expose them differently. 

See the comments at the patch series, starting from the patches that removes
support for S_INPUT. I'm aware that the controls will be exposed by both
MC and V4L2 API, althrough having ways to expose/hide controls via V4L2 API
makes patch review a way more complicated than it used to be before the MC
patches.

Regards,
Mauro
