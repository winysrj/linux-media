Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57161 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab3FDFoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 01:44:14 -0400
Message-ID: <1370324144.26072.17.camel@younglee-desktop>
Subject: [PATCH 0/7] marvell-ccic: update ccic driver to support some
 features
From: lbyang <lbyang@marvell.com>
Reply-To: <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>, <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <lbyang@marvell.com>,
	<albert.v.wang@gmail.com>
Date: Tue, 4 Jun 2013 13:35:44 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch set adds some feature into the marvell ccic driver

Patch 1: Support MIPI sensor
Patch 2: Support clock tree
Patch 3: reset ccic when stop streaming, which makes CCIC more stable
Patch 4: refine the mcam_set_contig_buffer function
Patch 5: add some new fmts to support
Patch 6: add SOF-EOF pair check to make the CCIC more stable
Patch 7: use resource managed allocation

