Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1994 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0CSH7J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 03:59:09 -0400
Received: from webmail.xs4all.nl (dovemail5.xs4all.nl [194.109.26.7])
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id o2J7x89X039541
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 08:59:08 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Message-ID: <83e56201383c6a99ea51dafcd2794dfe.squirrel@webmail.xs4all.nl>
Date: Fri, 19 Mar 2010 08:59:08 +0100
Subject: RFC: Drop V4L1 support in V4L2 drivers
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "v4l-dvb" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

V4L1 support has been marked as scheduled for removal for a long time. The
deadline for that in the feature-removal-schedule.txt file was July 2009.

I think it is time that we remove the V4L1 compatibility support from V4L2
drivers for 2.6.35.

It would help with the videobuf cleanup as well, but that's just a bonus.

If no one objects, then I can prepare a patch series for this.

Regards,

        Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

