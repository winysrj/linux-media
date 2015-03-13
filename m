Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49561 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113AbbCMLQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:16:31 -0400
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6A3BF2A002F
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2015 12:16:20 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/39] vivid: additional improvements
Date: Fri, 13 Mar 2015 12:16:07 +0100
Message-Id: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series follows the 29 part series posted earlier:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/88842

It adds additional format support, makes vivid a platform driver and
finally uses the v4l2_device release callback to clean up memory. This
works also when the driver is forcibly unbound.

I plan to post a pull request for all these vivid improvements on Monday
if there are no comments.

Regards,

	Hans

