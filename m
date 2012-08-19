Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.restena.lu ([158.64.1.62]:38366 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2HSRhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 13:37:24 -0400
Date: Sun, 19 Aug 2012 19:28:59 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/6] HID: picoLCD additional fixes + CIR support
Message-ID: <20120819192859.74136bb0@neptune.home>
In-Reply-To: <20120730213656.0a9f6d30@neptune.home>
References: <20120730213656.0a9f6d30@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series fixes some race conditions in picoLCD driver during remove()
and adds support for IR functionality.

Repeatedly binding/unbinding device at hid-picolcd driver level or at
usbhid level now works properly (except in rare occasions which trigger
a paging error in interrupt context (memcopy) and seem to come from
usbhid internals when usbhid gets interrupt between hid_hw_close() and
hid_hw_stop()).

CIR support is added using RC_CORE for the decoding and handling of
IR-event stream and works for a Sony and a JVC remote.

Bruno
