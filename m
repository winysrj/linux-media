Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62021 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3AOMeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 07:34:19 -0500
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 0/7] cross-device reservation for dma-buf support
Date: Tue, 15 Jan 2013 13:33:57 +0100
Message-Id: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So I'm resending the patch series for reservations. This is identical to my git
tree at

http://cgit.freedesktop.org/~mlankhorst/linux/

Some changes have been made since my last version. Most notably is the use of
mutexes now instead of creating my own lock primitive, that would end up being
duplicate anyway.

The git tree also has a version of i915 and radeon working together like that.
It's probably a bit hacky, but it works on my macbook pro 8.2. :)

I haven't had any reply on the mutex extensions when I sent them out separately,
so I'm including it in the series.

The idea is that for lockdep purposes, the seqno is tied to a locking a class.
This locking class it not exclusive, but as can be seen from the last patch in
the series, it catches all violations we care about.

