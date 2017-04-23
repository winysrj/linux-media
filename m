Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58681 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1045264AbdDWMTY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 08:19:24 -0400
Subject: Re: [PATCH 1/3] [media] si2157: get chip id during probing
To: Andreas Kemnade <andreas@kemnade.info>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
 <1489616530-4025-2-git-send-email-andreas@kemnade.info>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <43216679-3794-14ca-b489-00ac97a57777@iki.fi>
Date: Sun, 23 Apr 2017 15:19:21 +0300
MIME-Version: 1.0
In-Reply-To: <1489616530-4025-2-git-send-email-andreas@kemnade.info>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2017 12:22 AM, Andreas Kemnade wrote:
> If the si2157 is behind a e.g. si2168, the si2157 will
> at least in some situations not be readable after the si268
> got the command 0101. It still accepts commands but the answer
> is just ffffff. So read the chip id before that so the
> information is not lost.
> 
> The following line in kernel output is a symptome
> of that problem:
> si2157 7-0063: unknown chip version Si21255-\xffffffff\xffffffff\xffffffff
That is hackish solution :( Somehow I2C reads should be get working 
rather than making this kind of work-around. Returning 0xff to i2c reads 
means that signal strength also shows some wrong static value?

regards
Antti

-- 
http://palosaari.fi/
