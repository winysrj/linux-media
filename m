Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeJaBI7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 21:08:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E7F058E2A
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:53 +0000 (UTC)
Received: from wingsuit.redhat.com (ovpn-117-230.ams2.redhat.com [10.36.117.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8769E1055009
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:52 +0000 (UTC)
From: Victor Toso <victortoso@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH dvb v1 0/4] miscellaneous changes
Date: Tue, 30 Oct 2018 17:14:47 +0100
Message-Id: <20181030161451.4560-1-victortoso@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Victor Toso <me@victortoso.com>

Hi,

As mentioned on IRC earlier [0], I'm trying to learn a bit about Kernel
and I'm using a usb dongle for dvb-t, which seems to work fine, for
that.

Two patches are related to dynamic debug that I have enabled and it ends
up printing doubled function name. The other two patches are minor code
changes that I did while reading code path related to the device I own.

Let me know if those make sense to you or not.

For now, I have also two questions, both made on IRC #linuxtv but got no
replies so I hope it is fine to ask here too (otherwise, let me know
where I can ask!)

1) If I do remove my usb device, I see that several modules are kept
loaded. I'm wondering if this is intentional or a bug. I can modprobe -r
all of them just fine, no one is using them.

2) What is the correct way to verify with v4l2-compliance tool, the
/dev/dvb/adapater#/* devices? I tried a few combinations but I'm not
trusting the results so far.

[0] https://linuxtv.org/irc/irclogger_log/linuxtv?date=2018-10-25,Thu&sel=6#l2

Ah, yes, this is my first contribution to the kernel, I checked with
scripts/checkpatch.pl but I'm welcome to advices if you see the need!

Cheers,

Victor Toso (4):
  af9033: Remove duplicated switch statement
  media: dvb: Use WARM definition from identify_state()
  media: dvb-usb-v2: remove __func__ from dev_dbg()
  media: dvb_frontend: remove __func__ from dev_dbg()

 drivers/media/dvb-core/dvb_frontend.c       | 142 ++++++++++----------
 drivers/media/dvb-frontends/af9033.c        |  12 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 111 ++++++++-------
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c  |   7 +-
 4 files changed, 128 insertions(+), 144 deletions(-)

-- 
2.17.2
