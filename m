Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:43171 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbbBSKVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 05:21:25 -0500
Received: by mail-qg0-f53.google.com with SMTP id f51so5458141qge.12
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 02:21:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E5B028.5080900@southpole.se>
References: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>
	<54E5B028.5080900@southpole.se>
Date: Thu, 19 Feb 2015 12:21:24 +0200
Message-ID: <CAKv9HNaSqgFpC+TmMm86Y7mrgXvZ9U+wqdgjM4n=hf80p2W1jg@mail.gmail.com>
Subject: Re: [RFC PATCH] mn88472: reduce firmware download chunk size
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
To: Benjamin Larsson <benjamin@southpole.se>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 February 2015 at 11:43, Benjamin Larsson <benjamin@southpole.se> wrote:
> On 2015-02-19 10:13, Antti Seppälä wrote:
>>
>> It seems that currently the firmware download on the mn88472 is
>> somehow wrong for my Astrometa HD-901T2.
>>
>> Reducing the download chunk size (mn88472_config.i2c_wr_max) to 2
>> makes the firmware download consistently succeed.
>>
>
>
> Hi, try adding the workaround patch I sent for this.
>
> [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c transfer errors
>
> I now see that it hasn't been merged. But I have been running with this
> patch for a few months now without any major issues.
>

The patch really did improve firmware loading. Weird...

Even with it I still get occasional i2c errors from r820t:

[   15.874402] r820t 8-003a: r820t_write: i2c wr failed=-32 reg=0a len=1: da
[   81.455517] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
len=4: 69 74 e6 df
[   99.949702] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
len=4: 69 74 e6 df

These errors seem to appear more often if I'm reading the signal
strength values using e.g. femon.

Br,
-Antti
