Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2108 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755616AbcIFL4w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 07:56:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v4 0/8] New raw bayer format definitions, fixes
Date: Tue,  6 Sep 2016 14:55:32 +0300
Message-Id: <1473162940-31486-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here's the fourth version of the new raw bayer format definition patchset.

On Mauro's request, I've dropped the patches adding the new pixel formats
as they're not being used in a driver now. I'm keeping these patches
around in order to later on merge them once needed:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=packed12-postponed>

Since v3:

- Remove new pixelformat definitions

- Add support for the new media bus codes in the smiapp driver

-- 
Kind regards,
Sakari


