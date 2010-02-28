Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:44841 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936600Ab0B1TiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 14:38:04 -0500
Message-ID: <4B8AC618.80200@freemail.hu>
Date: Sun, 28 Feb 2010 20:38:00 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] add feedback LED control
References: <4B8A2158.6020701@freemail.hu> <20100228202801.6986cb19@tele>
In-Reply-To: <20100228202801.6986cb19@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 28 Feb 2010 08:55:04 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> On some webcams a feedback LED can be found. This LED usually shows
>> the state of streaming mode: this is the "Auto" mode. The LED can
>> be programmed to constantly switched off state (e.g. for power saving
>> reasons, preview mode) or on state (e.g. the application shows motion
>> detection or "on-air").
> 
> Hi,
> 
> There may be many LEDs on the webcams. One LED may be used for
> the streaming state, Some other ones may be used to give more light in
> dark rooms. One webcam, the microscope 093a:050f, has a top and a bottom
> lights/illuminators; an other one, the MSI StarCam 370i 0c45:60c0, has
> an infra-red light.
> 
> That's why I proposed to have bit fields in the control value to switch
> on/off each LED.

With a bitfield on and off state can be specified. What about the "auto" mode?
Should two bits grouped together to have auto, on and off state? Is there
already a similar control?

Is the brightness of the background light LEDs adjustable or are they just on/off?
If yes, then maybe the feedback LEDs and the background light LEDs should be
treated as different kind.

Regards,

	Márton Németh
