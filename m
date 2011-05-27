Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:62172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1E0H1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 03:27:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Fri, 27 May 2011 09:26:53 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	David Rusling <david.rusling@linaro.org>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105261120.41282.arnd@arndb.de> <20110526144512.GB3547@valkosipuli.localdomain>
In-Reply-To: <20110526144512.GB3547@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105270926.53830.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 26 May 2011, Sakari Ailus wrote:
> I strongly favour GStreamer below OpenMAX rather than V4L2. Naturally the
> GStreamer source plugins do use V4L2 where applicable.

Interesting point, yes. Note that this is probably the opposite of
what David had in mind when talking about GStreamer and OpenMAX,
as I believe we have people working on the gstreamer-on-openmax
plugin, but not on openmax-on-gstreamer.

> Much of the high level functionality in cameras that applications are
> interested in (for example) is best implemented in GStreamer rather than
> V4L2 which is quite low level interface in some cases. While some closed
> source components will likely remain, the software stack is still primarily
> Open Source software. The closed components are well isolated and
> replaceable where they exist; essentially this means individual GStreamer
> plugins.

Right. Also since Linaro is not interested in closed-source components
(the individual members might be, but not Linaro as a group), it's
also good to isolate any closed source code as much as possible and
to make sure everthing else works without it.

> I think the goal should be that OpenMAX provides no useful functionality at
> all. It should be just a legacy interface layer for applications dependent
> on it.

Absolutely.

> All the functionality should be implemented in V4L2 drivers and
> GStreamer below OpenMAX.

Maybe. I'm not sure what the Linaro MM working group plans for this are,
but please bring up your arguments for that with them.

	Arnd
