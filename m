Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4876 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1AVLGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 06:06:21 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0MB69iY074561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 12:06:20 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/3] v4l2-ctrls: add new functionality
Date: Sat, 22 Jan 2011 12:05:58 +0100
Message-Id: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This RFC patch series adds and documents two new features of the control
framework.

The first adds support to enable or disable specific controls or all controls
from a control handler. This is needed to support drivers that need to change
which controls are available based on the chosen input or output. In cases
like this each input or output is hooked up to a different video receiver or
transmitter, each with its own set of controls. Switching inputs/outputs means
that the controls from the new input should be enabled, while those of the
others should be disabled.

The second adds support to simplify handling of 'auto-foo/foo' type of controls.
E.g.: autogain/gain, autoexposure/exposure, etc. It is a bit tricky to handle
that correctly and after having to do this many times when I was converting the
soc_camera sensors I decided to add special support for this in the framework.

It should ensure consistent handling of these special kinds of controls in the
drivers.

If there are no comments, then I plan on making a pull request for this for
2.6.39 and base the soc_camera and ov7670 conversions on this. For 2.6.39 I
want to finish converting all subdev to the control framework and make a good
start at converting the v4l2 drivers as well.

