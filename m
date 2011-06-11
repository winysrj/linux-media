Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3835 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1FKRsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:48:39 -0400
Received: from tschai.lan (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id p5BHmbw7092582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 19:48:37 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 0/6] tuner-core: fix g_freq/s_std and g/s_tuner
Date: Sat, 11 Jun 2011 19:48:29 +0200
Message-Id: <1307814515-17351-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Third version of this patch series.

Pretty much the same as RFCv2 (except for a small fix in the fourth patch)
except for patch 6. This it my attempt to fix tuner-core without having
to change any drivers.

It just keeps track of whether the current application mode is valid for
this tuner. If not, then g_freq and g/s_tuner do nothing.

