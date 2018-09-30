Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f53.google.com ([209.85.128.53]:50254 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbeI3WuO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Sep 2018 18:50:14 -0400
Received: by mail-wm1-f53.google.com with SMTP id s12-v6so6381825wmc.0
        for <linux-media@vger.kernel.org>; Sun, 30 Sep 2018 09:16:35 -0700 (PDT)
Subject: [Regression] DVBSky S960CI hard broken in 4.18
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
To: linux-media@vger.kernel.org
References: <34094978-8c08-bf65-bbb4-edfaf2afb5e7@googlemail.com>
Cc: mchehab+samsung@kernel.org
Message-ID: <d0042374-b508-7cb2-cb93-5f4a1951ec95@googlemail.com>
Date: Sun, 30 Sep 2018 18:16:32 +0200
MIME-Version: 1.0
In-Reply-To: <34094978-8c08-bf65-bbb4-edfaf2afb5e7@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

sorry to bump this, but I wonder whether I could help by submitting a [PATCH] reverting the buggy change from 7d95fb7 ? 
As discussed in https://bugzilla.kernel.org/show_bug.cgi?id=199323 , the widespread card is unusable since 7d95fb7 . 

Please include me in any replies, I am not subscribed to the list. 

Cheers,
	Oliver

Am 24.09.18 um 22:26 schrieb Oliver Freyermuth:
> Dear DVB experts,
> 
> commit:
> 7d95fb7 - media: dvbsky: use just one mutex for serializing device R/W ops
> hard breaks DVBSky cards. 
> Also the previous locking commits have caused several runtime issues. 
> 
> Since the bug tracker is not regularly checked, I'd love to make everybody aware of the corresponding issue
> with much more detail: 
> https://bugzilla.kernel.org/show_bug.cgi?id=199323
> which has gotten large attention from several users. 
> 
> From my side, I can confirm that reverting 7d95fb7 makes the card work again for me. on 4.18. 
> With 7d95fb7 applied, the card tunes fine, but does not deliver any data. 
> 
> Please include me in any replies, I am not subscribed to the list. 
> 
> Cheers and all the best,
> 	Oliver
> 
