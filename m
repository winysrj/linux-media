Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47064 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1DCXvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 19:51:23 -0400
Received: by iyb14 with SMTP id 14so5394248iyb.19
        for <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:51:22 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	g.liakhovetski@gmx.de
Subject: vb2: stop_streaming() callback redesign
Date: Sun,  3 Apr 2011 16:51:05 -0700
Message-Id: <1301874670-14833-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This series implements a slight redesign of the stop_streaming() callback in vb2.
The callback has been made obligatory. The drivers are expected to finish all
hardware operations and cede ownership of all buffers before returning, but are
not required to call vb2_buffer_done() for any of them. The return value from
this callback has also been removed.

[PATCH 1/5] [media] vb2: redesign the stop_streaming() callback and make it obligatory
[PATCH 2/5] [media] vivi: adapt to the new stop_streaming() callback behavior
[PATCH 3/5] [media] s5p-fimc: remove stop_streaming() callback return
[PATCH 4/5] [media] sh_mobile_ceu_camera: remove stop_streaming() callback return
[PATCH 5/5] [media] mx3_camera: remove stop_streaming() callback return

-- 
Best regards,
Pawel Osciak
