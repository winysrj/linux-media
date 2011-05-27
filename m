Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3986 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1E0O6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 10:58:04 -0400
Received: from tschai.lan (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p4REw19M055063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 16:58:02 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/5] Add autofoo/foo support to the control framework
Date: Fri, 27 May 2011 16:57:50 +0200
Message-Id: <1306508275-9228-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series sits on top of the Control Event patch series I posted on
Wednesday.

It adds core support for the common autofoo/foo controls (e.g. autogain/gain,
autoexposure/exposure, etc.).

See the commit comments of patches 1 and 3 and the documentation changes
in patch 4 for detailed information on the behavior.

The vivi driver has been adapted to test this new feature.

The full code is available here:

http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/core5

Comments are welcome!

Regards,

	Hans

