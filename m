Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:58740 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab1JXJrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 05:47:06 -0400
Message-ID: <4EA53416.9080501@mlbassoc.com>
Date: Mon, 24 Oct 2011 03:47:02 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Boris Todorov <boris.st.todorov@gmail.com>
CC: Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: omap3isp: BT.656 support
References: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com> <4E9EFA47.4010409@cit-ec.uni-bielefeld.de> <CAFYgh7xxCM0=hiU9+bFS+qA447wC4+OkCRxv1eonYMgTH7oeEw@mail.gmail.com> <4E9FE3F4.2040109@cit-ec.uni-bielefeld.de> <CAFYgh7xhHTz9z8kqnmxRO2hBi_L-bnV-zpJESM4iBcZcftR5Eg@mail.gmail.com> <4EA031FD.7020109@cit-ec.uni-bielefeld.de> <CAFYgh7xsdTMUDKuFwqeH84WVpz+AUVbrz=G+TxO4BvXfm6iU_w@mail.gmail.com>
In-Reply-To: <CAFYgh7xsdTMUDKuFwqeH84WVpz+AUVbrz=G+TxO4BvXfm6iU_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-23 13:15, Boris Todorov wrote:
> On Thu, Oct 20, 2011 at 5:36 PM, Stefan Herbrechtsmeier
> <sherbrec@cit-ec.uni-bielefeld.de>  wrote:
>> Am 20.10.2011 14:14, schrieb Boris Todorov:
>>> On Thu, Oct 20, 2011 at 12:03 PM, Stefan Herbrechtsmeier
>>> <sherbrec@cit-ec.uni-bielefeld.de>  wrote:
>>>> Am 20.10.2011 08:56, schrieb Boris Todorov:
>>>>> On Wed, Oct 19, 2011 at 7:26 PM, Stefan Herbrechtsmeier
>>>>> <sherbrec@cit-ec.uni-bielefeld.de>  wrote:
>>>>>> Am 18.10.2011 15:33, schrieb Boris Todorov:
>>>>>>> Hi
>>>>>>>
>>>>>>> I'm trying to run OMAP + TVP5151 in BT656 mode.
>>>>>>>
>>>>>>> I'm using omap3isp-omap3isp-yuv (git.linuxtv.org/pinchartl/media.git).
>>>>>>> Plus the following patches:
>>>>>>>
>>>>>>> TVP5151:
>>>>>>> https://github.com/ebutera/meta-igep/tree/testing-v2/recipes-kernel/linux/linux-3.0+3.1rc/tvp5150
>>>>>>>
>>>>>>> The latest RFC patches for BT656 support:
>>>>>>>
>>>>>>> Enrico Butera (2):
>>>>>>>    omap3isp: ispvideo: export isp_video_mbus_to_pix
>>>>>>>    omap3isp: ispccdc: configure CCDC registers and add BT656 support
>>>>>>>
>>>>>>> Javier Martinez Canillas (1):
>>>>>>>    omap3isp: ccdc: Add interlaced field mode to platform data
>>>>>>>
>>>>>>>
>>>>>>> I'm able to configure with media-ctl:
>>>>>>>
>>>>>>> media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
>>>>>>> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>>>>>>> media-ctl -v --set-format '"tvp5150 3-005c":0 [UYVY2X8 720x525]'
>>>>>>> media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x525]'
>>>>>>> media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x525]'
>>>>>>>
>>>>>>> But
>>>>>>> ./yavta -f UYVY -s 720x525 -n 4 --capture=4 -F /dev/video4
>>>>>>>
>>>>>>> sleeps after
>>>>>>> ...
>>>>>>> Buffer 1 mapped at address 0x4021d000.
>>>>>>> length: 756000 offset: 1515520
>>>>>>> Buffer 2 mapped at address 0x402d6000.
>>>>>>> length: 756000 offset: 2273280
>>>>>>> Buffer 3 mapped at address 0x4038f000.
>>>>>>>
>>>>>>> Anyone with the same issue??? This happens with every other v4l test app I used.
>>>>>> I had the same issue.
>>>>>>
>>>>>> Make sure that you disable the xclk when you remove your sensor driver.
>>>>>>
>>>>>> isp->platform_cb.set_xclk(isp, 0, ISP_XCLK_A)
>>>>> How exactly did you solved your problem? I don't see how XCLK in
>>>>> _remove will help. Pls explain.
>>>> Sorry, I mean deactive / power off your sensor.
>>>>> Btw I'm feeding TVP with external clock (not from xtal pins) -
>>>>> omap.cam_xclk ->  tvp.clk_in
>>>> I mean the cam_xclk.
>>>>> And I'm using kind of hack to get it:
>>>>> isp_probe()
>>>>> + isp_set_xclk(isp, 27000000, 1);
>>>> This is your problem.
>>>>
>>>> You should control the clock via board / platform callback from your driver.
>>>> Example:
>>>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg56627.html
>>>>
>>>> It is important that you set the clock to zero when your driver is not
>>>> in use.
>>>>
>>>> The problem is connected to the use count of the ISP and some
>>>> initialisation which only happen when the counter change between zero
>>>> and one.
>>>>
>>> tvp_probe() needs clock for i2c detected/config. tvp5150_s_power call
>>> happens when video starts streaming and if tvp is not configured ->
>>> kernel panic.
>> I use an other sensor and driver and this config the sensor during start
>> stream.
>>> And what about the case when TVP is used with OSC on XTAL pins and
>>> CLK_IN is not used at all?
>> Then your system will work, as you never call isp_set_xclk.
>>
>> The problem is not the clock, but how the isp driver works.
>> It expects, that the sensor driver disable the cam_xclk, if the sensor
>> is not used.
>>> Maybe I don't fully understand what is happening...
>>> or isp_set_xclk() use is messing up with ISP
>> On my system I have the same issues as you if I don't set the cam_xclk
>> to zero
>> during stop streaming.
>>
>> I haven't investigate in the real cause for the issue. I only released,
>> that this
>> issue stick together with an always enabled cam_xclk.
>>
>> Regards,
>>     Stefan
>
> Thanks Stefan. Now I have IRQs and I'm able to get some image from TVP.

How did you end up fixing this?  I ask only to enlighten the list, not to embarrass
you, as others and I have had no troubles making this go from the start.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
