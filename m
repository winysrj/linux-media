Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44866 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdGMHaH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 03:30:07 -0400
Subject: Re: [PATCH V2 4/9] [media] dvb-core/dvb_ca_en50221.c: Fixed block
 comments
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
 <1499900458-2339-5-git-send-email-jasmin@anw.at>
 <c8c9b074-32fe-96b8-6635-842898dfc956@iki.fi>
 <080f360c-a6cb-0f5c-b2ca-f380a78a2cf9@anw.at>
 <ffcb064e-3b82-fbae-ab32-d9a4a56f6716@iki.fi>
 <345e0587-b0a8-8fed-0bdb-4313093cf56d@anw.at>
 <f003e6db-95e0-dcc4-88fe-e895a0d3b59d@iki.fi>
 <ab35758a-5769-73c3-ab63-34c34b483eab@iki.fi>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <cb9a36a6-95c9-ace8-5f39-e36b2b406971@anw.at>
Date: Thu, 13 Jul 2017 09:29:54 +0200
MIME-Version: 1.0
In-Reply-To: <ab35758a-5769-73c3-ab63-34c34b483eab@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti!

> actually it reports, when run --strict mode
I checked this once, but I thought this would be too aggressive changes.

>> * many cases where if (ret != 0), which generally should be written as if
>> (ret). If you expect it is just error ret value, then prefer if (ret), but
>> if> ret has some other meaning like it returns number of bytes then if you
>> expect 0-bytes returned (ret != 0) is also valid.
In fact I did no real code changes to keep the impact as little as possible.
But I agree fully with you and in my drivers I used always (ret) or (!ret).
Although this has been changed in my new company when it comes to certified
software ... .

I will try also to compile with GCC 7.1.1, if I get one for my system.

>> * unnecessary looking line split like that:
>> if (a
>>        & b)
I am sure I did this because of the 80 col limit, but I will look again.

THX for your review and the valuable input. I will add you the receiver list
next time.

BR,
   Jasmin
