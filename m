Return-path: <linux-media-owner@vger.kernel.org>
Received: from mars.kreativmedia.ch ([80.74.144.35]:52403 "EHLO
	mars.kreativmedia.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZFZJxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 05:53:45 -0400
Message-ID: <4A44990F.5050901@aokks.org>
Date: Fri, 26 Jun 2009 11:46:55 +0200
From: jmdk <jmdk@aokks.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cropping with Hauppauge HVR-1900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a Hauppauge HVR-1900 which works fine with the pvrusb2 driver.
However because most TV channels now air with 16:9 content inside 4:3
images, I would like to crop out the top and bottom black bars before
encoding via the hardware MPEG2 encoder. I tried using the ctl_crop_top
and ctl_crop_height in  /sysfs as well as the --set-crop option of
v4l2-ctrl but only received error messages indicating a value out of range.

The card has a cx25843 which should support cropping. Does anyone know
how to get this feature to work ?

Thanks in advance for the help,

Joseph
