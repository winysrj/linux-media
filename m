Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:51582 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859AbcHJSTC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <20160809145856.GC1666@katana>
References: <1470742517-12774-1-git-send-email-wsa-dev@sang-engineering.com>
 <1470742517-12774-2-git-send-email-wsa-dev@sang-engineering.com>
 <CAK3bHNWmxQsAtefcUocoOcEwtWnpptiVxzhXR-+jVU524RmnPw@mail.gmail.com> <20160809145856.GC1666@katana>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 10 Aug 2016 10:41:05 -0400
Message-ID: <CAK3bHNUL3NjFFex4US09ZnxvKV-1oJAu=qVrZUSgeKy90CBiAA@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: pci: netup_unidvb: don't print error when
 adding adapter fails
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

yes, you right. If we remove this message there is no big problem. But
if we do not remove this it's also ok, right ? What the big deal to
remove this type of messages (i'm just interested) ?


For me it's ok to remove:
Acked-by: Abylay Ospan <aospan@netup.ru>


2016-08-09 10:58 GMT-04:00 Wolfram Sang <wsa@the-dreams.de>:
>
>> Sometimes it better to show more message - especially in error conditions :)
>
> Sure, if they contain additional information.
>
>> btw, do you make sanity check for "duplicate" log messages ?
>
> I checked all error messages if they contain additional information.
>
>>             ret = i2c_add_adapter(&i2c->adap);
>>     -       if (ret) {
>>     -               dev_err(&ndev->pci_dev->dev,
>>     -                       "%s(): failed to add I2C adapter\n", __func__);
>>     +       if (ret)
>>                     return ret;
>>     -       }
>
> IMHO, this one doesn't. __func__ is not helpful to users. And the error
> messages in the core will make sure that a developer knows where to
> start looking.
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
