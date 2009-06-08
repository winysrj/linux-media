Return-path: <linux-media-owner@vger.kernel.org>
Received: from zero.voxel.net ([69.9.191.6]:46440 "EHLO zero.voxel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZFHAyG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 20:54:06 -0400
Received: from mail.voxel.net (localhost [127.0.0.1])
	by zero.voxel.net (Postfix) with ESMTP id 640E71AC0342
	for <linux-media@vger.kernel.org>; Sun,  7 Jun 2009 20:22:37 -0400 (EDT)
Message-ID: <ab60605f580782732ecd676ecbab3ea3.squirrel@mail.voxel.net>
Date: Sun, 7 Jun 2009 20:22:37 -0400 (EDT)
Subject: funny colors from XC5000 on big endian systems
From: "W. Michael Petullo" <mike@flyn.org>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is it possible that the XC5000 driver does not work properly on big endian
systems? I am using Linux/PowerPC 2.6.29.4. I have tried to view an analog
NTSC video stream from a Hauppauge 950Q using various applications
(including GStreamer v4lsrc and XawTV). The video is always present, but
in purple and green hues.

Mike

