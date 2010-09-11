Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4393 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0IKNuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 09:50:00 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8BDnwIk052668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 11 Sep 2010 15:49:59 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: Replacing the 'Device Naming' section in the V4L spec
Date: Sat, 11 Sep 2010 15:49:53 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009111549.53435.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

I'm working on the V4L2 DocBook spec and when reading through the "Device Naming"
subsection of the "Opening and Closing Devices" section in the first chapter I
realized that it is really out of date. The text is in this file:

Documentation/DocBook/v4l/common.xml

With udev pretty much everything in that section is useless (and probably confusing
for first-time readers).

I propose that we replace it with something short like this:

-----------------------------------------------------
Device Naming

V4L2 drivers create one or more device nodes with major number 81 and a minor number
between 0 and 255. Three types of devices can be created:

/dev/videoX	Used for video capture/output/overlay.
/dev/radioX	Used for radio and RDS tuning/modulating.
/dev/vbiX	Used for VBI capture and output.
-----------------------------------------------------

Is there anything else that should be in here?

BTW, I'm working on editing the 'Related Devices', 'Multiple Opens' and 
'Shared Data Streams' as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco	
