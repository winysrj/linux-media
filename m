Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1656 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaCNL5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 07:57:19 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2EBvFFd076731
	for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 12:57:17 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C33F22A1889
	for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 12:57:09 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH for v3.15 0/2] DocBook fixes
Date: Fri, 14 Mar 2014 12:57:05 +0100
Message-Id: <1394798227-3708-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two patches: the first fixes a broken DocBook build due to the rename of
v4l2_format_sdr to v4l2_sdr_format, the second is the second version of
my "clarify v4l2_pix_format and v4l2_pix_format_mplane fields" where I
dropped the height vs field sentences as you requested.

Regards,

	Hans

