Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4789 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0CSJPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 05:15:43 -0400
Message-ID: <6201a49a70a365c494ed2c7a523893a7.squirrel@webmail.xs4all.nl>
Date: Fri, 19 Mar 2010 10:15:40 +0100
Subject: RFC: Removal of videotext.h and /dev/vtx support
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "v4l-dvb" <linux-media@vger.kernel.org>
Cc: michael@mihu.de
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a proposal to remove the videotext API and drivers for kernel
2.6.35. This API is found in include/linux/videotext.h and is supported by
the saa5246a and saa5249 i2c drivers.

To the best of my knowledge there are no applications that use this. I
have not been able to find any hardware that uses the saa5249 driver and
in fact since we removed the i2c autoprobe it does not work anymore since
that are no bridge drivers that load it.

The saa5246a driver is loaded by the mxb driver, but Michael told me
recently that it actually doesn't work at all, and that it hadn't worked
for years.

Should we ever need a similar API in the future, then that should be build
around the sliced VBI API.

If there are no objections, then I'll prepare a patch series in a week or
two.

Regards,

         Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

