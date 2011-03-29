Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:62159 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1C2OjY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 10:39:24 -0400
Message-ID: <4D91EF7D.2020403@maxwell.research.nokia.com>
Date: Tue, 29 Mar 2011 17:41:01 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: riverful.kim@samsung.com
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <4D91B7EC.2020004@samsung.com>
In-Reply-To: <4D91B7EC.2020004@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Kim, HeungJun wrote:
> Hi Sakari,

Hi HeungJun,

Thanks for the comments!

> Here's my humble opinions about this RFC.
> Almost, this control may be also applied immediately in our case.
> But, I have some opinions about that.
> So, read comments plz and I wish this might be help to it.
> 
> 2011-03-28 오후 9:55, Sakari Ailus 쓴 글:
>> Hi,
>>
>> This is a proposal for an interface for controlling flash devices on the
>> V4L2/v4l2_subdev APIs. My plan is to use the interface in the ADP1653
>> driver, the flash controller used in the Nokia N900.
>>
>> Comments and questions are very, very welcome!
>>
>>
>> Scope
>> =====
>>
>> This RFC is focused mostly on the ADP1653 [1] and similar chips [2, 3]
>> which provides following functionality. [2, 3] mostly differ on the
>> available faults --- for example, there are faults also for the
>> indicator LED.
>>
>> - High power LED output (flash or torch modes)
>> - Low power indicator LED output (a.k.a. privacy light)
>> - Programmable flash timeout
>> - Software and hardware strobe
>> - Fault detection
>> 	- Overvoltage
>> 	- Overtemperature
>> 	- Short circuit
>> 	- Timeout
>> - Programmable current (both high-power and indicator LEDs)
>>
>> If anyone else is aware of hardware which significantly differs from
>> these and does not get served well under the proposed interface, please
>> tell about it.
>>
>> This RFC does NOT address the synchronisation of the flash to a given
>> frame since this task is typically performed by the sensor through a
>> strobe signal. The host does not have enough information for this ---
>> exact timing information on the exposure of the sensor pixel array. In
>> this case the flash synchronisation is visible to the flash controller
>> as the hardware strobe originating from the sensor.
>>
>> Flash synchronisation requires
>>
>> 1) flash control capability from the sensor including a strobe output,
>> 2) strobe input in the flash controller,
>> 3) (optionally) ability to program sensor parameters at given frame,
>> such as flash strobe, and
>> 4) ability to read back metadata produced by the sensor related to a
>> given frame. This should include whether the frame is exposed with
>> flash, i.e. the sensor's flash strobe output.
>>
>> Since we have little examples of both in terms of hardware support,
>> which is in practice required, it was decided to postpone the interface
>> specification for now. [6]
>>
>> Xenon flash controllers exist but I don't have a specific example of
>> those. Typically the interface is quite simple. Gpio pins for charge and
>> strobe. The length of the strobe signal determines the strength of the
>> flash pulse. The strobe is controlled by the sensor as for LED flash if
>> it is hardware based.
>>
>>
>> Known use cases
>> ===============
>>
>> The use case listed below concentrate on using a flash in a mobile
>> device, for example in a mobile phone. The use cases could be somewhat
>> different in devices the primary use of which is camera.
>>
>> Unsynchronised LED flash (software strobe)
>> ------------------------------------------
>>
>> Unsynchronised LED flash is controlled directly by the host as the
>> sensor. The flash must be enabled by the host before the exposure of the
>> image starts and disabled once it ends. The host is fully responsible
>> for the timing of the flash.
>>
>> Example of such device: Nokia N900.
>>
>>
>> Synchronised LED flash (hardware strobe)
>> ----------------------------------------
>>
>> The synchronised LED flash is pre-programmed by the host (power and
>> timeout) but controlled by the sensor through a strobe signal from the
>> sensor to the flash.
>>
>> The sensor controls the flash duration and timing. This control
>> typically must be programmed to the sensor, and specifying an interface
>> for this is out of scope of this RFC.
>>
>> The LED flash controllers we know of can function in both synchronised
>> and unsynchronised modes.
> This case used in Galaxy S and the other these days smartphone in Samsung.
> So, I checked possible APIs for our case, but it's not almost very different
> with software strobe. It's safe to say, software strobe may be enough detailed
> to express hardware strobe. So, software strobe APIs can cover the others.

In case the user wants to use hardware strobe which is also supported by
the driver, the controls related to software strobe are not used at all.
The driver might choose not to implement them if they are not supported.

> This is just samsung case, but any case is possible.
> Is there any other cases to be introduced, everybody?
> 
>>
>>
>> LED flash as torch
>> ------------------
>>
>> LED flash may be used as torch in conjunction with another use case
>> involving camera or individually. [4]
>>
>>
>> Synchronised xenon flash
>> ------------------------
>>
>> The synchronised xenon flash is controlled more closely by the sensor
>> than the LED flash. There is no separate intensity control for the xenon
>> flash as its intensity is determined by the length of the strobe pulse.
>> Several consecutive strobe pluses are possible but this needs to be
>> still controlled by the sensor.
>>
>>
>> Proposed interface
>> ==================
>>
>> The flash, either LED or xenon, does not require large amounts of data
>> to control it. There are parameters to control it but they are
>> independent and assumably some hardware would only support some subsets
>> of the functionality available somewhere else. Thus V4L2 controls seem
>> an ideal way to support flash controllers.
>>
>> A separate control class is reserved for the flash controls. It is
>> called V4L2_CTRL_CLASS_FLASH.
>>
>> Type of the control; type of flash is in parentheses after the control.
>>
>>
>> 	V4L2_CID_FLASH_STROBE (button; LED)
>>
>> Strobe the flash using software strobe from the host, typically over I2C
>> or a GPIO. The flash is NOT synchronised to sensor pixel are exposure
>> since the command is given asynchronously. Alternatively, if the flash
>> controller is a master in the system, the sensor exposure may be
>> triggered based on software strobe.
>>
>>
>> 	V4L2_CID_FLASH_STROBE_MODE (menu; LED)
>>
>> Use hardware or software strobe. If hardware strobe is selected, the
>> flash controller is a slave in the system where the sensor produces the
>> strobe signal to the flash.
>>
>> In this case the flash controller setup is limited to programming strobe
>> timeout and power (LED flash) and the sensor controls the timing and
>> length of the strobe.
>>
>> enum v4l2_flash_strobe_mode {
>> 	V4L2_FLASH_STROBE_MODE_SOFTWARE,
>> 	V4L2_FLASH_STROBE_MODE_EXT_STROBE,
>> };
>>
>>
>> 	V4L2_CID_FLASH_TIMEOUT (integer; LED)
>>
>> The flash controller provides timeout functionality to shut down the led
>> in case the host fails to do that. For hardware strobe, this is the
>> maximum amount of time the flash should stay on, and the purpose of the
>> setting is to prevent the LED from catching fire.
>>
>> For software strobe, the setting may be used to limit the length of the
>> strobe in case a driver does not implement it itself. The granularity of
>> the timeout in [1, 2, 3] is very coarse. However, the length of a
>> driver-implemented LED strobe shutoff is very dependent on host.
>> Possibly V4L2_CID_FLASH_DURATION should be added, and
>> V4L2_CID_FLASH_TIMEOUT would be read-only so that the user would be able
>> to obtain the actual hardware implemented safety timeout.
>>
>> Likely a standard unit such as ms or µs should be used.
>>
>>
>> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
>>
>> enum v4l2_flash_led_mode {
>> 	V4L2_FLASH_LED_MODE_FLASH = 1,
>> 	V4L2_FLASH_LED_MODE_TORCH,
>> };
> How about the name V4L2_FLAS_LED_MODE_DEDICATED than TORCH?
> 
> In the most case of the TORCH mode, the only led goes with powering up,
> not the whole sensor. It's the same case that the flash-led integrated
> in sensor module, and it will be turn on the only power pin of led.
>
> I think it's not different method to turn on/off, whatever the mode name is.
> But, the mode name DEDICATED is look more reasonable, because the reason 
> which is devided FLASH and TORCH in the mode, is why only power up the led,
> not sensor.

Sensor? Is the flash part of the sensor module for you?

I think it should be other factors than the flash mode that are used to
make the decision on whether to power on the sensor or not.

The factors based on which to power the subdevs probably will be
discussed in the future, and which entity is responsible for power
management. The power management code originally was part of the Media
controller framework but it was removed since it was not seen to be
generic enough.

Many subdev drivers (including the adp1653) basically get powered as
long as the subdev device node is open. Sensor can be powered based on
other factors as well, such as the streaming state and what are the
connections to the video nodes.

Flash in torch mode can also be used as video light.

Does this answer the questions you had?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
