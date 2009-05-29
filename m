Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:18607 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZE2HiA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 03:38:00 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "\\\"ext Hans Verkuil\\\"" <hverkuil@xs4all.nl>,
	"\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>
Cc: "\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 0 of 8] FM Transmitter (si4713) and another changes
Date: Fri, 29 May 2009 10:33:20 +0300
Message-Id: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

  I'm resending the FM transmitter driver and the proposed changes in
v4l2 api files in order to cover the fmtx extended controls class.

  Difference from version #4 is that now I'm sending the correct patches.
The last patch series was messed up with wrong paths names.

  It is basically the same series of version #3. However I rewrote it
to add the following comments:

  * Check kernel version for i2c helper function. Now the board data
is passed not using i2c_board_info. This way all supported kernel
versions can use the api. Besides that, the .s_config callback was
added in core ops.

  * All patches are against v4l-dvb hg repository.

  Again, comments are welcome.

BR,

---
Eduardo Valentin
