Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37017 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933918AbbCPVmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 17:42:32 -0400
Received: by igcqo1 with SMTP id qo1so55762820igc.0
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 14:42:32 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 16 Mar 2015 14:42:32 -0700
Message-ID: <CAA7C2qiWp=ZHNWW_6cMBh-g5kzCn6p-9J3w4x5hNbSbyTarNyw@mail.gmail.com>
Subject: /dev/dvb not being creating when driver are loaded
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. I just installed a clean Debian Testing box and am having a
problem. When I load dvb drivers, /dev/dvb is not being created. I
don't know if this is a dvb issue, udev, or what. I have other boxes
also running Debian Testing, all using current packages & the same
versions of everything as this new install, and /dev/dvb is created
just fine when I load drivers of them. The only difference between
those boxes and the new one that I can tell is the new one uses
systemd while the others use sysvinit. I installed sysvinit and then
uninstalled systemd, did an upgrade-grub, and then reboot but /dev/dvb
still isn't being created so I don't think the problem is with
systemd.

Also, none of the working boxes have any special udev files/rules that
I've found so it's probably safe to eliminate the need for
specific/special udev rules as well.

Anyone have any clue about this?

Thanks
