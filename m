Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44012 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1HFD4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 23:56:05 -0400
Received: by iye16 with SMTP id 16so4843759iye.1
        for <linux-media@vger.kernel.org>; Fri, 05 Aug 2011 20:56:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E3B2EB3.6030501@iki.fi>
References: <4DF9BCAA.3030301@holzeisen.de>
	<4DF9EA62.2040008@killerhippy.de>
	<4DFA7748.6000704@hoogenraad.net>
	<4DFFC82B.10402@iki.fi>
	<1308649292.3635.2.camel@maxim-laptop>
	<4E006BDB.8060000@hoogenraad.net>
	<4E17CA94.8030307@iki.fi>
	<4E3B2EB3.6030501@iki.fi>
Date: Sat, 6 Aug 2011 04:56:04 +0100
Message-ID: <CAO-Op+FBtPm9fdB4bskq3Hv_GorLuUUb6VFx7W+2JBxoCGwnYg@mail.gmail.com>
Subject: Re: RTL2831U driver updates
From: Alistair Buxton <a.j.buxton@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?Q?Sascha_W=C3=BCstemann?= <sascha@killerhippy.de>,
	Thomas Holzeisen <thomas@holzeisen.de>, stybla@turnovfree.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

With the latest driver my card never gets a signal lock, not even
once. As before there are no error messages. It does always probe
correctly now though.

On 5 August 2011 00:43, Antti Palosaari <crope@iki.fi> wrote:
> Hello,
> I have done some updates. MXL5005S based RTL2831U devices didn't worked
> due to bug. That's main visible change. Secondly I added basic support
> for RTL2832U to rtl28xx driver. And implemented I2C as I see it really
> is, I think it is almost perfect now. It works fine my RTL2832U device
> with stubbed demod and tuner drivers.

-- 
Alistair Buxton
a.j.buxton@gmail.com
