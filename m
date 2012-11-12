Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58430 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2K0XLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 18:11:43 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so7118731lbb.19
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2012 15:11:42 -0800 (PST)
Message-ID: <1352703366.5567.18.camel@linux>
Subject: [patch 00/03 v2] driver for Masterkit MA901 usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: dougsland@gmail.com, hverkuil@xs4all.nl
Date: Mon, 12 Nov 2012 07:56:06 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is second version of small patch series for ma901 usb radio driver.
Initial letter about this usb radio was sent on October 29 and can be
found here: http://www.spinics.net/lists/linux-media/msg55779.html

Changes:
        - removed f->type check and set in vidioc_g_frequency()
        - added maintainers entry patch

Best regards,
Alexey Klimov

