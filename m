Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4659 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1KNSVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 13:21:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com
Subject: board-dm646x-evm.c: clock setup fix
Date: Mon, 14 Nov 2011 19:20:48 +0100
Message-Id: <1321294849-2738-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The setup_vpif_input_channel_mode function uses the wrong register.

Manju, can you review?

I'm not sure whether this should be merged for v3.3 through the linux-media
tree or the davinci tree. Opinions welcome.

Actually, this fix should probably go in for v3.2 since it is a clear bug fix.

Regards,

	Hans
