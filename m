Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:52475 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0C2Pyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 11:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <20100328112909.GP5069@bicker>
References: <20100328112909.GP5069@bicker>
Date: Mon, 29 Mar 2010 11:54:52 -0400
Message-ID: <30353c3d1003290854s7a1a119cm5fdf8cf0142762df@mail.gmail.com>
Subject: Re: [patch] video/s255drv: cleanup. remove uneeded NULL check
From: David Ellingsworth <david@identd.dyndns.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dean Anderson <dean@sensoray.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mike Isely <isely@pobox.com>,
	=?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't have any problems with this patch in particular but would like
to note that this driver could use a little refactoring.

One thing I noticed just while glancing at the code is that the return
value from s2255_probe_v4l is not checked in s2255_probe. As a result
the driver could fail to register some or all of it's video device
nodes and still continue to load.

Also the use of kref, while needed in this driver due to the number of
video nodes created, is probably a bit overused. In my opinion
video_unregister_device should be called in the usb disconnect
callback for each registered video device. This ensures that no future
calls to open will occur for that device. Subsequently, once all
applications have stopped using the previously registered
video_device, the release callback of the video_device struct will
fire. Therefore if the device kref is incremented for each registered
video device (during probe) and then properly decremented during the
video_device release callback for each device the device driver's
structure may then be freed. This approach should lead to a much
cleaner implementation of the open, release, and disconnect callbacks.

Regards,

David Ellingsworth
