Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbcB0Nka (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 08:40:30 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	istaff124@gmail.com
Subject: [PATCH 0/1] v4lconvert: Add "PEGATRON CORPORATION" to asus_board_vendor
Date: Sat, 27 Feb 2016 14:40:23 +0100
Message-Id: <1456580424-9627-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Here is a patch to add "PEGATRON CORPORATION" to asus_board_vendor,
to fix an upside down bug reported to Fedora:

https://bugzilla.redhat.com/show_bug.cgi?id=1311545

I'm not 100% sure this is a good idea, it might cause a bunch of false
positives, but looking at the existing static PEGATRON entries in the
v4l_control_flags list, it seems that it really is just another vendor
string for Asus and that adding it to asus_board_vendor is best, so
I'm say 95% sure :)

Anyways your input on this is much appreciated. In the mean time I'll
kick of a scratch-build of the Fedora v4l-utils pkg with this patch
applied for the reporter to test.

Regards,

Hans


