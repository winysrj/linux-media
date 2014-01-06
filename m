Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.aswsp.com ([193.34.35.150]:32494 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaAFKRc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jan 2014 05:17:32 -0500
Message-ID: <52CA8137.8080307@parrot.com>
Date: Mon, 6 Jan 2014 11:11:03 +0100
From: Julien BERAUD <julien.beraud@parrot.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>, <florian.vaussard@epfl.ch>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Subject: Re: omap3isp device tree support
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>	<52A1A76A.6070301@epfl.ch>	<CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>	<52B04D70.8060201@epfl.ch>	<CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com> <CA+2YH7sHg-D9hrTOZ5h03YcAaywZz5tme5omguxPtHdyCb5A4A@mail.gmail.com>
In-Reply-To: <CA+2YH7sHg-D9hrTOZ5h03YcAaywZz5tme5omguxPtHdyCb5A4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 03/01/2014 12:30, Enrico a écrit :
> On Wed, Dec 18, 2013 at 11:09 AM, Enrico <ebutera@users.berlios.de> wrote:
>> On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard
>> <florian.vaussard@epfl.ch> wrote:
>>> So I converted the iommu to DT (patches just sent), used pdata quirks
>>> for the isp / mtv9032 data, added a few patches from other people
>>> (mainly clk to fix a crash when deferring the omap3isp probe), and a few
>>> small hacks. I get a 3.13-rc3 (+ board-removal part from Tony Lindgren)
>>> to boot on DT with a working MT9V032 camera. The missing part is the DT
>>> binding for the omap3isp, but I guess that we will have to wait a bit
>>> more for this.
>>>
>>> If you want to test, I have a development tree here [1]. Any feedback is
>>> welcome.
>>>
>>> Cheers,
>>>
>>> Florian
>>>
>>> [1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt
>> Thanks Florian,
>>
>> i will report what i get with my setup.
> And here i am.
>
> I can confirm it works, video source is tvp5150 (with platform data in
> pdata-quirks.c) in bt656 mode.
>
> Laurent, i used the two bt656 patches from your omap3isp/bt656 tree so
> if you want to push it you can add a Tested-by me.
>
> There is only one problem, but it's unrelated to your DT work.
>
> It's an old problem (see for example [1] and [2]), seen by other
> people too and it seems it's still there.
> Basically if i capture with yavta while the system is idle then it
> just waits without getting any frame.
> If i add some cpu load (usually i do a "cat /dev/zero" in a ssh
> terminal) it starts capturing correctly.
>
> The strange thing is that i do get isp interrupts in the idle case, so
> i don't know why they don't "propagate" to yavta.
>
> Any hints on how to debug this?
>
> Enrico
>
> [1]: https://linuxtv.org/patch/7836/
> [2]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg44923.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
I have had what looked a lot like these problems before and it was due 
to a wrong configuration of the ccdc cropping regarding to the blanking. 
Could you send me the configuration of the pipeline that you apply with 
media-ctl, just in case this is the same problem.

Regards,
Julien BERAUD
