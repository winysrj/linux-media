Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:42798 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3HBMFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 08:05:52 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id r72C5nZ5017931
	for <linux-media@vger.kernel.org>; Fri, 2 Aug 2013 12:05:49 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] qv4l2: add ALSA audio playback
Date: Fri,  2 Aug 2013 14:05:32 +0200
Message-Id: <1375445137-19443-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The qv4l2 test utility now supports ALSA playback of audio.
This allows for PCM playback during capture for supported devices.

This requires at least the OpenGL patch series' "qv4l2: add Capture menu" patch.
A device must be ALSA compatible in order to be used with the qv4l2.
The ALSA implementation requires ALSA on the system. If ALSA support is not present,
then this feature will not be compiled in.

Some of the changes/improvements:
- Capturing will also capture audio
- Added audio controls to the capture menu
- Selectable audio devices (can also have no audio)
- Automatically find corresponding audio source for a given video device if applicable
- Supports both radio, video and audio devices that uses PCM.
- Bug fixes

Known issues:
- Sometimes when generating the audio in and out device lists,
  it may take some time for the combo boxes to render correctly.
- If the audio causes underruns/overruns, try increase the audio buffer.
- Not all audio input/output combination will work, depending on system and devices.
- The A-V difference in ms is not always correct, but should still help as an indicator

