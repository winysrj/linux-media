Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:38189 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdHSLoN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 07:44:13 -0400
Received: by mail-wr0-f169.google.com with SMTP id p8so6355436wrf.5
        for <linux-media@vger.kernel.org>; Sat, 19 Aug 2017 04:44:12 -0700 (PDT)
Subject: Re: [PATCH v2] media: isl6421: add checks for current overflow
From: Jemma Denson <jdenson@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <24d5b36b-0ed5-f290-15a3-d291b10b6c39@gmail.com>
 <201c07fc2bed74943f2a74fc5734d9aed3e62f8d.1502652879.git.mchehab@s-opensource.com>
 <bac2323e-6bde-08f8-1143-31a0b1d7176a@gmail.com>
 <20170816064226.54002cc7@vela.lan>
 <18c87cff-a407-8ebc-b758-eeb496f29345@gmail.com>
Message-ID: <870bb227-ec30-ddcd-11d5-db2bacd37fce@gmail.com>
Date: Sat, 19 Aug 2017 12:44:09 +0100
MIME-Version: 1.0
In-Reply-To: <18c87cff-a407-8ebc-b758-eeb496f29345@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/08/17 20:50, Jemma Denson wrote:

> On 16/08/17 10:42, Mauro Carvalho Chehab wrote:
>>> I've just tested both your v2 patch and changes I'm suggesting above; both work
>>> fine on my setup. Do you want me to send a v3?
>> Yeah, sure! I'm currently in travel, returning only on Friday, and I don't
>> have the hardware to test. So, if you can send it, I'd appreciate :-)
>> Cheers,
>> Mauro
> Ok, just sent. The if statements ended up being a bit complicated, but I added checking
> if the DCL bit was being overridden (it is by several cards under cx88), only pausing
> for a second if DCL was in use as the datasheet suggested that's only done in that mode,
> and also skipped checking overflow if the device was set to off.
> The latter should cover overflow somehow being picked up during attach and causing the
> attach to fail. Unlikely to happen but we shouldn't fail on what could be a transient
> issue.

Sorry, time for a v4! I wasn't happy with adding a permanent 200ms pause so I've reverted
that back to how you had it before. The pause before re-enabling dcl is only really needed
if it needs time to settle down and so reverting back to always doing a 1000ms on overload
should cover it.

Jemma.
