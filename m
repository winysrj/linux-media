Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:48920 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752261AbdGEM4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 08:56:08 -0400
Subject: Re: Trying to use IR driver for my SoC
To: Sean Young <sean@mess.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
References: <cf82988e-8be2-1ec8-b343-7c3c54110746@free.fr>
 <20170629155557.GA12980@gofer.mess.org>
 <276e7aa2-0c98-5556-622a-65aab4b9d373@free.fr>
 <20170629175037.GA14390@gofer.mess.org>
From: Mason <slash.tmp@free.fr>
Message-ID: <6b1405be-7980-bc19-71b7-8186180c58a9@free.fr>
Date: Wed, 5 Jul 2017 14:55:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170629175037.GA14390@gofer.mess.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/06/2017 19:50, Sean Young wrote:

> The only thing that stands out is RC5_TIME_BASE. If that is the bit
> length or shortest pulse/space? In the latter case it should be 888 usec.

IR_RC5_DECODER_CLK_DIV
Length of 1 bit of the RC5 code in units of 27 MHz clks

Default value = 0xbb86  => 1.778 ms

#define RC5_TIME_BASE	1778
(time in microseconds apparently)

clkdiv = clkrate * RC5_TIME_BASE / 1e6 = 48006 = 0xbb86

I don't really see the point of reprogramming the
default value, though...

I'm thinking GPIO directions might be misconfigured, which
could explain why no IRQs are firing. Back to basics.

Regards.
