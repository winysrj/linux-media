Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36643 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbcCMH7p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 03:59:45 -0400
To: Shuah Khan <shuahkh@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Can you look at this daily build warning?
Message-ID: <56E51DEA.7010309@xs4all.nl>
Date: Sun, 13 Mar 2016 08:59:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

I am getting this warning since commit 840f5b0572ea9ddaca2bf5540a171013e92c97bd
(media: au0828 disable tuner to demod link in au0828_media_device_register()).

Can you take a look?

I'm not sure whether the dtv_demod should just be removed or if some other action
has to be taken.

Regards,

	Hans

linux-git-i686: WARNINGS

/home/hans/work/build/media-git/drivers/media/v4l2-core/v4l2-mc.c: In function 'v4l2_mc_create_media_graph':
/home/hans/work/build/media-git/drivers/media/v4l2-core/v4l2-mc.c:37:69: warning: unused variable 'dtv_demod' [-Wunused-variable]
  struct media_entity *tuner = NULL, *decoder = NULL, *dtv_demod = NULL;
                                                                     ^
