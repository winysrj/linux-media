Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab2HTNBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 09:01:38 -0400
Message-ID: <50323559.7040107@redhat.com>
Date: Mon, 20 Aug 2012 15:02:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com>
In-Reply-To: <5032225A.9080305@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/20/2012 01:41 PM, Frank Schäfer wrote:
> Hi,
>
> after a break of 2 1/2 kernel releases (sorry, I was busy with another
> project), I would like to bring up again the question how to add support
> for this device to the kernel.
> See
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44417.html
> ("Move em27xx/em28xx webcams to a gspca subdriver ?") for the previous
> discussion.
>
> Current status is, that I've reverse-engineered the Windows driver and
> written a new gspca-subdriver for testing, which is feature complete and
> working stable (will send a patch shortly !).
>
> The device uses an em2765-bridge, so my first idea was of course to
> modify/extend the em28xx-driver.
> But during the reverse-engineering-process, it turned out that writing a
> new gspca-subdriver was much easier than modifying the em28xx-driver.
>
> The device has the following special characteristics:
> - supports only bulk transfers (em28xx driver supports ISOC only)
> - uses "proprietary" read/write procedures for the sensor
> - uses 16bit eeprom
> - em25xx-eeprom with different layout
> - sensor OV2640
> - different frame processing
> - 3 buttons (snapshot, mute, light) which need special treatment
> (GPIO-polling, status-reseting, ...)
>
> Another important point to mention: you can see from the USB-logs
> (sensor probing) that there must be at least 3 other webcam devices.
>
> Some pros and cons for both solutions:
>
> em28xx:
> + one driver for all 25xx/26xx/27xx/28xx devices
> + no duplicate code (bridge register defines, bridge read/write fcns)
> + other devices COULD benefit from the new functions/code
> - big task/lots of work
> - code gets bloated with stuff, which is only needed by a few special
> devices
>
> gspca:
> + driver already exists (see patch)
> + default driver for webcams
> + much easier to understand and extend
> + same or even less amount of new code lines
> + keeps em28xx-code "simple"
> - code duplication
> - support for em28xx-webcams spread over to 2 different drivers
>
> I have no strong opinion whether support for this device should finally
> be added to em28xx or gspca and
> I'm willing to continue working on both solutions as much as my time
> permits and as long as I'm having fun (I'm doing this as a hobby !).
> Anyway, the em28xx driver is very complex and I really think it would
> take several further kernel releases to get the job done...
> I would also be willing to spend some time for moving the em28xx-webcam
> code to a gspca subdriver, but I don't have any of these devices for
> testing.
>
> What do you think ?

I think given the special way this camera uses the bridge (not using
standard i2c interface, weird button layout, etc.). That it is likely server
better by a specialized driver. As the (new) gspca maintainer I'm fine with
taking it as a gspca sub-driver, but given the code duplication issue,
that is a call Mauro should make.

Note that luckily these devices do use a unique USB id and not one of the
generic em28xx ids so from that pov having a specialized driver for them
is not an issue.

Regards,

Hans

p.s.

Frank have you seen this mail, it seems another Linux user has the same
camera, perhaps he can run some tests for you:
http://osdir.com/ml/linux-media/2009-05/msg00186.html
