Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46620 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2F1Kso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 06:48:44 -0400
Received: by wibhm11 with SMTP id hm11so6323850wib.1
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 03:48:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+MoWDpSF8EHbpMdXS=1JbqhMqDn9Z59CNrzDJ8CYgK0VjR3Xg@mail.gmail.com>
References: <E1Sjr0W-0006Pc-Bz@www.linuxtv.org>
	<CAHFNz9JdJYmpYyvwDwzdJ4Arw5PR9vpJDBnc-oh-CdO5fANMVg@mail.gmail.com>
	<CA+MoWDpSF8EHbpMdXS=1JbqhMqDn9Z59CNrzDJ8CYgK0VjR3Xg@mail.gmail.com>
Date: Thu, 28 Jun 2012 16:18:43 +0530
Message-ID: <CAHFNz9JFqhVA+K_u53g8JKVHKmiEDzc8=11iApzAWw2-VNyQVQ@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.6] [media] stv090x: variable 'no_signal' set
 but not used
From: Manu Abraham <abraham.manu@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linuxtv-commits@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Jun 27, 2012 at 8:57 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
>
> Manu,
>
> On Wed, Jun 27, 2012 at 9:59 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> > Wonderful, instead of ignoring the return value, you ignored the whole
> > function
> > itself. Most of the demodulator registers are R-M-x registers. The patch
> > brings
> > in unwanted side-effects of R-M-x.
>
> Sorry for that. I'll send V2 of this patch just ignoring the return
> value. Can you please send me some reference about R-M-x registers?
>


Unfortunately public versions of the document do not exist. But, basically the
demodulator is a device that has microcontrollers, memory banks FPGA/DSP
on it.  Specifically, this demodulator is a bit complex device in all
aspects. The
registers what you see externally have different operating modes associated
with it, such as Read-Only, Write-Only, Read-Modify-Write and some others
where they shouldn't be accessed during certain operations and some others
should be updated, such as simple read to update the interface registers, or
in some cases a write of the same value to trigger some states. Even more
complex are the updates which are triggered based on bit-order-significance.
To summarize, the interface registers are shadowed by the on-chip
microcontroller to implement a Wait Free Synchronization method.

I was able to find a related description elsewhere on the Internet.

http://www.patentstorm.us/patents/4342079.html

Hope it helps,

Regards,
Manu
