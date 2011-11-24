Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3349 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab1KXNjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:39:19 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id pAODdGYT046606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 14:39:18 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id BDF7611800C1
	for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 14:39:11 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Remove audio and video DVBv5 API
Date: Thu, 24 Nov 2011 14:38:57 +0100
Message-Id: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the 2011 workshop we discussed replacing the decoder commands in
include/linux/dvb/video.h and audio.h by a proper V4L2 API.

This patch series does that. It adds new VIDIOC_(TRY_)DECODER_CMD
ioctls to the V4L2 API. These are identical to the VIDEO_(TRY_)COMMAND from
dvb/video.h, but the names of the fields and defines now conform to the V4L2
API conventions.

Also new controls are added to replace the remaining functionality needed
by ivtv.

The new API has been documented. The ivtv.h header has been extended with
the 'old' DVB API, making ivtv independent from the old headers.

A new av7110.h header has been created that does the same for the av7110.h
driver. All the existing relevant DocBook documentation regarding those
DVB audio and video APIs has been copied as comments to the av7110.h header.

As a final step the old headers and documentation have been removed.

Feedback is welcome.

Regards,

	Hans

