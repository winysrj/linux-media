Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:35305 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0CAJCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 04:02:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH 1/3] add feedback LED control
Date: Mon, 1 Mar 2010 10:03:48 +0100
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
References: <4B8A2158.6020701@freemail.hu> <20100228202801.6986cb19@tele> <4B8AC618.80200@freemail.hu>
In-Reply-To: <4B8AC618.80200@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003011003.50713.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 28 February 2010 20:38:00 Németh Márton wrote:
> Jean-Francois Moine wrote:
> > On Sun, 28 Feb 2010 08:55:04 +0100
> > 
> > Németh Márton <nm127@freemail.hu> wrote:
> >> On some webcams a feedback LED can be found. This LED usually shows
> >> the state of streaming mode: this is the "Auto" mode. The LED can
> >> be programmed to constantly switched off state (e.g. for power saving
> >> reasons, preview mode) or on state (e.g. the application shows motion
> >> detection or "on-air").
> > 
> > Hi,
> > 
> > There may be many LEDs on the webcams. One LED may be used for
> > the streaming state, Some other ones may be used to give more light in
> > dark rooms. One webcam, the microscope 093a:050f, has a top and a bottom
> > lights/illuminators; an other one, the MSI StarCam 370i 0c45:60c0, has
> > an infra-red light.
> > 
> > That's why I proposed to have bit fields in the control value to switch
> > on/off each LED.
> 
> With a bitfield on and off state can be specified. What about the "auto"
> mode? Should two bits grouped together to have auto, on and off state? Is
> there already a similar control?

I don't like the bitfield either. As stated in my previous mail, we can have 
more than 3 states, so using 2 bits per LED will simply not scale.

> Is the brightness of the background light LEDs adjustable or are they just
> on/off? If yes, then maybe the feedback LEDs and the background light LEDs
> should be treated as different kind.

I think there should indeed be a different control for the background LEDs. 
Still, there could be more than one feedback LED.

-- 
Regards,

Laurent Pinchart
