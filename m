Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3285 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaDQJWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:22:00 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s3H9LvcB028784
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 11:21:59 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C5A282A0410
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 11:21:51 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv4 0/3] vb2: stop_streaming should return void
Date: Thu, 17 Apr 2014 11:21:47 +0200
Message-Id: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split off the removal of the vb2_is_streaming check as requested.
Note that the davinci drivers still have this unnecessary check, but
Prabhakar will remove that himself.

Also fix a compiler warning that I got during the daily build.

Regards,

	Hans

