Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:26123 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab1HEFnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 01:43:37 -0400
Received: from [64.103.135.210] ([64.103.135.210])
	by bgl-core-3.cisco.com (8.14.3/8.14.3) with ESMTP id p755hZjD025383
	for <linux-media@vger.kernel.org>; Fri, 5 Aug 2011 05:43:35 GMT
Subject: v4l-utils : qv4l2: symbol lookup error: qv4l2: undefined symbol:
 libv4l2_default_dev_ops
From: Lalitanand Dandge <ldandge@cisco.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Aug 2011 11:13:32 +0530
Message-ID: <1312523012.23037.8.camel@ldandge-ThinkPad-T410>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I compiled and installed v4l-utils on Ubuntu 11.04 machine.
After this installation while running qv4l2 I am getting following
error.

qv4l2: symbol lookup error: qv4l2: undefined symbol:
libv4l2_default_dev_ops 

Kindly help getting to the roots of this problem,

Note:
I am using following repository to get the source
git clone git://git.linuxtv.org/v4l-utils.git
and following is the snippet of the uname -a command
2.6.38-10-generic-pae #46-Ubuntu SMP Tue Jun 28 16:54:49 UTC 2011 i686
i686 i386 GNU/Linux

Thanks and regards,

Lalitanand

