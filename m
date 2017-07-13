Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36919 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751265AbdGMAE0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 20:04:26 -0400
Subject: Re: [PATCH V2 4/9] [media] dvb-core/dvb_ca_en50221.c: Fixed block
 comments
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
 <1499900458-2339-5-git-send-email-jasmin@anw.at>
 <c8c9b074-32fe-96b8-6635-842898dfc956@iki.fi>
 <080f360c-a6cb-0f5c-b2ca-f380a78a2cf9@anw.at>
 <ffcb064e-3b82-fbae-ab32-d9a4a56f6716@iki.fi>
 <345e0587-b0a8-8fed-0bdb-4313093cf56d@anw.at>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <f003e6db-95e0-dcc4-88fe-e895a0d3b59d@iki.fi>
Date: Thu, 13 Jul 2017 03:04:17 +0300
MIME-Version: 1.0
In-Reply-To: <345e0587-b0a8-8fed-0bdb-4313093cf56d@anw.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2017 02:45 AM, Jasmin J. wrote:
> Hello Antti!
> 
>> Have you ever looked that coding style doc?
> Yes I read it several times already and used it in my daily work in my
> previous company.
> 
> Beside the Multi-line comment style, which I will fix in a follow up,
> you mentioned other issues.
> Please can you tell me which one you mean, so that I can check the series
> for those things.

eh, OK, here short list from my head:
* you fixed comments, but left //-comments

* many cases where if (ret != 0), which generally should be written as 
if (ret). If you expect it is just error ret value, then prefer if 
(ret), but if ret has some other meaning like it returns number of bytes 
then if you expect 0-bytes returned (ret != 0) is also valid.

* unnecessary looking line split like that:
if (a
       & b)

* logical continuous line split wrong (I think I have seen checkpatch 
reported that kind of mistakes, dunno why not now)
if (a
     && b)
== >
if (a &&
     b)


Antti

-- 
http://palosaari.fi/
