Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:33104 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbdBEIpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Feb 2017 03:45:05 -0500
Received: from [IPv6:2001:a62:283:6a01:d73d:fa5b:a541:4b82] (unknown [IPv6:2001:a62:283:6a01:d73d:fa5b:a541:4b82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zzam)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 1F98934163C
        for <linux-media@vger.kernel.org>; Sun,  5 Feb 2017 08:45:02 +0000 (UTC)
To: linux-media@vger.kernel.org
From: Matthias Schwarzott <zzam@gentoo.org>
Subject: media_build handles FRAME_VECTOR incorrect
Message-ID: <37af2f33-916b-e990-30fa-670c61076575@gentoo.org>
Date: Sun, 5 Feb 2017 09:45:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Compiling the media drivers out of tree with media_build does not handle
FRAME_VECTOR correctly.

My kernel sources have FRAME_VECTOR but it is not enabled. So all
modules depending on it (e.g. VIDEOBUF2_MEMOPS) will fail to load
because the relevant functions cannot be found.

I see two options:
1. Modify the real kernel sources to allow FRAME_VECTOR be enabled via
config (either y or m).

I locally just modified my kernel's mm/KConfig like this:

 config FRAME_VECTOR
-        bool
+        tristate "enable frame_vector for external modules"

2. Change media_build to supply a replacement when it is not enabled in
the system kernel.

Regards
Matthias
