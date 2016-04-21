Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:41828 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751571AbcDUJl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 05:41:26 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 0/8] Input: atmel_mxt_ts - output raw touch diagnostic data via V4L
Date: Thu, 21 Apr 2016 10:31:33 +0100
Message-Id: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of patches to add diagnostic data support to the Atmel
maXTouch driver. It's a rewrite of the previous implementation which output via
debugfs: it now uses a V4L2 device in a similar way to the sur40 driver.

There are significant performance advantages to putting this code into the
driver. The algorithm for retrieving the data has been fairly consistent across
a range of chips, with the exception of the mXT1386 series (see patch).

We have a utility which can read the data and display it in a useful format:
	https://github.com/ndyer/heatmap/commits/heatmap-v4l

These patches are also available from
	https://github.com/ndyer/linux/commits/diagnostic-v4l

Any feedback appreciated.

