Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:32161 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1C2Kn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 06:43:57 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIT00K19F53E990@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Mar 2011 19:43:51 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIT00CULF53DK@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Mar 2011 19:43:51 +0900 (KST)
Date: Tue, 29 Mar 2011 19:43:56 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [RFC] V4L2 API for flash devices
In-reply-to: <4D90854C.2000802@maxwell.research.nokia.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D91B7EC.2020004@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D90854C.2000802@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

Here's my humble opinions about this RFC.
Almost, this control may be also applied immediately in our case.
But, I have some opinions about that.
So, read comments plz and I wish this might be help to it.

2011-03-28 오후 9:55, Sakari Ailus 쓴 글:
> Hi,
> 
> This is a proposal for an interface for controlling flash devices on the
> V4L2/v4l2_subdev APIs. My plan is to use the interface in the ADP1653
> driver, the flash controller used in the Nokia N900.
> 
> Comments and questions are very, very welcome!
> 
> 
> Scope
> =====
> 
> This RFC is focused mostly on the ADP1653 [1] and similar chips [2, 3]
> which provides following functionality. [2, 3] mostly differ on the
> available faults --- for example, there are faults also for the
> indicator LED.
> 
> - High power LED output (flash or torch modes)
> - Low power indicator LED output (a.k.a. privacy light)
> - Programmable flash timeout
> - Software and hardware strobe
> - Fault detection
> 	- Overvoltage
> 	- Overtemperature
> 	- Short circuit
> 	- Timeout
> - Programmable current (both high-power and indicator LEDs)
> 
> If anyone else is aware of hardware which significantly differs from
> these and does not get served well under the proposed interface, please
> tell about it.
> 
> This RFC does NOT address the synchronisation of the flash to a given
> frame since this task is typically performed by the sensor through a
> strobe signal. The host does not have enough information for this ---
> exact timing information on the exposure of the sensor pixel array. In
> this case the flash synchronisation is visible to the flash controller
> as the hardware strobe originating from the sensor.
> 
> Flash synchronisation requires
> 
> 1) flash control capability from the sensor including a strobe output,
> 2) strobe input in the flash controller,
> 3) (optionally) ability to program sensor parameters at given frame,
> such as flash strobe, and
> 4) ability to read back metadata produced by the sensor related to a
> given frame. This should include whether the frame is exposed with
> flash, i.e. the sensor's flash strobe output.
> 
> Since we have little examples of both in terms of hardware support,
> which is in practice required, it was decided to postpone the interface
> specification for now. [6]
> 
> Xenon flash controllers exist but I don't have a specific example of
> those. Typically the interface is quite simple. Gpio pins for charge and
> strobe. The length of the strobe signal determines the strength of the
> flash pulse. The strobe is controlled by the sensor as for LED flash if
> it is hardware based.
> 
> 
> Known use cases
> ===============
> 
> The use case listed below concentrate on using a flash in a mobile
> device, for example in a mobile phone. The use cases could be somewhat
> different in devices the primary use of which is camera.
> 
> Unsynchronised LED flash (software strobe)
> ------------------------------------------
> 
> Unsynchronised LED flash is controlled directly by the host as the
> sensor. The flash must be enabled by the host before the exposure of the
> image starts and disabled once it ends. The host is fully responsible
> for the timing of the flash.
> 
> Example of such device: Nokia N900.
> 
> 
> Synchronised LED flash (hardware strobe)
> ----------------------------------------
> 
> The synchronised LED flash is pre-programmed by the host (power and
> timeout) but controlled by the sensor through a strobe signal from the
> sensor to the flash.
> 
> The sensor controls the flash duration and timing. This control
> typically must be programmed to the sensor, and specifying an interface
> for this is out of scope of this RFC.
> 
> The LED flash controllers we know of can function in both synchronised
> and unsynchronised modes.
This case used in Galaxy S and the other these days smartphone in Samsung.
So, I checked possible APIs for our case, but it's not almost very different
with software strobe. It's safe to say, software strobe may be enough detailed
to express hardware strobe. So, software strobe APIs can cover the others.

This is just samsung case, but any case is possible.
Is there any other cases to be introduced, everybody?

> 
> 
> LED flash as torch
> ------------------
> 
> LED flash may be used as torch in conjunction with another use case
> involving camera or individually. [4]
> 
> 
> Synchronised xenon flash
> ------------------------
> 
> The synchronised xenon flash is controlled more closely by the sensor
> than the LED flash. There is no separate intensity control for the xenon
> flash as its intensity is determined by the length of the strobe pulse.
> Several consecutive strobe pluses are possible but this needs to be
> still controlled by the sensor.
> 
> 
> Proposed interface
> ==================
> 
> The flash, either LED or xenon, does not require large amounts of data
> to control it. There are parameters to control it but they are
> independent and assumably some hardware would only support some subsets
> of the functionality available somewhere else. Thus V4L2 controls seem
> an ideal way to support flash controllers.
> 
> A separate control class is reserved for the flash controls. It is
> called V4L2_CTRL_CLASS_FLASH.
> 
> Type of the control; type of flash is in parentheses after the control.
> 
> 
> 	V4L2_CID_FLASH_STROBE (button; LED)
> 
> Strobe the flash using software strobe from the host, typically over I2C
> or a GPIO. The flash is NOT synchronised to sensor pixel are exposure
> since the command is given asynchronously. Alternatively, if the flash
> controller is a master in the system, the sensor exposure may be
> triggered based on software strobe.
> 
> 
> 	V4L2_CID_FLASH_STROBE_MODE (menu; LED)
> 
> Use hardware or software strobe. If hardware strobe is selected, the
> flash controller is a slave in the system where the sensor produces the
> strobe signal to the flash.
> 
> In this case the flash controller setup is limited to programming strobe
> timeout and power (LED flash) and the sensor controls the timing and
> length of the strobe.
> 
> enum v4l2_flash_strobe_mode {
> 	V4L2_FLASH_STROBE_MODE_SOFTWARE,
> 	V4L2_FLASH_STROBE_MODE_EXT_STROBE,
> };
> 
> 
> 	V4L2_CID_FLASH_TIMEOUT (integer; LED)
> 
> The flash controller provides timeout functionality to shut down the led
> in case the host fails to do that. For hardware strobe, this is the
> maximum amount of time the flash should stay on, and the purpose of the
> setting is to prevent the LED from catching fire.
> 
> For software strobe, the setting may be used to limit the length of the
> strobe in case a driver does not implement it itself. The granularity of
> the timeout in [1, 2, 3] is very coarse. However, the length of a
> driver-implemented LED strobe shutoff is very dependent on host.
> Possibly V4L2_CID_FLASH_DURATION should be added, and
> V4L2_CID_FLASH_TIMEOUT would be read-only so that the user would be able
> to obtain the actual hardware implemented safety timeout.
> 
> Likely a standard unit such as ms or µs should be used.
> 
> 
> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
> 
> enum v4l2_flash_led_mode {
> 	V4L2_FLASH_LED_MODE_FLASH = 1,
> 	V4L2_FLASH_LED_MODE_TORCH,
> };
How about the name V4L2_FLAS_LED_MODE_DEDICATED than TORCH?

In the most case of the TORCH mode, the only led goes with powering up,
not the whole sensor. It's the same case that the flash-led integrated
in sensor module, and it will be turn on the only power pin of led.

I think it's not different method to turn on/off, whatever the mode name is.
But, the mode name DEDICATED is look more reasonable, because the reason 
which is devided FLASH and TORCH in the mode, is why only power up the led,
not sensor.

So, how about that?

Regards,
Heungjun Kim

> 
> 
> 	V4L2_CID_FLASH_INTENSITY (integer; LED)
> 
> Intensity of the flash in hardware specific units. The LED flash
> controller provides current to the LED but the actual luminous power is
> dictated by the LED connected to the controller.
> 
> 
> 	V4L2_CID_FLASH_TORCH_INTENSITY (integer; LED)
> 
> Intensity of the flash in hardware specific units.
> 
> 
> 	V4L2_CID_FLASH_INDICATOR_INTENSITY (integer; LED)
> 
> Intensity of the indicator light in hardware specific units.
> 
> 
> 	V4L2_CID_FLASH_FAULT (bit field; LED)
> 
> This is a bitmask containing the fault information for the flash. This
> assumes the proposed V4L2 bit mask controls [5]; otherwise this would
> likely need to be a set of controls.
> 
> #define V4L2_FLASH_FAULT_OVER_VOLTAGE		0x00000001
> #define V4L2_FLASH_FAULT_TIMEOUT		0x00000002
> #define V4L2_FLASH_FAULT_OVER_TEMPERATURE	0x00000004
> #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		0x00000008
> 
> Several faults may occur at single occasion. The ADP1653 is able to
> inform the user a fault has occurred, so a V4L2 control event (proposed
> earlier) could be used for that.
> 
> These faults are supported by the ADP1653. More faults may be added as
> support for more chips require that. In some other hardware faults are
> available for indicator led as well.
> 
> Question: should indicator faults be part of the same control, or a
> different control, e.g. V4L2_CID_FLASH_INDICATOR_FAULT?
> 
> 
> 	V4L2_CID_FLASH_CHARGE (bool; xenon)
> 
> Charge control for the xenon flash. Enable or disable charging.
> 
> 
> 	V4L2_CID_FLASH_READY (bool; xenon, LED)
> 
> Flash is ready to strobe. On xenon flash this tells the capacitor has
> been charged, on LED flash it's that the LED is no longer too hot.
> 
> The implementation on LED flash may be modelling the temperature
> behaviour of the LED in the driver (or elsewhere, e.g. library or board
> code) if the hardware does not provide direct temperature information
> from the LED.
> 
> A V4L2 control event should be produced whenever the flash becomes ready.
> 
> 
> References
> ==========
> 
> [1] http://www.analog.com/static/imported-files/data_sheets/ADP1653.pdf
> 
> [2] http://www.national.com/mpf/LM/LM3555.html#Overview
> 
> [3]
> http://www.austriamicrosystems.com/eng/Products/Lighting-Management/Camera-Flash-LED-Drivers/AS3645
> 
> [4] http://maemo.org/downloads/product/Maemo5/flashlight-applet/
> 
> [5]
> http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%202%20(SGz6LU2esk).html
> 
> [6]
> http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%203%20(RhoYa0X9D7).html
> 
> 
> Cheers,
> 

