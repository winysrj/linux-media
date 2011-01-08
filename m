Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1556 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1AHNhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:01 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Daljv015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:00 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 0/16] Move priority handling into the core
Date: Sat,  8 Jan 2011 14:36:25 +0100
Message-Id: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the third attempt at moving priority handling into the core.

I have added two helper functions that allocate and free just a single
v4l2_fh struct. This can be used by drivers that do not need to embed the
struct v4l2_fh into a larger struct.

This is not longer called implicitly by the core. Drivers much explicitly
use struct v4l2_fh in order to support priority handling.

Also added a new helper function to detect whether a file handle is the
only open file handle for the associated device node. Many drivers need
to do something on the first open or last close and they all do some use
counting to keep track of that. With v4l2_fh we already have that information,
so a simple function will make that available to the driver.

Finally some documentation was also added.

This patch series converts radio-mr800 (removing the bogus autopm
support allows us to remove the open/release support), radio-cadet
(typical first-time open and close code, shows how easy it is to use
the helper functions) and radio-maxiradio.

ivtv is also converted as it is currently the only driver that embeds
struct v4l2_fh.

Tested for all converted drivers except for radio-cadet due to lack of
hardware.

Core support for priority handling is necessary in order to have consistent
handling of priorities and to handle priorities and the control framework.

Comments are welcome!

Regards,

        Hans

