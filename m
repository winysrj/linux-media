Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39541 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939AbZE0Jkf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 05:40:35 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv4 0 of 8] FM Transmitter (si4713) and another changes
Date: Wed, 27 May 2009 12:35:47 +0300
Message-Id: <1243416955-29748-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

  I'm resending the FM transmitter driver and the proposed changes in
v4l2 api files in order to cover the fmtx extended controls class.

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
