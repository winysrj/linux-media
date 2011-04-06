Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:17936 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1DFILQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2011 04:11:16 -0400
Message-ID: <4D9C2000.9090500@maxwell.research.nokia.com>
Date: Wed, 06 Apr 2011 11:10:40 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Kim HeungJun <riverful@gmail.com>
Subject: [RFC v2] V4L2 API for flash devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This is a second proposal for an interface for controlling flash devices
on the V4L2/v4l2_subdev APIs. My plan is to use the interface in the
ADP1653 driver, the flash controller used in the Nokia N900.

Thanks to everyone who commented the previous version of this RFC! I
hope I managed to factor in everyone's comments. Please bug me if you
think I missed something. :-)

Comments and questions are very, very welcome as always.

Changes since v1 [7]
====================

- V4L2_FLASH_STROBE_MODE_EXT_STROBE renamed to
V4L2_FLASH_STROBE_MODE_EXTERNAL.

- V4L2_CID_FLASH_STROBE control changed from button to bool.

- Removed suggestion of adding V4L2_CID_FLASH_DURATION.
V4L2_CID_FLASH_TIMEOUT is used as hardware timeout.

- Added control access info (ro/rw).

- V4L2_FLASH_MODE_NONE added, V4L2_FLASH_LED_MODE_FLASH no longer forced
as 1 in enum.

- Bits use (1 << x) instead of 0x00... format.

- Added an open question on flash LED mode controls.

- Added an open question on a new control:
V4L2_CID_FLASH_EXTERNAL_STROBE_WHENCE.

- Added an open question on control units.


Scope
=====

This RFC is focused mostly on the ADP1653 [1] and similar chips [2, 3]
which provides following functionality. [2, 3] mostly differ on the
available faults --- for example, there are faults also for the
indicator LED.

- High power LED output (flash or torch modes)
- Low power indicator LED output (a.k.a. privacy light)
- Programmable flash timeout
- Software and hardware strobe
- Fault detection
	- Overvoltage
	- Overtemperature
	- Short circuit
	- Timeout
- Programmable current (both high-power and indicator LEDs)

If anyone else is aware of hardware which significantly differs from
these and does not get served well under the proposed interface, please
tell about it.

This RFC does NOT address the synchronisation of the flash to a given
frame since this task is typically performed by the sensor through a
strobe signal. The host does not have enough information for this ---
exact timing information on the exposure of the sensor pixel array. In
this case the flash synchronisation is visible to the flash controller
as the hardware strobe originating from the sensor.

Flash synchronisation requires

1) flash control capability from the sensor including a strobe output,
2) strobe input in the flash controller,
3) (optionally) ability to program sensor parameters at given frame,
such as flash strobe, and
4) ability to read back metadata produced by the sensor related to a
given frame. This should include whether the frame is exposed with
flash, i.e. the sensor's flash strobe output.

Since we have little examples of both in terms of hardware support,
which is in practice required, it was decided to postpone the interface
specification for now. [6]

Xenon flash controllers exist but I don't have a specific example of
those. Typically the interface is quite simple. Gpio pins for charge and
strobe. The length of the strobe signal determines the strength of the
flash pulse. The strobe is controlled by the sensor as for LED flash if
it is hardware based.


Known use cases
===============

The use case listed below concentrate on using a flash in a mobile
device, for example in a mobile phone. The use cases could be somewhat
different in devices the primary use of which is camera.

Unsynchronised LED flash (software strobe)
------------------------------------------

Unsynchronised LED flash is controlled directly by the host as the
sensor. The flash must be enabled by the host before the exposure of the
image starts and disabled once it ends. The host is fully responsible
for the timing of the flash.

Example of such device: Nokia N900.


Synchronised LED flash (hardware strobe)
----------------------------------------

The synchronised LED flash is pre-programmed by the host (power and
timeout) but controlled by the sensor through a strobe signal from the
sensor to the flash.

The sensor controls the flash duration and timing. This control
typically must be programmed to the sensor, and specifying an interface
for this is out of scope of this RFC.

The LED flash controllers we know of can function in both synchronised
and unsynchronised modes.


LED flash as torch
------------------

LED flash may be used as torch in conjunction with another use case
involving camera or individually. [4]


Synchronised xenon flash
------------------------

The synchronised xenon flash is controlled more closely by the sensor
than the LED flash. There is no separate intensity control for the xenon
flash as its intensity is determined by the length of the strobe pulse.
Several consecutive strobe pluses are possible but this needs to be
still controlled by the sensor.


Proposed interface
==================

The flash, either LED or xenon, does not require large amounts of data
to control it. There are parameters to control it but they are
independent and assumably some hardware would only support some subsets
of the functionality available somewhere else. Thus V4L2 controls seem
an ideal way to support flash controllers.

A separate control class is reserved for the flash controls. It is
called V4L2_CTRL_CLASS_FLASH.

Type of the control; type of flash is in parentheses after the control.


	V4L2_CID_FLASH_STROBE (boolean; rw; LED)

Strobe the flash using software strobe from the host, typically over I2C
or a GPIO. The flash is NOT synchronised to sensor pixel are exposure
since the command is given asynchronously. Alternatively, if the flash
controller is a master in the system, the sensor exposure may be
triggered based on software strobe.

This control may also be used to shut down the strobe and query the
state of the strobe (on/off).


	V4L2_CID_FLASH_STROBE_MODE (menu; rw; LED)

Use hardware or software strobe. If hardware strobe is selected, the
flash controller is a slave in the system where the sensor produces the
strobe signal to the flash.

In this case the flash controller setup is limited to programming strobe
timeout and power (LED flash) and the sensor controls the timing and
length of the strobe.

enum v4l2_flash_strobe_mode {
	V4L2_FLASH_STROBE_MODE_SOFTWARE,
	V4L2_FLASH_STROBE_MODE_EXTERNAL,
};


	V4L2_CID_FLASH_TIMEOUT (integer; rw; LED)

The flash controller provides timeout functionality to shut down the led
in case the host fails to do that. For hardware strobe, this is the
maximum amount of time the flash should stay on, and the purpose of the
setting is to prevent the LED from catching fire.

For software strobe, the setting may be used to limit the length of the
strobe using a hardware watchdog. The granularity of the timeout in [1,
2, 3] is very coarse.

A standard unit such as ms or µs should be used.


	V4L2_CID_FLASH_LED_MODE (menu; rw; LED)

enum v4l2_flash_led_mode {
	V4L2_FLASH_LED_MODE_NONE,
	V4L2_FLASH_LED_MODE_FLASH,
	V4L2_FLASH_LED_MODE_TORCH,
};


	V4L2_CID_FLASH_INTENSITY (integer; rw; LED)

Intensity of the flash in hardware specific units. The LED flash
controller provides current to the LED but the actual luminous power is
dictated by the LED connected to the controller.


	V4L2_CID_FLASH_TORCH_INTENSITY (integer; rw; LED)

Intensity of the flash in hardware specific units.


	V4L2_CID_FLASH_INDICATOR_INTENSITY (integer; rw; LED)

Intensity of the indicator light in hardware specific units.


	V4L2_CID_FLASH_FAULT (bit field; ro; LED)

This is a bitmask containing the fault information for the flash. This
assumes the proposed V4L2 bit mask controls [5]; otherwise this would
likely need to be a set of controls.

#define V4L2_FLASH_FAULT_OVER_VOLTAGE		(1 << 0)
#define V4L2_FLASH_FAULT_TIMEOUT		(1 << 1)
#define V4L2_FLASH_FAULT_OVER_TEMPERATURE	(1 << 2)
#define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)

Several faults may occur at single occasion. The ADP1653 is able to
inform the user a fault has occurred, so a V4L2 control event (proposed
earlier) could be used for that.

These faults are supported by the ADP1653. More faults may be added as
support for more chips require that. In some other hardware faults are
available for indicator led as well.

Question: should indicator faults be part of the same control, or a
different control, e.g. V4L2_CID_FLASH_INDICATOR_FAULT?


	V4L2_CID_FLASH_CHARGE (bool; rw; xenon)

Charge control for the xenon flash. Enable or disable charging.


	V4L2_CID_FLASH_READY (bool; ro; xenon, LED)

Flash is ready to strobe. On xenon flash this tells the capacitor has
been charged, on LED flash it's that the LED is no longer too hot.

The implementation on LED flash may be modelling the temperature
behaviour of the LED in the driver (or elsewhere, e.g. library or board
code) if the hardware does not provide direct temperature information
from the LED.

A V4L2 control event should be produced whenever the flash becomes ready.


Open questions
==============

1. Flash LED mode control
-------------------------

Should the flash led mode control be a single control or a set of
controls? A single control would make it easier for application to
choose between different modes, but on the other hand limits future
extensibility if there would have to be further splitting of the modes. [8]

2. External strobe edge / level
-------------------------------

No use is seen currently for this, but it may well appear, and the
hardware supports this. Level based trigger should be used since it is
more precise.

	V4L2_CID_FLASH_EXTERNAL_STROBE_WHENCE

Whether the flash controller considers external strobe as edge, when the
only limit of the strobe is the timeout on flash controller, or level,
when the flash strobe will last as long as the strobe signal, or as long
until the timeout expires.

enum v4l2_flash_external_strobe_whence {
	V4L2_CID_FLASH_EXTERNAL_STROBE_LEVEL,
	V4L2_CID_FLASH_EXTERNAL_STROBE_EDGE,
};

3. Units
--------

Which units should e.g. V4L2_CID_FLASH_TIMEOUT be using? It'd be very
useful to have standard unit on this control, like ms or µs.

Some controls, like V4L2_CID_FLASH_INTENSITY, can't easily use a
standard unit. The luminous output depends on the LED connected (you
could use an incandescent lightbulb too, I suppose?) to the flash
controller. These controls typically control the current supplied by the
flash controller.


References
==========

[1] http://www.analog.com/static/imported-files/data_sheets/ADP1653.pdf

[2] http://www.national.com/mpf/LM/LM3555.html#Overview

[3]
http://www.austriamicrosystems.com/eng/Products/Lighting-Management/Camera-Flash-LED-Drivers/AS3645

[4] http://maemo.org/downloads/product/Maemo5/flashlight-applet/

[5]
http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%202%20(SGz6LU2esk).html

[6]
http://www.retiisi.org.uk/v4l2/v4l2-brainstorming-warsaw-2011-03/notes/day%203%20(RhoYa0X9D7).html

[7] [RFC] V4L2 flash API for flash devices.
http://www.spinics.net/lists/linux-media/msg30725.html

[8] http://www.spinics.net/lists/linux-media/msg30794.html


Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
