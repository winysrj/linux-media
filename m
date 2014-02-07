Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:54529 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaBGRTz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 12:19:55 -0500
Message-Id: <cover.1391793068.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 7 Feb 2014 18:11:08 +0100
Subject: [PATCH RFC 0/2] drivers/base: simplify simple DT-based components
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	devel@driverdev.osuosl.org
Cc: alsa-devel@alsa-project.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org, Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series tries to simplify the code of simple devices in case
they are part of componentised subsystems, are declared in a DT, and
are not using the component bin/unbind functions.

Jean-Francois Moine (2):
  drivers/base: permit base components to omit the bind/unbind ops
  drivers/base: declare phandle DT nodes as components

 drivers/base/component.c | 21 +++++++++++++++++++--
 drivers/base/core.c      | 18 ++++++++++++++++++
 include/linux/of.h       |  2 ++
 3 files changed, 39 insertions(+), 2 deletions(-)

-- 
1.9.rc1

