Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:59176 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755401AbaGIQmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 12:42:38 -0400
Date: Wed, 9 Jul 2014 17:42:25 +0100
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: William Towle <william.towle@codethink.co.uk>, mchehab@redhat.com,
	hans.verkuil@cisco.com, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, vladimir.barinov@cogentembedded.com
Subject: RFC: soc_camera, rcar_vin, and adv7604
Message-Id: <20140709174225.63a742ce09418cff539bb70a@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

My colleague and I are trying to work out what to do to support the following combination:

soc_camera + rcar_vin for capture, and the mainline adv7604 driver (which we have modified to successfully drive the adv7612).

The problem we face is that the 7604 driver uses the new "pads" API, but soc_camera based drivers like rcar_vin do not.

Obviously, there are a few approaches we could take, but we could use some guidance on this.

One approach would be to bodge some non-pads older API support into the 7604 driver. This would probably be the easiest solution.

A better approach might be to add pad API support to soc_camera, but it seems to me that the soc_camera API does not abstract away all of the areas that might need to be touched, which would lead to much pad-related churn in all the other soc_camera drivers.

The codebase is rather large, and we're struggling to see a clear path through this. Whatever we do, we would like to be acceptable upstream, so we'd like to open a discussion.

Perhaps a soc_camera2 with pads support?

-- 
Ian Molton <ian.molton@codethink.co.uk>
