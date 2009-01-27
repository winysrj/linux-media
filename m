Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:42702 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbZA0Qoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 11:44:30 -0500
Date: Tue, 27 Jan 2009 08:44:26 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Shah, Hardik" <hardik.shah@ti.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] New V4L2 ioctls for OMAP class of Devices
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02F535ECD5@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.58.0901270834540.17971@shell2.speakeasy.net>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535ECD5@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Shah, Hardik wrote:
> The rotation values are 0, 90, 180 and 270 degree but to disable rotation
> the value passed should be -1 and this is one more value.  I know 0
> degree rotation corresponds to rotation disabled but DSS hardware
> requires 0 degree rotation to be enabled for mirroring.  The difference
> between the 0 degree rotation and no rotation(-1) is that 0 degree
> rotation will use the rotation engine in OMAP and then do the mirroring
> while -1 degree rotation will not use rotation engine.  There is more
> bandwidth utilization while using the rotation engine.  So people may
> want to completely disable rotation and people may want 0 degree rotation
> for mirroring support.  That's why I prefer not to use enum.  Is that ok
> for

That sounds like a hardware quirk that the driver should take care of.
Just have the driver turn on the rotation engine if mirroring is used.

It seems very hard for an application to make decent use of rotation
support if only certain values are supported by the hardware yet anything
in degrees can be specified?  How is the application supposed to know what
values will be acceptable?
