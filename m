Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1226 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760227Ab2D0Rn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 13:43:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-usb@vger.kernel.org
Subject: How do I detect if disconnect is called due to module removal?
Date: Fri, 27 Apr 2012 19:43:50 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271943.50706.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm cleaning up some USB FM radio drivers and I realized that I need to know
in the disconnect callback whether I'm called due to a module unload or due
to an unplug event.

In the first case I need to first mute the audio output of the device, in the
second case I can skip that.

I can just try and always mute the device but that results in a error message
in the case the device is unplugged.

Is there a field I can test somewhere to detect what caused the disconnect?

Regards,

	Hans
