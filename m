Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:49341 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZBCBHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:07:32 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763350fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:07:32 -0800 (PST)
Subject: [patch review 0/8] radio-mr800 patch series
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:07:03 +0300
Message-Id: <1233623223.17456.246.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all

This patch series serves generally to add new feature (stereo support)
into driver, fix small old issues, and prepare driver to next changes.

Comments, suggestions, remarks are welcome :)

Changes are:

[patch review 1/8] radio-mr800: codingstyle cleanups
[patch review 2/8] radio-mr800: place dev_err instead of dev_warn
[patch review 3/8] radio-mr800: add more dev_err messages in probe
[patch review 4/8] radio-mr800: move radio start and stop in one
function
[patch review 5/8] radio-mr800: fix amradio_set_freq
[patch review 6/8] radio-mr800: add stereo support
[patch review 7/8] radio-mr800: add few lost mutex locks
[patch review 8/8] radio-mr800: increase version and add comments

Tested under 2.6.29-rc3 with gcc-4.3.3 help. Works fine.

-- 
Best regards, Klimov Alexey

