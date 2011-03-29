Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:63927 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1C2Jfi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 05:35:38 -0400
Message-ID: <4D91A7D7.5060909@maxwell.research.nokia.com>
Date: Tue, 29 Mar 2011 12:35:19 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <201103290849.48799.hverkuil@xs4all.nl>
In-Reply-To: <201103290849.48799.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Many thanks for the comments!

Hans Verkuil wrote:
> On Monday, March 28, 2011 14:55:40 Sakari Ailus wrote:
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

It occurred to me that an application might want to turn off a flash
which has been strobed on software. That can't be done on a single
button control.

V4L2_CID_FLASH_SHUTDOWN?

The application would know the flash strobe is ongoing before it
receives a timeout fault. I somehow feel that there should be a control
telling that directly.

What about using a bool control for the strobe?

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
> 
> I'm not sure about the naming. Perhaps call the first MODE_SW_STROBE?
> Or MODE_SW_TRIGGER and MODE_HW_TRIGGER? Or perhaps just MODE_SOFTWARE and
> MODE_EXTERNAL or MODE_HARDWARE.

MODE_SOFTWARE and MODE_EXTERNAL (or MODE_HARDWARE) are the best, I
think. Indeed there's no need to repeat strobe in the name of a strobe mode.

"External" is good since it directly indicates the strobe is external to
the flash controller.

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
> 
> It seems to me that this control should always be read-only. A setting like
> this is very much hardware specific and you don't want an attacker changing
> the timeout to the max value that might cause a LED catching fire.

I'm not sure about that.

The driver already must take care of protecting the hardware in my
opinion. Besides, at least one control is required to select the
duration for the flash if there's no hardware synchronisation.

What about this:

	V4L2_CID_FLASH_TIMEOUT

Hardware timeout, read-only. Programmed to the maximum value allowed by
the hardware for the external strobe, greater or equal to
V4L2_CID_FLASH_DURATION for software strobe.

	V4L2_CID_FLASH_DURATION

Software implemented timeout when V4L2_CID_FLASH_STROBE_MODE ==
V4L2_FLASH_STROBE_MODE_SOFTWARE.

I have to say I'm not entirely sure the duration control is required.
The timeout could be writable for software strobe in the case drivers do
not implement software timeout. The granularity isn't _that_ much
anyway. Also, a timeout fault should be produced whenever the duration
would expire.

Perhaps it would be best to just leave that out for now.

>>
>>
>> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
>>
>> enum v4l2_flash_led_mode {
>> 	V4L2_FLASH_LED_MODE_FLASH = 1,
>> 	V4L2_FLASH_LED_MODE_TORCH,
>> };
> 
> Would a LED_MODE_NONE make sense as well to turn off the flash completely?

It would essentially be the same as choosing software strobe and
disabling strobe. A separate mode for this still could be good to make
it explicit.

>>
>>
>> 	V4L2_CID_FLASH_INTENSITY (integer; LED)
>>
>> Intensity of the flash in hardware specific units. The LED flash
>> controller provides current to the LED but the actual luminous power is
>> dictated by the LED connected to the controller.
>>
>>
>> 	V4L2_CID_FLASH_TORCH_INTENSITY (integer; LED)
>>
>> Intensity of the flash in hardware specific units.
>>
>>
>> 	V4L2_CID_FLASH_INDICATOR_INTENSITY (integer; LED)
>>
>> Intensity of the indicator light in hardware specific units.
>>
>>
>> 	V4L2_CID_FLASH_FAULT (bit field; LED)
>>
>> This is a bitmask containing the fault information for the flash. This
>> assumes the proposed V4L2 bit mask controls [5]; otherwise this would
>> likely need to be a set of controls.
> 
> I intend to work on bitmask controls and control events tomorrow.

Nice! I look forward to see them! :-)

>>
>> #define V4L2_FLASH_FAULT_OVER_VOLTAGE		0x00000001
>> #define V4L2_FLASH_FAULT_TIMEOUT		0x00000002
>> #define V4L2_FLASH_FAULT_OVER_TEMPERATURE	0x00000004
>> #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		0x00000008
>>
>> Several faults may occur at single occasion. The ADP1653 is able to
>> inform the user a fault has occurred, so a V4L2 control event (proposed
>> earlier) could be used for that.

Btw. as this is an I2C device, there's an external interrupt pin which
tells this. Very likely the board code needs to tell this to the driver,
or the driver could depend on the GPIO framework while the configuration
would be in the board code.

>> These faults are supported by the ADP1653. More faults may be added as
>> support for more chips require that. In some other hardware faults are
>> available for indicator led as well.
>>
>> Question: should indicator faults be part of the same control, or a
>> different control, e.g. V4L2_CID_FLASH_INDICATOR_FAULT?
> 
> If they are independently reported, then I would say so, yes.

I believe it could be the same register, but this could be hardware
dependent.

Still, the faults essentially can be divided to separate LEDs. Perhaps
it'd be good to rethink this when someone writes a driver for such a
device. :-)

>>
>>
>> 	V4L2_CID_FLASH_CHARGE (bool; xenon)
>>
>> Charge control for the xenon flash. Enable or disable charging.
>>
>>
>> 	V4L2_CID_FLASH_READY (bool; xenon, LED)
>>
>> Flash is ready to strobe. On xenon flash this tells the capacitor has
>> been charged, on LED flash it's that the LED is no longer too hot.
>>
>> The implementation on LED flash may be modelling the temperature
>> behaviour of the LED in the driver (or elsewhere, e.g. library or board
>> code) if the hardware does not provide direct temperature information
>> from the LED.
>>
>> A V4L2 control event should be produced whenever the flash becomes ready.
> 
> Looks good!

Thanks! :-)

> 
> Regards,
> 
> 	Hans
> 
>>
>>
>> References
>> ==========
>>
>> [1] http://www.analog.com/static/imported-files/data_sheets/ADP1653.pdf
>>
>> [2] http://www.national.com/mpf/LM/LM3555.html#Overview
>>
>> [3]
>> http://www.austriamicrosystems.com/eng/Products/Lighting-Management/Camera-Flash-LED-Drivers/AS3645
>>
>> [4] http://maemo.org/downloads/product/Maemo5/flashlight-applet/
>>
>> [5]
>> http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%202%20(SGz6LU2esk).html
>>
>> [6]
>> http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%203%20(RhoYa0X9D7).html
>>
>>
>> Cheers,
>>
>>
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
