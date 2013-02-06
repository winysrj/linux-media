Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3634 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3BFMO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 07:14:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: fschaefer.oss@googlemail.com, dheitmueller@kernellabs.com
Subject: em28xx: fix bytesperline calculation in TRY_FMT
Date: Wed,  6 Feb 2013 13:14:46 +0100
Message-Id: <1360152887-4503-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compared to the previous patch I've removed the calculation change (I still
think it is wrong, but this needs to be considered in a wider perspective).

But the more obvious problem where the current width instead of the one
provided by the application is used still needed to be fixed, which is
done by this patch.

Regards,

	Hans

