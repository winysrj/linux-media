Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46957 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab2AEUWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 15:22:55 -0500
Received: by qats34 with SMTP id s34so334240qat.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 12:22:55 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Jan 2012 21:22:54 +0100
Message-ID: <CAHF9RemG4M2apwcbUG+7YvkLrbpoZmE6Nh2XMHPT4FM3jRW_Ng@mail.gmail.com>
Subject: Support for RC-6 in em28xx driver?
From: =?ISO-8859-1?Q?Simon_S=F8ndergaard?= <john7doe@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently purchased a PCTV 290e USB Stick (em28174) it comes with a
remote almost as small as the stick itself... I've been able to get
both stick and remote to work. I also own an MCE media center remote
from HP (this make
http://www.ebay.com/itm/Original-Win7-PC-MCE-Media-Center-HP-Remote-Controller-/170594956920)
that sends RC-6 codes. While it do have a windows logo I still think
it is vastly superior to the one that shipped with the stick :-)

If I understand it correctly em28174 is a derivative of em2874?

In em28xx-input.c it is stated that: "em2874 supports more protocols.
For now, let's just announce the two protocols that were already
tested"

I've been searching high and low for a datasheet for em28(1)74, but
have been unable to find it online. Do anyone know if one of the
protocols supported is RC-6? and if so how do I get a copy of the
datasheet?

Br,
/Simon
