Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46675 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbeIYCaZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 22:30:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id z3-v6so9176709wrr.13
        for <linux-media@vger.kernel.org>; Mon, 24 Sep 2018 13:26:27 -0700 (PDT)
Received: from ?IPv6:2a01:5c0:e084:1480:4119:c330:a32c:b342? ([2a01:5c0:e084:1480:4119:c330:a32c:b342])
        by smtp.googlemail.com with ESMTPSA id u13-v6sm187364wrq.16.2018.09.24.13.26.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Sep 2018 13:26:24 -0700 (PDT)
To: linux-media@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: DVBSky S960CI hard broken in 4.18
Message-ID: <34094978-8c08-bf65-bbb4-edfaf2afb5e7@googlemail.com>
Date: Mon, 24 Sep 2018 22:26:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear DVB experts,

commit:
7d95fb7 - media: dvbsky: use just one mutex for serializing device R/W ops
hard breaks DVBSky cards. 
Also the previous locking commits have caused several runtime issues. 

Since the bug tracker is not regularly checked, I'd love to make everybody aware of the corresponding issue
with much more detail: 
https://bugzilla.kernel.org/show_bug.cgi?id=199323
which has gotten large attention from several users. 

>From my side, I can confirm that reverting 7d95fb7 makes the card work again for me. on 4.18. 
With 7d95fb7 applied, the card tunes fine, but does not deliver any data. 

Please include me in any replies, I am not subscribed to the list. 

Cheers and all the best,
	Oliver
