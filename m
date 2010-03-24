Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1037 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab0CXH61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 03:58:27 -0400
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id o2O7wM8A004081
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 08:58:26 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: New wiki page: V4L framework progress
Date: Wed, 24 Mar 2010 08:58:55 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003240858.55236.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

I started a new page on the wiki:

http://www.linuxtv.org/wiki/index.php/V4L_framework_progress

I want to be able to use this to keep track of the status of bridge and
sub-device drivers. The bridge driver table is mostly finished, but I would
appreciate it if maintainers of particular drivers can double check the table
entry and add their initials to the 'have hardware' column.

Don't bother with the i2c table yet, I still need to fill that in.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
