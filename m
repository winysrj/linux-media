Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:35475 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbaK2Kof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 05:44:35 -0500
Received: from [192.168.1.106] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id D0FA92A008E
	for <linux-media@vger.kernel.org>; Sat, 29 Nov 2014 11:44:19 +0100 (CET)
Message-ID: <5479A386.9090606@xs4all.nl>
Date: Sat, 29 Nov 2014 11:44:22 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC] pms/bw-qcam/c-qcam/w9966: deprecate and remove
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I propose that these four drivers are deprecated and moved to staging and that
1-2 kernel cycles later these drivers are removed.

bw-qcam, c-qcam and w9966 are all parallel port webcams. The w9966 driver
hasn't been tested in a very long time since nobody has hardware. I do have
hardware for bw-qcam and c-qcam although the c-qcam never gave me a good picture.
I don't know whether that's due to hardware problems or driver problems.

The bw-qcam works for the most part but it can do weird things occasionally,
especially if you fiddle around too much with the camera controls.

All three webcam drivers are useless in practice since the quality and framerate
is so poor. And vastly better cheap alternatives are available today.

These drivers do use the latest frameworks, so from the point-of-view of kernel
APIs they are OK. But it is extremely unlikely that anyone is still using such
webcams and with easy availability of alternatives I think it is time to retire
them.

The pms driver is a video capture ISA card. I do have hardware, although the last
time I tested it streaming didn't work anymore for no clear reason. While the
code is OK it has the same issue as the parallel webcams: poor quality and frame
rate, nobody uses it anymore and cheap and much better alternatives exist today.

I believe it is time to retire these four drivers.

Regards,

	Hans
