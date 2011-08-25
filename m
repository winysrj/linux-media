Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4467 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1HYOIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 10:08:45 -0400
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id p7PE8h3w075900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 25 Aug 2011 16:08:44 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from localhost.localdomain (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id D1EB0168C00B5
	for <linux-media@vger.kernel.org>; Thu, 25 Aug 2011 16:08:36 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 00/12] First round of compiler warning fixes
Date: Thu, 25 Aug 2011 16:08:23 +0200
Message-Id: <1314281315-32366-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The daily build is now compiled with gcc 4.6.1 which produces lots of
'variable set but not used' warnings. This is the first round of fixes.

If there are no objections, then I'll make a pull request this weekend.

Regards,

        Hans

