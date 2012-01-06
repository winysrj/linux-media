Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10537 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2AFCbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 21:31:37 -0500
Message-ID: <4e9191cad2837e2710d3ccb8be4aa735.squirrel@www.codeaurora.org>
Date: Thu, 5 Jan 2012 18:31:37 -0800 (PST)
Subject: Pause/Resume and flush for V4L2 codec drivers.
From: vkalia@codeaurora.org
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I am trying to implement v4l2 driver for video decoders. The problem I am
facing is how to send pause/resume and flush commands from user-space to
v4l2 driver. I am thinking of using controls for this. Has anyone done
this before or if anyone has any ideas please let me know. Appreciate your
help.

Thanks
Vinay

