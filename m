Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58671 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642AbbIUJgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 05:36:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ricardo.ribalda@gmail.com
Subject: [PATCH 0/2] v4l2-ctrls: fix NEXT_COMPOUND support
Date: Mon, 21 Sep 2015 11:36:40 +0200
Message-Id: <1442828202-25578-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is identical to the original RFC patch (see here:
https://patchwork.linuxtv.org/patch/31423/), but it is now split up in
two patches and the actual code fix now has a CC to stable to patch up
kernels 3.17 and up.

Regards,

	Hans

