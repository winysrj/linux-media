Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3157 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1ACSb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 13:31:29 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03IVMuR006180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 19:31:27 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 00/10] Move priority handling into the core
Date: Mon,  3 Jan 2011 19:31:05 +0100
Message-Id: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is the second attempt at moving priority handling into the core.

I have added two helper functions that allocate and free just a single
v4l2_fh struct. This can be used by drivers that do not need to embed the
struct v4l2_fh into a larger struct.

It is also called by the core for any driver that does not supply open()
or release() callbacks in struct v4l2_file_operations. This replaces the
awkward 'store priority in private_data' hack from the previous patch
series.

This means that almost all radio devices automatically support priority
handling (since most do not supply open/release).

This patch series also converts radio-mr800 (removing the bogus autopm
support allows us to remove the open/release support) and radio-cadet
(typical first-time open and close code, shows how easy it is to use
the helper functions).

ivtv is also converted as it is currently the only driver that embeds
struct v4l2_fh.

Core support for priority handling is necessary in order to have consistent
handling of priorities and to handle priorities and the control framework.

A lot of video drivers do something in open and/or release, so it is quite
a bit of work to implement this. However, the changes needed to convert a
driver are trivial and are easy to review.

Comments are welcome!

Regards,

	Hans

