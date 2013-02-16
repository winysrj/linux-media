Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4439 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3BPKSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 05:18:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>
Subject: [RFC PATCH 0/5] fsl-viu: v4l2 compliance fixes
Date: Sat, 16 Feb 2013 11:18:22 +0100
Message-Id: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts fsl-viu to the control framework and provides
some additional v4l2 compliance fixes.

Anatolij, are you able to test this?

Ideally I'd like to see the output of the v4l2-compliance tool (found in
the http://git.linuxtv.org/v4l-utils.git repository). I know that there are
remaining issues, especially with the fact that there can be one user at a
time only (very bad!) and some overlay issues. I can try to fix those, but
I need someone to test otherwise I won't bother.

Regards,

	Hans

