Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:43483 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3BRC5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 21:57:03 -0500
Received: by mail-vc0-f170.google.com with SMTP id p16so3376162vcq.29
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2013 18:57:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302161739.49850.linux@rainbow-software.org>
References: <1359750087-1155-1-git-send-email-linux@rainbow-software.org>
	<201302161739.49850.linux@rainbow-software.org>
Date: Sun, 17 Feb 2013 21:57:01 -0500
Message-ID: <CAOcJUbwPFoBANp0J_unvN9R91gRLrBfVOpp3TqE7iQR4tHG7kA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM
From: Michael Krufky <mkrufky@linuxtv.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 16, 2013 at 11:39 AM, Ondrej Zary
<linux@rainbow-software.org> wrote:
> On Friday 01 February 2013 21:21:23 Ondrej Zary wrote:
>> Add AverMedia AverTV Satellite Hybrid+FM (A706) card to saa7134 driver.
>>
>> This requires some changes to tda8290 - disabling I2C gate control and
>> passing custom std_map to tda18271.
>> Also tuner-core needs to be changed because there's currently no way to
>> pass any complex configuration to analog tuners.
>
> What's the status of this patch series?
>
> The two tda8290 patches are in Michael's dvb tree.
> I've sent an additional clean-up patch (on Mauro's suggestion) for the
> tuner-core change.
> I guess that the final AverMedia A706 patch would be easily merged once the
> tda8290 and tuner-core changess are done.
>
> Should I resend something?

I've just been a bit busier lately that I had foreseen, but no need to
resend anything - I have your patches.  You'll hear back from me
shortly.

-Mike
