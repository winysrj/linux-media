Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53882 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752142AbdFUFu5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 01:50:57 -0400
Subject: Re: [PATCH] [media] ddbridge: use pr_* macros in favor of printk
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de
References: <20170620174442.7528-1-d.scheller.oss@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <9424d055-8e34-3e08-0c12-378170b842f7@iki.fi>
Date: Wed, 21 Jun 2017 08:50:50 +0300
MIME-Version: 1.0
In-Reply-To: <20170620174442.7528-1-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2017 08:44 PM, Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Side effect: KERN_DEBUG messages aren't written to the kernel log anymore.
> This also improves the tda18212_ping reporting a bit so users know that if
> pinging wasn't successful, bad things might happen.

It is device, not library, thus you should really use dev_ logging 
instead. With dev_ logging system could print better info, bus id etc.


regards
Antti


-- 
http://palosaari.fi/
