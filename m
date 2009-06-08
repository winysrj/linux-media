Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:53307 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZFHIWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 04:22:33 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv6 0 of 7] FM Transmitter (si4713) and another changes
Date: Mon,  8 Jun 2009 11:18:00 +0300
Message-Id: <1244449087-5543-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

  I'm resending the FM transmitter driver and the proposed changes in
v4l2 api files in order to cover the fmtx extended controls class.

  Difference from version #5 is that now I've dropped the patch which
adds a new i2c helper function. And now this series is based on Hans
tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-subdev. That tree
has the proper refactoring of v4l2 i2c helper functions. The work
done before in the patch dropped here, now was done by Hans.

  So, now the series includes only changes to add the new v4l2
FMTX extended controls (and its documetation) and si4713 i2c and platform
drivers (and its documentation as well).

  Again, comments are welcome.

BR,

---
Eduardo Valentin
