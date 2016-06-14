Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38786 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcFNOvs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 10:51:48 -0400
Received: by mail-wm0-f44.google.com with SMTP id m124so126812267wme.1
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 07:51:48 -0700 (PDT)
MIME-Version: 1.0
From: "Lucas C. Villa Real" <lucasvr@gobolinux.org>
Date: Tue, 14 Jun 2016 11:51:46 -0300
Message-ID: <CAAvzgtYPpM6YrMaQsxg5cpAZ_iJKRCLc37r9T9kjWWbgppRtRA@mail.gmail.com>
Subject: [ANNOUNCE] DemuxFS v1.1
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings, all!

I am happy to announce a new release of DemuxFS, the MPEG-2
demultiplexer file system.

DemuxFS sniffs MPEG-2 TS streams and exposes the decoded contents
(including interactive programs and firmware updates) as a virtual
filesystem. Tables are represented under directories of their own
(e.g., /PMT, /PAT, /EIT) and their properties are shown as regular
files. Audio and video streams can be inspected and played back
straight from FIFO files.

The code and further details are available at https://github.com/lucasvr/demuxfs

Thanks!
Lucas
