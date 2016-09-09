Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35955 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbcIIPKx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 11:10:53 -0400
Received: by mail-lf0-f68.google.com with SMTP id s29so2828653lfg.3
        for <linux-media@vger.kernel.org>; Fri, 09 Sep 2016 08:10:52 -0700 (PDT)
From: Alec Leamas <leamas.alec@gmail.com>
Subject: IR remote repeat handling broken + patch
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: labbott@redhat.com
Message-ID: <f1277e9a-d9dc-900c-1cb7-bc02b9b61eb7@gmail.com>
Date: Fri, 9 Sep 2016 17:10:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear list,

Somewhere between 4.4.7 and 4.6.4 the IR remote repeat events broke. I 
eventually bisected it down to "[078600f] [media] rc-core: allow calling 
rc_open with device not initialized". While going further with this I 
discovered that  a patch had been posted on this list [1].  However, the 
patch is seemingly not reviewed.

Could someone please review this patch? I have tested it myself, and 
Fedora has pulled  the patch in the  branches [2]. The problem is bad, 
blocking many remotes from working as expected in lirc.


Cheers!


--alec


[1] http://www.spinics.net/lists/linux-media/msg103384.html

[2] https://bugzilla.redhat.com/show_bug.cgi?id=1360688

