Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2323 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab1FKNex (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:34:53 -0400
Received: from tschai.lan (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p5BDYoGd064805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 15:34:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 0/7] tuner-core: fix g_freq/s_std and g/s_tuner
Date: Sat, 11 Jun 2011 15:34:36 +0200
Message-Id: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

While testing the new multi-standard tuner of the HVR-1600 (the cx18 driver)
I came across a number of bugs in tuner-core that were recently introduced.

This patch series fixes those bugs and cleans up some code that confused
me.

The bugs fixed in this series are:

1) 'type' is set by the driver, not the application for g_tuner and g_frequency,
   so don't check that field.
2) s_std and s_tuner both setup the tuner first, and then apply the new std
   or audmode. This should be the other way around.
3) s_tuner should not check the tuner 'type' field since applications don't
   need to set this. 'audmode' should just be applied to the current tuner
   mode.

All these bugs were introduced in 2.6.39. So if acked, then this patch
series should at least to into v3.0 and possibly into 2.6.39-stable.

Regards,

	Hans

