Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47584 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab1AJWSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 17:18:42 -0500
Received: by ywl5 with SMTP id 5so7694466ywl.19
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 14:18:41 -0800 (PST)
From: Roberto Rodriguez Alcala <rralcala@gmail.com>
To: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: [PATCH 0/2] Add Camera Control Class to Support Night Mode Feature
Date: Mon, 10 Jan 2011 19:18:25 -0300
Message-Id: <1294697907-1714-1-git-send-email-rralcala@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, I'm sending this patch proposing to add a Camera Control Class to support Night Mode because there are a lot of cameras with that feature, and the implemented ones currently non stantard work arounds, like enabling it in certain resolutions or using another control class like WHITE_BALANCE.

Also, I couldn't find a Control class suitable for that, because the efects of this feature varies from camera to camera like reduce frame rate by 1/4, enabling IR LEDs, etc.

This Patch includes the implementation for ov7670 and if you agree I can send the patched for other cameras also.

Thank You,

Roberto
