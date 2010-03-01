Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:32786 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab0CAJRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 04:17:47 -0500
Date: Mon, 1 Mar 2010 10:18:06 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] add feedback LED control
Message-ID: <20100301101806.7c7986be@tele>
In-Reply-To: <4B8AC618.80200@freemail.hu>
References: <4B8A2158.6020701@freemail.hu>
	<20100228202801.6986cb19@tele>
	<4B8AC618.80200@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 28 Feb 2010 20:38:00 +0100
Németh Márton <nm127@freemail.hu> wrote:

> With a bitfield on and off state can be specified. What about the
> "auto" mode? Should two bits grouped together to have auto, on and
> off state? Is there already a similar control?
> 
> Is the brightness of the background light LEDs adjustable or are they
> just on/off? If yes, then maybe the feedback LEDs and the background
> light LEDs should be treated as different kind.

OK. My idea about switching the LEDs by v4l2 controls was not good. So,
forget about it.

Instead, some job of the led class may be done in the gspca main,
especially register/unregister.

I propose to add a LED description in the gspca structure (level
'struct cam'). There would be 'nleds' for the number of LEDS and
'leds', a pointer to an array of:

	struct gspca_led {
		struct led_classdev led_cdev;
		char led_name[32];
		struct led_trigger led_trigger;
		char trigger_name[32];
	};

(this array should be in the subdriver structure - I don't show the
#ifdef's)

Then, this would work as:

- on probe, in the 'config' function of the subdriver, this one
  initializes the led and trigger fields. The 'led_cdev.name' and
  'led_trigger.name' should point to a sprintf format with one
  argument: the video device number (ex: "video%d::toplight").

- then, at the end of gspca_dev_probe(), the gspca main creates the real
  names of the leds and triggers, and does the register job.

- all led/trigger events are treated by the subdriver, normally by a
  workqueue. This one must not be the system workqueue.

- on disconnection, the gspca main unregisters the leds and triggers
  without calling the subdriver. In the workqueue, the disconnection
  can be simply handled testing the flag 'present' after each subsystem
  call.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
