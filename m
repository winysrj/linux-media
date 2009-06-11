Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54829 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZFKOkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 10:40:40 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
CC: =?iso-8859-1?Q?Jean-Philippe_Fran=E7ois?= <jp.francois@cynove.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 11 Jun 2009 09:40:11 -0500
Subject: RE: mt9t031 (was RE: [PATCH] adding support for setting bus
                parameters in sub device)
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A08FF7@dlee06.ent.ti.com>
References: <43899.62.70.2.252.1244716793.squirrel@webmail.xs4all.nl>
In-Reply-To: <43899.62.70.2.252.1244716793.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

In our experience, I have following cases where we need to set the device to capture/display at certain resolution and fps.

Capture side
-------------
1) IP Netcam applications. If the solution uses Micron sensors such as MT9T001/031/P031 etc, application will require to do streaming at various resolution ranging from VGA, SVGA to UXGA or 480p, 576p to 1080p. In these case what we have implemented is a table of timings looked up by the STD string. Though this is not a standard, it helps in achieving streaming at desired frame rate. The exposure used is to get the desired frame rate and video quality. The VPFE has modules to fine tune the image quality.

2) TVP7002 decoder chip has following table for various analog video standard that it supports.
	SDTV(YPbPr component) - 480i/576i
	EDTV (YPbPr component) - 480p/576p
	HDTV (YPbPr component) - 720p@50/60, 1080i@50/60, 1080p@50/60
	PC graphics (RGB Component) - VGA to UXGA

3) TVP5146/TVP5147 - supports NTSC/PAL standards from SDTV

4) camera applications that do preview and take snapshots. We don't support it in Linux, but have solutions based on other OS.

Display side
------------
1)VPBE (video processing back end) can support NTSC/PAL timing signals directly from the SOC.

2) By connecting a daughter card that does voltage translation, to the digital LCD port of VPBE, it can support PC graphics timings. Examples are logic PD LCD/ Avnet LCD kits that can be connected using these daughter card.

3) The Digital LCD port of VPBE can generate BT.656/BT.1120 timings. So you could connect a encoder chip such as THS8200 to generate 720P/1080 YPbPr component outputs. This can support any encoder chip that can accepts YUV data or RGB666 or RGB888 data along with timings signals and output PC graphic or YPbPr component output or standard NTSC/PAL outputs.

As you can see, S_STD can be used only for 3) on the capture side and 1) on the display side since it doesn't specify all the above timings and is not quite useful. So we need an API that can do the following...

Query available timings settings from the encoder/decoder/sensors. Since these timings are not relevant to application domain, it can be defined in either in the driver and only expose following as part of the query. Driver uses this to look up the correct timing. 

1) resolution (VGA, 720p, 1080p, 576p etc)
2) frame rate 

Set the timing by specifying
Detect the signal for capture similar to QUERYSTD??
Get the current timing...

Is VIDIOC_S_PARM & G_PARM added for this purpose. May be this might need to be enhanced for this purpose to add the resolution as well or add a new set of APIs...


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Hans Verkuil
>Sent: Thursday, June 11, 2009 6:40 AM
>To: Hans de Goede
>Cc: Jean-Philippe François; Karicheri, Muralidharan; davinci-linux-open-
>source@linux.davincidsp.com; Muralidharan Karicheri; Guennadi Liakhovetski;
>linux-media@vger.kernel.org
>Subject: Re: mt9t031 (was RE: [PATCH] adding support for setting bus
>parameters in sub device)
>
>
>>
>>
>> On 06/11/2009 11:33 AM, Hans Verkuil wrote:
>>>>
>>>> On 06/11/2009 10:35 AM, Hans Verkuil wrote:
>>
>> <snip (a lot)>
>>
>>>> Hmm,
>>>>
>>>> Why would we want the *application* to set things like this *at all* ?
>>>> with sensors hsync and vsync and other timing are something between
>>>> the bridge and the sensor, actaully in my experience the correct
>>>> hsync / vsync timings to program the sensor to are very much bridge
>>>> specific. So IMHO this should not be exposed to userspace at all.
>>>>
>>>> All userspace should be able to control is the resolution and the
>>>> framerate. Although controlling the framerate in many cases also
>>>> means controlling the maximum exposure time. So in many cases
>>>> one cannot even control the framerate. (Asking for 30 fps in an
>>>> artificially illuminated room will get you a very dark, useless
>>>> picture, with most sensors). Yes this means that with cams with
>>>> use autoexposure (which is something which we really want where ever
>>>> possible), the framerate can and will change while streaming.
>>>
>>> I think we have three possible use cases here:
>>>
>>> - old-style standard definition video: use S_STD
>>>
>>
>> Ack
>>
>>> - webcam-like devices: a combination of S_FMT and S_PARM I think?
>>> Correct
>>> me if I'm wrong. S_STD is useless for this, right?
>>>
>>
>> Ack
>>
>>> - video streaming devices like the davinci videoports where you can hook
>>> up HDTV receivers or FPGAs: here you definitely need a new API to setup
>>> the streaming parameters, and you want to be able to do that from the
>>> application as well. Actually, sensors are also hooked up to these
>>> devices
>>> in practice. And there you also want to be able to setup these
>>> parameters.
>>> You will see this mostly (only?) on embedded platforms.
>>>
>>
>> I agree we need an in kernel API for this, but why expose it to
>> userspace, as you say this will only happen on embedded systems,
>> shouldn't the info then go in a board_info file / struct ?
>
>These timings are not fixed. E.g. a 720p60 video stream has different
>timings compared to a 1080p60 stream. So you have to be able to switch
>from userspace. It's like PAL and NTSC, but then many times worse :-)
>
>Regards,
>
>         Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

