Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:36657 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbbBMLaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 06:30:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: v4l2-subdev: removal of duplicate video enum ops
Date: Fri, 13 Feb 2015 12:29:59 +0100
Message-Id: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is based on this earlier RFC series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg83415.html

This patch series starts the work of removing several video ops that
are duplicated in as pad ops in the subdev kernel API. This kills the
whole point of the subdev API which is to enable reuse of subdevices by 
different bridge drivers. With duplicate ops bridge drivers now either
have to check which one to use, or (and that's what happens today) they
make an assumption and just use one of the two.

Duplicate ops should never have been allowed. A lesson for the future.

This patch series gets rid of two duplicate ops (the enum_framesizes
and enum_frameintervals video ops) and prepares the way to remove the
remaining crop video ops. The patch that does that isn't part of this
patch series as it needs more work (testing primarily).

The first patch of this series lays the foundation: the pad ops
use the v4l2_subdev_fh for the try formats. However, bridge drivers that
want to call the pad ops do not have a v4l2_subdev_fh struct available.
It's only used when accessing the 'try' formats that are part of struct
v4l2_subdev_fh. This patch splits off those fields into a separate struct
and uses that instead of v4l2_subdev_fh. This breaks the link between a
file handle and the try formats. If a bridge driver needs to deal with
try formats, then it is the responsibility of the bridge driver to create
a v4l2_subdev_pad_config array.

In practice, bridge drivers for simple, non-MC devices only need to use
the active format, and that doesn't need a v4l2_subdev_pad_config array,
so NULL can be used there instead. However, this might change in the
future.

The second and third patch add a 'which' field to the enum struct used
in the pad ops. Currently all enum pad ops assume that it is against the
'try' formats, but simple bridge drivers will want to enum against the
active formats. So add support to select what you want. And frankly, I
think it is more consistent and actually useful for application to see
what the enumeration is against the active format.

The next two patches add support for the new 'which' field where appropriate,
the sixth patch removes the uses of the video enum ops and the final patch
documents the new 'which' field.

Regards,

	Hans

