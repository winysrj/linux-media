Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3988 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3A3R4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:56:50 -0500
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id r0UHulau094563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 18:56:49 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 1F71511E00CB
	for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 18:56:47 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/3] bw-qcam: fixes and vb2 conversion
Date: Wed, 30 Jan 2013 18:56:41 +0100
Message-Id: <1359568604-27876-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I worked on this some months ago, but didn't have the time to post it until
now.

These patches fix a few v4l2-compliance failures and convert this driver
to vb2. I mainly did that conversion to understand vb2 a bit better, because
it isn't really useful for such an old driver :-)

Regards,

	Hans

