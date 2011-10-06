Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:39156 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab1JFMX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 08:23:28 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-77-72.cisco.com [10.54.77.72])
	by ams-core-1.cisco.com (8.14.3/8.14.3) with ESMTP id p96CNR3T007678
	for <linux-media@vger.kernel.org>; Thu, 6 Oct 2011 12:23:27 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
Date: Thu, 6 Oct 2011 14:23:22 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110061423.22064.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently we have three repositories containing libraries and utilities that 
are relevant to the media drivers:

dvb-apps (http://linuxtv.org/hg/dvb-apps/)
v4l-utils (http://git.linuxtv.org/v4l-utils.git)
media-ctl (git://git.ideasonboard.org/media-ctl.git)

It makes no sense to me to have three separate repositories, one still using 
mercurial and one that isn't even on linuxtv.org.

I propose to combine them all to one media-utils.git repository. I think it 
makes a lot of sense to do this.

After the switch the other repositories are frozen (with perhaps a README 
pointing to the new media-utils.git).

I'm not sure if there are plans to make new stable releases of either of these 
repositories any time soon. If there are, then it might make sense to wait 
until that new stable release before merging.

Comments?

Regards,

	Hans
