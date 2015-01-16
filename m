Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:50008 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754790AbbAPQXF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 11:23:05 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH 0/5] media: rcar_vin: Fixes for buffer management
Date: Fri, 16 Jan 2015 16:22:57 +0000
Message-Id: <1421425379-1858-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  The following is a subset of our work in progress branch for video
support on the Renesas "Lager" board, comprising hotfixes for video
buffer management.

  We are successfully capturing single frames and video with the
complete branch, and intend to follow up with stable patches from
the branch in due course.

  Included here:
	[PATCH 1/2] media: rcar_vin: helper function for streaming stop
	[PATCH 2/2] media: rcar_vin: move buffer management to .stop_streaming handler

Cheers,
  Wills.
