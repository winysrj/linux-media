Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:54279 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753120AbbAZRIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 12:08:46 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: rcar_vin video buffer management fixes, v3
Date: Mon, 26 Jan 2015 17:08:38 +0000
Message-Id: <1422292120-30496-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This is version 3 of the hotfix patchset for video support on Lager,
in which we aim to fix the kernel's warnings about unexpected buffer
states. It replaces the following series:
	http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/87009

  This version of the series contains two patches which add a helper
function and then refactors the code where it is called, respectively.
Based on recent feedback, further modification is included in the
second patch where initialise/cleanup routines are removed due to
all significant content having moved elsewhere.

  The series comprises:
	[PATCH 1/2] media: rcar_vin: helper function for streaming stop
	[PATCH 2/2] media: rcar_vin: move buffer management to

Cheers,
  Wills
