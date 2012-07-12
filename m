Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911Ab2GLUzK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 16:55:10 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, halli manjunatha <hallimanju@gmail.com>
Subject: RFC: Add support for limiting hw freq seeks to a certain band (v2)
Date: Thu, 12 Jul 2012 22:55:43 +0200
Message-Id: <1342126548-19349-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset, which builds on top of hverkuil's bands2 branch, which
adds the VIDIOC_ENUM_FREQ_BANDS API, add support for limiting
hw freq seeks to one of the bands from VIDIOC_ENUM_FREQ_BANDS, or a subset
there of.

The first patch introduces the new API and documents its, the other
patches are patches to the si470x radio driver, implementing the new API,
and removing the band module parameter as this is no longer needed
with this new API.

A git tree with all hverkuils patches included is here:
http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.6-wip

A git tree of xawtv3 with its radio app modified to support the new
API is here:
http://git.linuxtv.org/hgoede/xawtv3.git/shortlog/refs/heads/band-support

Changes in v2:
-improve / clarify the documentation on how the rangelow and rangehigh
 fields of the v4l2_hw_freq_seek struct are used

Regards,

Hans
