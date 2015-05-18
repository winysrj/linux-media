Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24021 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbbERMbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 08:31:23 -0400
Date: Mon, 18 May 2015 15:31:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (6059): ivtv: log stereo/bilingual audio modes
Message-ID: <20150518123109.GB32633@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 25e3f8f40ecf: "V4L/DVB (6059): ivtv: log stereo/bilingual
audio modes" from Aug 19, 2007, leads to the following static checker
warning:

	drivers/media/pci/ivtv/ivtv-ioctl.c:1533 ivtv_log_status()
	warn: masked condition is always false. '(itv->dualwatch_stereo_mode & ~768) == 512'

drivers/media/pci/ivtv/ivtv-ioctl.c
  1529          ivtv_call_all(itv, core, log_status);
  1530          ivtv_get_input(itv, itv->active_input, &vidin);
  1531          ivtv_get_audio_input(itv, itv->audio_input, &audin);
  1532          IVTV_INFO("Video Input:  %s\n", vidin.name);
  1533          IVTV_INFO("Audio Input:  %s%s\n", audin.name,
  1534                  (itv->dualwatch_stereo_mode & ~0x300) == 0x200 ? " (Bilingual)" : "");
                                                      ^
Probably this bitwise NOT is a typo?  In other words:

			(itv->dualwatch_stereo_mode & 0x300) == 0x200 ? " (Bilingual)" : "");


  1535          if (has_output) {

regards,
dan carpenter
