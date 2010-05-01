Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1168 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab0EAVLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 May 2010 17:11:10 -0400
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id o41LB83I078925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 1 May 2010 23:11:09 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: em28xx & sliced VBI
Date: Sat, 1 May 2010 23:12:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005012312.14082.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I played a bit with my HVR900 and tried the sliced VBI API. Unfortunately I
discovered that it is completely broken. Part of it is obvious: lots of bugs
and code that does not follow the spec, but I also wonder whether it ever
actually worked.

Can anyone shed some light on this? And is anyone interested in fixing this
driver?

I can give pointers and help with background info, but I do not have the time
to work on this myself.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
