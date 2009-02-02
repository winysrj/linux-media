Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:15524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbZBBBql (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 20:46:41 -0500
Received: by fg-out-1718.google.com with SMTP id 16so472124fgg.17
        for <linux-media@vger.kernel.org>; Sun, 01 Feb 2009 17:46:39 -0800 (PST)
Message-ID: <4986507C.1050609@googlemail.com>
Date: Mon, 02 Feb 2009 02:46:36 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: obi@linuxtv.org, mchehab@redhat.com
Subject: [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this change set is wrong. The affected functions cannot be called from an interrupt
context, because they may process large buffers. In this case, interrupts are disabled for
a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
tasklet. This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.

Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
files).

Regards,
Hartmut
