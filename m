Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51058 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2AWS0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 13:26:18 -0500
Received: by werb13 with SMTP id b13so2352794wer.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2012 10:26:16 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 23 Jan 2012 18:26:16 +0000
Message-ID: <CAOwYNKYKcHQUu6KHk5tibMRbqvQEa2A8ZvdfgpbhuZUFecFO-Q@mail.gmail.com>
Subject: DVB - attach to an open frontend device
From: Mike Martin <mike@redtux.org.uk>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not too sure if this is possible but what I want to do is this

open frontend
set frequency
add demux filters etc
record

then while this is running

I want to attach to the same process and add further demux filters
(without retuning - same frequency)

any tips?
