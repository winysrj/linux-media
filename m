Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2299 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaBQJrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:47:01 -0500
Message-ID: <5301DA57.1070905@xs4all.nl>
Date: Mon, 17 Feb 2014 10:45:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	ismael.luceno@corp.bluecherry.net, pete@sensoray.com
Subject: Re: [REVIEWv2 PATCH 00/34] Add support for complex controls, use
 in solo/go7007
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl> <20140216201414.GS15635@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140216201414.GS15635@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2014 09:14 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Feb 10, 2014 at 09:46:25AM +0100, Hans Verkuil wrote:
>> This patch series adds support for complex controls (aka 'Properties') to
> 
> While the patchset extends the concept of extended controls by adding more
> data types, they should not be called "properties" since they are not. The
> defining aspect of "properties" is to be able to specify to which entity,
> sub-device, pad, video buffer queue, flash led etc. object the said property
> is related to. This is mostly orthogonal to what kind of data types the
> property could have.

For all practical purposes controls are properties. They are properties of
v4l2_subdev, v4l2_device, video_device or v4l2_fh. While we cannot at the moment
assign controls to other v4l2 objects, there is nothing that prevents us from
doing so.

> 
> There's just a single 32-bit reserved field in struct v4l2_ext_control so
> extending the current extended controls (S/G/TRY) interface is not an option
> to support properties. A new ABI (but not necessarily even if probably an
> API as well) would be needed in any case.

Why? I would use that remaining field: the top X bits define the object type
(e.g. PAD) and the lower bits are the object ID (pad number).

> 
> So for the time being I'd wish we continue to use the name "controls" even
> if the control type is not one of the traditional ones.

The cover letter is the only place where the term 'property' is used, mostly
to link into the 'property' discussion we had in the past. But it is a bad idea
to use the that term because they are traditionally called control in V4L2 land.

Mixing those names is just very confusing.

Regards,

	Hans
