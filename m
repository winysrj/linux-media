Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37208 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750755AbdGLX2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:28:46 -0400
Subject: Re: [PATCH V2 4/9] [media] dvb-core/dvb_ca_en50221.c: Fixed block
 comments
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
 <1499900458-2339-5-git-send-email-jasmin@anw.at>
 <c8c9b074-32fe-96b8-6635-842898dfc956@iki.fi>
 <080f360c-a6cb-0f5c-b2ca-f380a78a2cf9@anw.at>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <ffcb064e-3b82-fbae-ab32-d9a4a56f6716@iki.fi>
Date: Thu, 13 Jul 2017 02:28:42 +0300
MIME-Version: 1.0
In-Reply-To: <080f360c-a6cb-0f5c-b2ca-f380a78a2cf9@anw.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2017 02:23 AM, Jasmin J. wrote:
> Hello Antti!
> 
>> Quickly looking this patch serie I noticed few other coding style mistakes.
>> You should read kernel coding style documentation first, and then make
>> changes according to doc.
> In fact I used checkpatch.pl to find the issues and fixed them. All the patches
> are 100% checkpatch.pl tested and did not have one single error or warning.
> 
> So please can you point me to those issues you mean.

Have you ever looked that coding style doc? Maybe better to start 
reading it first. Checkpatch is only a tool, it is nothing which makes 
100% decision which is correct or not.

Multi-line comment style is explained on section 8 on kernel coding 
style doc.

Antti


-- 
http://palosaari.fi/
