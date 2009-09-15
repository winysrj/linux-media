Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4557 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZIOPHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 11:07:37 -0400
Message-ID: <a440d95d0a59b074712fea82f5b772d0.squirrel@webmail.xs4all.nl>
In-Reply-To: <200909151610.38397.laurent.pinchart@ideasonboard.com>
References: <200909120021.48353.hverkuil@xs4all.nl>
    <200909151610.38397.laurent.pinchart@ideasonboard.com>
Date: Tue, 15 Sep 2009 17:07:39 +0200
Subject: Re: Media controller: sysfs vs ioctl
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> From the kernel point of view, (most of) the various sub-devices in a
> media
> device are arranged in a tree of kernel objects. Most of the time we have
> an
> I2C controller and various devices sitting on the I2C bus, one or several
> video devices that sit on some internal bus (usually a SoC internal bus
> for
> the most complex and recent platforms), and possibly SPI and other devices
> as
> well.
>
> Realizing that, as all those sub-devices are already exposed in sysfs in
> one
> way or the other, it was tempting to add a few attributes and soft links
> to
> solve the media controller problem.

I just wanted to make one clarification: sub-devices are usually, but not
always mapped 1-to-1 to a true kernel device. But sub-devices are an
abstract concept and it is possible to have multiple sub-devices exposed
by a single kernel device. Or even to have one sub-device covering two or
more kernel devices (no such beast exists, but nothing prevents this
technically).

I know of two instances where the sub-device has no sysfs counterpart. And
I expect more will follow.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

