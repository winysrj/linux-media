Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54252 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdG3WcV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 18:32:21 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/4] v4l: async: fixes for v4l2_async_notifier_unregister()
Date: Mon, 31 Jul 2017 00:31:54 +0200
Message-Id: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series is based on top of media-tree and some patches where
previously part of the series '[PATCH v5 0/4] v4l2-async: add
subnotifier registration for subdevices'. Hans suggested the cleanups
could be broken out to a separate series, so this is this series :-)

The aim of this series is to cleanup and document some of the odd things
that happens in v4l2_async_notifier_unregister(). The purpose for this
in the short term is to make it easier to implement subnotifiers which
both I and Sakari are trying to address, this feature is blocking other
drivers such as the Renesas R-Car CSI-2 receiver driver. And in the long
run (I hope) to make it easier to get rid of the need to do re-probing
at all in v4l2_async_notifier_unregister() :-)

Niklas Söderlund (4):
  v4l: async: fix unbind error in v4l2_async_notifier_unregister()
  v4l: async: abort if memory allocation fails when unregistering
    notifiers
  v4l: async: do not hold list_lock when re-probing devices
  v4l: async: add comment about re-probing to
    v4l2_async_notifier_unregister()

 drivers/media/v4l2-core/v4l2-async.c | 49 ++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 21 deletions(-)

-- 
2.13.3
