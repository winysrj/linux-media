Return-path: <linux-media-owner@vger.kernel.org>
Received: from shark1.inbox.lv ([194.152.32.81]:34945 "EHLO shark1.inbox.lv"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbeEUMHf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 08:07:35 -0400
Received: from shark1.inbox.lv (localhost [127.0.0.1])
        by shark1-out.inbox.lv (Postfix) with ESMTP id 4ECB41118106
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 15:01:21 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
        by shark1-in.inbox.lv (Postfix) with ESMTP id 48A0611180D4
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 15:01:21 +0300 (EEST)
Received: from shark1.inbox.lv ([127.0.0.1])
        by localhost (shark1.inbox.lv [127.0.0.1]) (spamfilter, port 35)
        with ESMTP id zK1Cnu_7JJ7K for <linux-media@vger.kernel.org>;
        Mon, 21 May 2018 15:01:20 +0300 (EEST)
Received: from mail.inbox.lv (pop1 [10.0.1.111])
        by shark1-in.inbox.lv (Postfix) with ESMTP id D1A8911180CD
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 15:01:20 +0300 (EEST)
Received: from [192.168.178.31] (p57bb4ec1.dip0.t-ipconnect.de [87.187.78.193])
        (Authenticated sender: light23@inbox.lv)
        by mail.inbox.lv (Postfix) with ESMTPA id 7225C4490D
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 15:01:20 +0300 (EEST)
To: linux-media@vger.kernel.org
From: Light <light23@inbox.lv>
Subject: Bugfix for Tevii S650
Message-ID: <897fac42-1456-c2ad-94be-3aee64df18d6@inbox.lv>
Date: Mon, 21 May 2018 14:01:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

staring with kernel 4.1 the tevii S650 usb box is not working any more, 
last working version was 4.0.

The  bug was also reported here 
https://www.spinics.net/lists/linux-media/msg121356.html

I found a solution for it and uploaded a patch to the kernel bugzilla.

See here: https://bugzilla.kernel.org/show_bug.cgi?id=197731

Can somebody of the maintainers have a look on it and apply the patch to 
the kernes sources?

Light
