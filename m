Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57666 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab2CZPh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 11:37:57 -0400
Received: by wejx9 with SMTP id x9so4286850wej.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 08:37:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F708A66.8090303@mlbassoc.com>
References: <CAGD8Z75ELkV6wJOfuCFU3Z2dS=z5WbV-7izazaG7SVtfPMcn=A@mail.gmail.com>
	<CAGD8Z77akUx2S=h_AU+UcJ6yWf1Y_Rk4+8N78nFe4wP9OHYE=g@mail.gmail.com>
	<4F708A66.8090303@mlbassoc.com>
Date: Mon, 26 Mar 2012 09:37:55 -0600
Message-ID: <CAGD8Z76vJSK9dCvSVWXW7FtUkN2MY5V2Dm9NJzHjrgjgS22Dxw@mail.gmail.com>
Subject: Re: Using MT9P031 digital sensor
From: Joshua Hintze <joshua.hintze@gmail.com>
To: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gary,

I'm using linux branch from 2.6.39

Fetch URL: git://www.sakoman.com/git/linux-omap-2.6
branch: omap-2.6.39

I'm using an overo board so I figured I should follow Steve Sakoman's
repository.

Which brings up another question, would you recommend going off of one
of Laurent's repo's and if so which one?


Thanks,

Josh



On Mon, Mar 26, 2012 at 9:25 AM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2012-03-25 23:13, Joshua Hintze wrote:
>>
>> Alright I made some progress on this.
>>
>> I can access the Mt9p031 registers that are exposed using a command such
>> as
>>
>> ./yavta -l /dev/v4l-subdev8 to list the available controls. Then I can
>> set the exposure and analog gain with
>> ./yavta --set-control '0x00980911 1500' /dev/v4l-subdev8<--- This
>> seems to give the desired effect.
>>
>> Note that ./yavta -w (short option for --set-control) gives a seg
>> fault for me. Possible bug in yavta??
>>
>> Now I'm working on fixing the white balance. In my office the
>> incandescent light bulbs give off a yellowish tint late at night. I've
>> been digging through the omap3isp code to figure out how to enable the
>> automatic white balance. I was able to find the private IOCTLs for the
>> previewer and I was able to use VIDIOC_OMAP3ISP_PRV_CFG. Using this
>> IOCTL I adjusted the OMAP3ISP_PREV_WB, OMAP3ISP_PREV_BLKADJ, and
>> OMAP3ISP_PREV_RGB2RGB.
>>
>> Since I wasn't sure where to start on adjusting these values I just
>> set them all to the TRM's default register values. However when I did
>> so a strange thing occurred. What I saw was all the colors went to a
>> decent color. I'm curious if anybody can shed some light on the best
>> way to get a high quality image. Ideally if I could just set a bit for
>> auto white balance and auto exposure that could be good too.
>
>
> Just curious - what codebase (git URL) are you using?
>
>> On Fri, Mar 23, 2012 at 1:01 PM, Joshua Hintze<joshua.hintze@gmail.com>
>>  wrote:
>>>
>>> Sorry to bring up this old message list. I was curious when you spoke
>>> about the ISP preview engine being able to adjust the white balance.
>>>
>>> When I enumerate the previewer's available controls all I see is...
>>>
>>> root@overo:~# ./yavta -l /dev/v4l-subdev3
>>> --- User Controls (class 0x00980001) ---
>>> control 0x00980900 `Brightness' min 0 max 255 step 1 default 0 current 0.
>>> control 0x00980901 `Contrast' min 0 max 255 step 1 default 16 current 16.
>>> 2 controls found.
>>>
>>>
>>> Is this what you are referring to? Are there other settings I can
>>> adjust to get the white balance and focus better using the  OMAP3 ISP
>>> AWEB/OMAP3 ISP AF?
>>>
>>> Thanks,
>>>
>>> Josh
>>>
>>>
>>>
>>>
>>> Hi Gary,
>>>
>>> On Wednesday 30 November 2011 18:00:55 Gary Thomas wrote:
>>>>
>>>> On 2011-11-30 07:57, Gary Thomas wrote:
>>>>>
>>>>> On 2011-11-30 07:30, Laurent Pinchart wrote:
>>>>>>
>>>>>> On Wednesday 30 November 2011 15:13:18 Gary Thomas wrote:
>>>
>>>
>>> [snip]
>>>
>>>>>>> This sort of works(*), but I'm still having issues (at least I can
>>>>>>> move
>>>>>>> frames!) When I configure the pipeline like this:
>>>>>>> media-ctl -r
>>>>>>> media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
>>>>>>> media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>>>>> media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
>>>>>>> media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
>>>>>>> media-ctl -f '"mt9p031 3-005d":0[SGRBG12 2592x1944]'
>>>>>>> media-ctl -f '"OMAP3 ISP CCDC":0 [SGRBG12 2592x1944]'
>>>>>>> media-ctl -f '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
>>>>>>> media-ctl -f '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
>>>>>>> media-ctl -f '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
>>>>>>> media-ctl -f '"OMAP3 ISP resizer":1 [YUYV 660x496]'
>>>>>>> the resulting frames are 666624 bytes each instead of 654720
>>>>>>>
>>>>>>> When I tried to grab from the previewer, the frames were 9969120
>>>>>>> instead of 9961380
>>>>>>>
>>>>>>> Any ideas what resolution is actually being moved through?
>>>>>>
>>>>>>
>>>>>> Because the OMAP3 ISP has alignment requirements. Both the preview
>>>>>> engine and the resizer output line lenghts must be multiple of 32
>>>>>> bytes. The driver adds padding at end of lines when the output width
>>>>>> isn't a multiple of 16 pixels.
>>>>>
>>>>>
>>>>> Any guess which resolution(s) I should change and to what?
>>>>
>>>>
>>>> I changed the resizer output to be 672x496 and was able to capture video
>>>> using ffmpeg.
>>>>
>>>> I don't know what to expect with this sensor (I've never seen it in use
>>>> before), but the image seems to have color balance issues - it's awash
>>>> in
>>>> a green hue.  It may be the poor lighting in my office...  I did try the
>>>> 9
>>>> test patterns which I was able to select via
>>>>    # v4l2-ctl -d /dev/v4l-subdev8 --set-ctrl=test_pattern=N
>>>> and these looked OK.  You can see them at
>>>> http://www.mlbassoc.com/misc/mt9p031_images/
>>>
>>>
>>> Neither the sensor nor the OMAP3 ISP implement automatic white balance.
>>> The
>>> ISP preview engine can be used to modify the white balance, and the
>>> statistics
>>> engine can be used to extract data useful to compute the white balance
>>> parameters, but linking the two needs to be performed in userspace.
>>>
>>>>>> So this means that your original problem comes from the BT656 patches.
>>>>>
>>>>>
>>>>> Yes, it does look that way. Now that I have something that moves data,
>>>>> I
>>>>> can compare how the ISP is setup between the two versions and come up
>>>>> with a fix.
>>>>
>>>>
>>>> This is next on my plate, but it may take a while to figure it out.
>>>>
>>>> Is there some recent tree which will have this digital (mt9p031) part
>>>> working that also has the BT656 support in it?  I'd like to try that
>>>> rather than spending time figuring out why an older tree isn't working.
>>>
>>>
>>> No, I haven't had time to create one, sorry. It shouldn't be difficult to
>>> rebase the BT656 patches on top of the latest OMAP3 ISP and MT9P031 code.
>>>
>>> --
>>> Regards,
>>>
>>> Laurent Pinchart
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majord...@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> ------------------------------------------------------------
> Gary Thomas                 |  Consulting for the
> MLB Associates              |    Embedded world
> ------------------------------------------------------------
