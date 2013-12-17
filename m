Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.epfl.ch ([128.178.224.219]:51881 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab3LQNLS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:11:18 -0500
Message-ID: <52B04D70.8060201@epfl.ch>
Date: Tue, 17 Dec 2013 14:11:12 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp device tree support
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>	<52A1A76A.6070301@epfl.ch> <CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>
In-Reply-To: <CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Enrico,

On 12/06/2013 11:54 AM, Enrico wrote:
> On Fri, Dec 6, 2013 at 11:31 AM, Florian Vaussard
> <florian.vaussard@epfl.ch> wrote:
>> Hello,
>>
>> On 12/06/2013 11:13 AM, Enrico wrote:
>>> Hi,
>>>
>>> i know there is some work going on for omap3isp device tree support,
>>> but right now is it possible to enable it in some other way in a DT
>>> kernel?
>>>
>>
>> The DT support is not yet ready, but an RFC binding has been proposed.
>> It won't be ready for 3.14.
>>
>>> I've tried enabling it in board-generic.c (omap3_init_camera(...) with
>>> proper platform data) but it hangs early at boot, do someone know if
>>> it's possible and how to do it?
>>>
>>
>> I did the same a few days ago, and went through several problems
>> (panics, half DT support,...). Now I am able to probe the ISP, I still
>> have one kernel panic to fix. Hope to send the patches in 1 or 2 days.
>> We are still in a transition period, but things should calm down in the
>> coming releases.
>>

So I converted the iommu to DT (patches just sent), used pdata quirks
for the isp / mtv9032 data, added a few patches from other people
(mainly clk to fix a crash when deferring the omap3isp probe), and a few
small hacks. I get a 3.13-rc3 (+ board-removal part from Tony Lindgren)
to boot on DT with a working MT9V032 camera. The missing part is the DT
binding for the omap3isp, but I guess that we will have to wait a bit
more for this.

If you want to test, I have a development tree here [1]. Any feedback is
welcome.

Cheers,

Florian

[1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt
