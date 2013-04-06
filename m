Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1840 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3DFIn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 04:43:26 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr19.xs4all.nl (8.13.8/8.13.8) with ESMTP id r368hM9k007160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 6 Apr 2013 10:43:24 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id BBDBC11E01D6
	for <linux-media@vger.kernel.org>; Sat,  6 Apr 2013 10:43:16 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 0/2] Two tuner-core patches fixing afc/signal bugs
Date: Sat,  6 Apr 2013 10:43:12 +0200
Message-Id: <1365237794-32380-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I noticed that the afc and signal values returned by VIDIOC_G_TUNER were
completely wrong in ivtv. I tracked this down to bugs in tda9887 and tuner-simple
(the afc and rf_strength ops are only valid when in radio mode, not when in TV
mode) and limitations in the get_afc/signal analog_demod_ops prototypes that
made it impossible to update these values for specific tuner modes only.

Both are fixed and ivtv is now working again, at least for TV. The radio
signal strength detection is still broken, at least for the FM1216ME_MK3 tuner.

