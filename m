Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:47750 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3AVPce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 10:32:34 -0500
Received: by mail-ia0-f182.google.com with SMTP id w33so3321134iag.41
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 07:32:34 -0800 (PST)
MIME-Version: 1.0
From: Oleg Shirochenkov <o.shirochenkov@gmail.com>
Date: Tue, 22 Jan 2013 19:31:54 +0400
Message-ID: <CAMfZRv9rE7J0ss=NDmRdhXc6=04yP18uj1v_ch_noB_igWOO3A@mail.gmail.com>
Subject: V4L DVBSky C2800E DVB-C CI PCIe TV tuner
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.
I was looking for supported TV-tuner on the page "DVB-C PCIe Cards" of
LinuxTVWiki - http://www.linuxtv.org/wiki/index.php/DVB-C_PCIe_Cards
There is no info about "DVBSky C2800E DVB-C PCIe with CI" card, DVBSky
tells that this has "Support Linux VDR, i.e. CNVDR".
I see no support in kernel but I've found DVBSky Support page -
http://www.dvbsky.net/Support.html
Inside of `linux-3.7.3-dvbsky.patch` can be found support for DVBSKY
S950, DVBSKY S952, DVBSKY S950CI DVB-S2 CI, DVBSKY C2800E DVB-C CI.
Some merchants report that "Mystique CaBiX-Xpress DVB-C PCIe with CI"
is the same as "DVBSky C2800E DVB-C PCIe with CI".

Are there any users that can report if Mystique CaBiX-Xpress or DVBSky
C2800E are working fine with CI support?
Could this card be used under MythTV?
Could these patches be included in upstream?

Also, wiki page on LinuxTVWiki tells that TBS6618 card is working fine
under Linux when using driver from TBS, but support is not in the
kernel, TBS provides support for many of their cards. Could these
patches be included in some future versions of kernel too?
