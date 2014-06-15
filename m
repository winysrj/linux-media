Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38686 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaFOT4v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 15:56:51 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	magnus.damm@opensource.se, horms@verge.net.au,
	ian.molton@codethink.co.uk, william.towle@codethink.co.uk
Subject: RFC: new soc_camera/rcar_vin patch series
Date: Sun, 15 Jun 2014 20:56:25 +0100
Message-Id: <1402862194-17743-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a new series for the rcar_vin and soc_camera layer
to support using OF.

It should incorporate most of the feedback from the previous
series, but please let me know if there's anything missed. As
a note, we have skipped over multiple eps for this release as
there are few scenarios for the driver.

Testing/feedback welcome.

