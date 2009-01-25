Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:39044 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZAYVNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 16:13:00 -0500
Date: Sun, 25 Jan 2009 13:12:58 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "Shah, Hardik" <hardik.shah@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] New V4L2 ioctls for OMAP class of Devices
In-Reply-To: <200901251050.35417.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0901251302380.17971@shell2.speakeasy.net>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EB83@dbde02.ent.ti.com>
 <200901251035.49963.hverkuil@xs4all.nl> <200901251050.35417.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 25 Jan 2009, Hans Verkuil wrote:
> I also would like to see the documentation for these ioctls and controls. I
> hope my www.linuxtv.org/hg/~hverkuil/v4l-dvb-spec tree will be merged soon
> with the master, but in the meantime you can mail a diff against the
> documentation in my tree. I will ensure that the documentation patches will
> be applied correctly once the spec is merged in the main v4l-dvb
> repository.

Yes, I would like to see the color conversion documentation.  V4L2 has a
color space field as part of the pixel format (e.g., V4L2_COLORSPACE_REC709
or V4L2_COLORSPACE_SMPTE170M), how does this new ioctl interact with that?

What is the format of the parameters?  These are natively real numbers not
integers, so to store them in an s32 there must some conversion, i.e.
scale and offset.  What is the actual equation used for the colorspace
conversion?

