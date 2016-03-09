Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40271 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbcCITJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 14:09:46 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [RFC PATCH 0/3] [media] tvp515p: Proposal for MC input connector support
Date: Wed,  9 Mar 2016 16:09:23 -0300
Message-Id: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I was waiting for the MC input connector support discussion to settle before
attempting to propose another patch series for the tvp5150 video decoder but
IIUC you are going to continue the discussion at ELC so I'm posting a series
that I believe is aligned with the latest conversations.

This is of course a RFC and not meant to be merged but just to start looking
how the DT binding using OF graph for connectors could look like and to see
an implementation that uses a PAD (and thus link) per electrical signal (the
1:1 model mentioned by Laurent).

The mc_nextgen_test dot output after applying the series can be found at [0]
and the graph png generated using the dot tool at [1].

I've also uploaded the dot files and png when the Composite0 [2,3], Composite1
[4,5] and S-Video [6,7] links are enabled.

I tested these patches on an IGEPv2 by capturing using both Composite inputs,
unfortuantely S-Video using the two RCA connectors is not working, but seems
that is a regression with the tvp5150 driver not related with these patches.

[0]: http://hastebin.com/novoxezeko.tex
[1]: http://i.imgur.com/RWZEpMn.png
[2]: http://hastebin.com/asaduyetuf.tex
[3]: http://i.imgur.com/6y7d7AS.png
[4]: http://hastebin.com/dijowanuki.tex
[5]: http://i.imgur.com/Qr1F9dL.png
[6]: http://hastebin.com/zegiwisoli.tex
[7]: http://i.imgur.com/TdrVJ0R.png

Best regards,
Javier


Javier Martinez Canillas (3):
  [media] v4l2-mc.h: Add a S-Video C input PAD to demod enum
  [media] tvp5150: Add input connectors DT bindings
  [media] tvp5150: Replace connector support according to DT binding

 .../devicetree/bindings/media/i2c/tvp5150.txt      |  59 +++++++
 drivers/media/i2c/tvp5150.c                        | 190 +++++++++++++++------
 include/media/v4l2-mc.h                            |   3 +-
 3 files changed, 203 insertions(+), 49 deletions(-)

-- 
2.5.0

