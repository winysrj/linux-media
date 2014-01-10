Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.aswsp.com ([193.34.35.150]:15466 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaAJJEU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 04:04:20 -0500
Message-ID: <52CFB739.5070305@parrot.com>
Date: Fri, 10 Jan 2014 10:02:49 +0100
From: Julien BERAUD <julien.beraud@parrot.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: <florian.vaussard@epfl.ch>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: omap3isp device tree support
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>	<52A1A76A.6070301@epfl.ch>	<CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>	<52B04D70.8060201@epfl.ch>	<CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com>	<CA+2YH7sHg-D9hrTOZ5h03YcAaywZz5tme5omguxPtHdyCb5A4A@mail.gmail.com>	<52CA8137.8080307@parrot.com>	<CA+2YH7u+1zOdcUDVDf1+VG2rgDdSa7HM-mxsxkzTj_iE3RtvMg@mail.gmail.com>	<52CD3CA6.3080704@parrot.com> <CA+2YH7tYUi7RyGOObVP=p4aC84P7p5B3nNwoHCjhCNEgAebc1w@mail.gmail.com>
In-Reply-To: <CA+2YH7tYUi7RyGOObVP=p4aC84P7p5B3nNwoHCjhCNEgAebc1w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 09/01/2014 19:14, Enrico a écrit :
> On Wed, Jan 8, 2014 at 12:55 PM, Julien BERAUD <julien.beraud@parrot.com> wrote:
>> Le 07/01/2014 11:12, Enrico a écrit :
>>
>>> On Mon, Jan 6, 2014 at 11:11 AM, Julien BERAUD <julien.beraud@parrot.com>
>>> wrote:
>>>> Le 03/01/2014 12:30, Enrico a écrit :
>>>>> On Wed, Dec 18, 2013 at 11:09 AM, Enrico <ebutera@users.berlios.de>
>>>>> wrote:
>>>>>> On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard
>>>>>> <florian.vaussard@epfl.ch> wrote:
>>>>>>> So I converted the iommu to DT (patches just sent), used pdata quirks
>>>>>>> for the isp / mtv9032 data, added a few patches from other people
>>>>>>> (mainly clk to fix a crash when deferring the omap3isp probe), and a
>>>>>>> few
>>>>>>> small hacks. I get a 3.13-rc3 (+ board-removal part from Tony
>>>>>>> Lindgren)
>>>>>>> to boot on DT with a working MT9V032 camera. The missing part is the
>>>>>>> DT
>>>>>>> binding for the omap3isp, but I guess that we will have to wait a bit
>>>>>>> more for this.
>>>>>>>
>>>>>>> If you want to test, I have a development tree here [1]. Any feedback
>>>>>>> is
>>>>>>> welcome.
>>>>>>>
>>>>>>> Cheers,
>>>>>>>
>>>>>>> Florian
>>>>>>>
>>>>>>> [1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt
>>>>>> Thanks Florian,
>>>>>>
>>>>>> i will report what i get with my setup.
>>>>> And here i am.
>>>>>
>>>>> I can confirm it works, video source is tvp5150 (with platform data in
>>>>> pdata-quirks.c) in bt656 mode.
>>>>>
>>>>> Laurent, i used the two bt656 patches from your omap3isp/bt656 tree so
>>>>> if you want to push it you can add a Tested-by me.
>>>>>
>>>>> There is only one problem, but it's unrelated to your DT work.
>>>>>
>>>>> It's an old problem (see for example [1] and [2]), seen by other
>>>>> people too and it seems it's still there.
>>>>> Basically if i capture with yavta while the system is idle then it
>>>>> just waits without getting any frame.
>>>>> If i add some cpu load (usually i do a "cat /dev/zero" in a ssh
>>>>> terminal) it starts capturing correctly.
>>>>>
>>>>> The strange thing is that i do get isp interrupts in the idle case, so
>>>>> i don't know why they don't "propagate" to yavta.
>>>>>
>>>>> Any hints on how to debug this?
>>>>>
>>>>> Enrico
>>>>>
>>>>> [1]: https://linuxtv.org/patch/7836/
>>>>> [2]:
>>>>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg44923.html
>>>> I have had what looked a lot like these problems before and it was due to
>>>> a
>>>> wrong configuration of the ccdc cropping regarding to the blanking. Could
>>>> you send me the configuration of the pipeline that you apply with
>>>> media-ctl,
>>>> just in case this is the same problem.
>>> i'm using:
>>>
>>> media-ctl -r -l '"tvp5150 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
>>> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>>> media-ctl --set-format '"tvp5150 2-005c":0 [UYVY 720x625]'
>>>
>>> And then capture with yavta -s 720x625 (or 720x576, can't remember right
>>> now).
>>>
>>> Thanks,
>>>
>>> Enrico
>> I don't think this is sufficient, though I am no expert about omap3 isp, you
>> should configure the format of the ccdc input and of the ccdc output too.
>> When I had this problem, it was solved by adding cropping at the input of
>> the CCDC, corresponding to the blanking period, which was :
>> - media-ctl -v -f '"OMAP3 ISP CCDC":0 [UYVY2X8 720x576 (0,49/720x576)]'
>> or
>> - media-ctl -v -f '"OMAP3 ISP CCDC":0 [UYVY2X8 720x480 (0,45/720x480)]'
>> respectively.
>>
>> I don't know if this can be of any help.
>>
>> Regards,
>> Julien BERAUD
> It seems i can't set cropping at the CCDC input (sink), but i can on
> output (source):
>
> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev2
>          pad0: Sink
>                  [fmt:UYVY2X8/720x625]
>                  <- "OMAP3 ISP CCP2":1 []
>                  <- "OMAP3 ISP CSI2a":1 []
>                  <- "tvp5150 1-005c":0 [ENABLED]
>          pad1: Source
>                  [fmt:UYVY2X8/720x576
>                   crop.bounds:(0,0)/720x624
>                   crop:(0,48)/720x576]
>                  -> "OMAP3 ISP CCDC output":0 [ENABLED]
>                  -> "OMAP3 ISP resizer":0 []
>          pad2: Source
>                  [fmt:unknown/720x624]
>                  -> "OMAP3 ISP preview":0 []
>                  -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
>                  -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
>                  -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]
>
> The strange thing is that with these settings the situation is even
> worse, i don't get any frames in yavta (while i see interrupts on
> omap3isp) even with the "cat /dev/zero" trick.
>
> So you are right, playing with cropping can make it work or not, are
> you sure you could set cropping at the ccdc input?
>
> Enrico
Enrico,

Sorry it didn't work. I just wanted to give a hint of what could be 
going wrong. I am sorry I don't have time to investigate, I am sure I 
could set the cropping at the input of ccdc, and that the result was to 
write register ISPCCDC_VERT_START in order to skip the vertical blanking 
period correctly. The branch I was on was a bit different though. If you 
want to investigate this issue, you will at least need to see what is 
written in the registers of the ISP.

Regards,
Julien
