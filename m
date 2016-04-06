Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57017 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754084AbcDFLqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2016 07:46:22 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com
Subject: [PATCH 0/2] videobuf2: Fix kernel memory overwriting
Date: Wed,  6 Apr 2016 14:46:06 +0300
Message-Id: <1459943168-18406-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

In multi-planar API, the buffer length and m.planes fields are checked
against the vb2 buffer before passing the buffer on to the core, but
commit b0e0e1f83de31aa0428c38b692c590cc0ecd3f03 removed this check from
VIDIOC_DQBUF path. This leads to kernel memory overwriting in certain
cases.

This affects only v4.4 and newer and a very few drivers which use the
multi-planar API. Due to the very limited scope of the issue this is not
seen to require special handling.

The patches should be applied to the stable series, I'll add cc stable
in the pull request.

-- 
Kind regards,
Sakari

