Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60483 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdGLXRU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:17:20 -0400
Subject: Re: [PATCH V2 4/9] [media] dvb-core/dvb_ca_en50221.c: Fixed block
 comments
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
 <1499900458-2339-5-git-send-email-jasmin@anw.at>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <c8c9b074-32fe-96b8-6635-842898dfc956@iki.fi>
Date: Thu, 13 Jul 2017 02:17:15 +0300
MIME-Version: 1.0
In-Reply-To: <1499900458-2339-5-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2017 02:00 AM, Jasmin J. wrote:
> From: Jasmin Jessich <jasmin@anw.at>
> 
> Fixed all:
>    WARNING: Block comments use * on subsequent lines

Also multiline comments should be written like this:
/*
  * Comment.
  */

Quickly looking this patch serie I noticed few other coding style 
mistakes. You should read kernel coding style documentation first, and 
then make changes according to doc.

regards
Antti

-- 
http://palosaari.fi/
