Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:55568 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3JUSkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 14:40:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_2KRF_VHkjCEV8d7YOaZo27QJ=TxGTsUOeWO5X_tp8Ozw@mail.gmail.com>
References: <201309101134.32883.hansverk@cisco.com> <3335821.8epFKWiJXY@avalon>
 <CAK5ve-JHEaNrNiYwdMdEiEsD0LnqHG-MEAQv4D-962fYK0=g4A@mail.gmail.com>
 <2523390.YEHU3IBNqR@avalon> <CAK5ve-+N=GyNk-ryR0LbiUcT0TErFTwK60-vHNEf7112dNyh_A@mail.gmail.com>
 <525DF0C7.9090407@ti.com> <CAK5ve-K481KMXZJW9Ah8N_NaOYNNgdxABvewqiTOhquUAzr-UA@mail.gmail.com>
 <525F2311.8000509@ti.com> <1381968755.1905.25.camel@palomino.walls.org>
 <CAK5ve-Jnbr2C-LPfS9KKNcv8KH-7gkZyp+tj4Qt9-pE=nch8gg@mail.gmail.com> <CAPybu_2KRF_VHkjCEV8d7YOaZo27QJ=TxGTsUOeWO5X_tp8Ozw@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 21 Oct 2013 11:40:19 -0700
Message-ID: <CAK5ve-+PiRDEriYrCpbWq5WTPTq=n-xYZM0D46mDRAZWZi2GWw@mail.gmail.com>
Subject: Re: [media-workshop] V2: Agenda for the Edinburgh mini-summit
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, Milo Kim <milo.kim@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Thierry Reding <thierry.reding@gmail.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-pwm@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 19, 2013 at 1:25 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Please find the multi selection api proposal attached.
>
> See you in Edinburgh.
>
>
> Thanks
>
> On Sat, Oct 19, 2013 at 2:17 AM, Bryan Wu <cooloney@gmail.com> wrote:
>> On Wed, Oct 16, 2013 at 5:12 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>>> On Thu, 2013-10-17 at 08:36 +0900, Milo Kim wrote:
>>>
>>>> > That's current solution, we plan to unify this two API since those
>>>> > chip are basically LED.
>>>> >
>>>> >> On the other hands, LM3642 has an indicator mode with flash/torch.
>>>> >> Then, it will consist of 3 parts - MFD core, LED(indicator) and
>>>> >> V4L2(flash/torch).
>>>> >>
>>>> >
>>>> > So if one LED device driver can support that, we don't need these 3 parts.
>>>>
>>>> Let me clarify our discussion briefly.
>>>>
>>>> For the flash and torch, there are scattered user-space APIs.
>>>> We need to unify them.
>>>
>>> Sorry for the late input.
>>>
>>> There are also subject matter illuminators (is that the same as torch?).
>>> They may be LED or halogen incadescent bulbs that are integral to a
>>> device such as the QX5 microscope:
>>>
>>> http://git.linuxtv.org/media_tree.git/blob/HEAD:/drivers/media/usb/cpia2/cpia2_v4l.c#l1152
>>>
>>> The V4L2 user controls ioctl()'s are used to control those two lamps
>>> currently.  Their activation seemed like a switch the user would want to
>>> turn easily, via a GUI that contained other V4L2 device controls.
>>>
>>> Do these fit in anywhere into the unification?  Not that I'm advocating
>>> that. I just thought cases like this shouldn't be overlooked in deciding
>>> what to do.
>>>
>>> Regards,
>>> Andy
>>>
>>>> We are considering supporting V4L2 structures in the LED camera trigger.
>>>> Then, camera application controls the flash/torch via not the LED sysfs
>>>> but the V4L2 ioctl interface.
>>>> So, changing point is the ledtrig-camera.c. No chip driver changes at all.
>>>>
>>>> Is it correct?
>>>>
>>>> Best regards,
>>>> Milo
>>>
>>>
>>
>> Please find my proposal attached and probably my colleague Paul
>> Walmsley will show up for this media mini summit if he is available.
>>
>> Thanks,
>> -Bryan
>
>

Is the time and location of media mini-summit fixed? My colleague
might show up if it's not conflicted with ARM mini-summit.

Thanks,
-Bryan
