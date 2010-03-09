Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46780 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0CIO5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 09:57:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [RFC, PATCH 1/3] gspca: add LEDs subsystem connection
Date: Tue, 9 Mar 2010 12:27:53 +0100
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
References: <4B8A2158.6020701@freemail.hu> <20100301101806.7c7986be@tele> <4B8DA25F.10602@freemail.hu>
In-Reply-To: <4B8DA25F.10602@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003091227.54229.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Màrton,

Thanks for the patch.

On Wednesday 03 March 2010 00:42:23 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> On some webcams one or more LEDs can be found. One type of these LEDs
> are feedback LEDs: they usually shows the state of streaming mode.
> The LED can be programmed to constantly switched off state (e.g. for
> power saving reasons, preview mode) or on state (e.g. the application
> shows motion detection or "on-air").
> 
> The second type of LEDs are used to create enough light for the sensor
> for example visible or in infra-red light.
> 
> Both type of these LEDs can be handled using the LEDs subsystem. This
> patch add support to connect a gspca based driver to the LEDs subsystem.

They can indeed, but I'm not sure if the LEDs subsystem was designed for that 
kind of use cases.

The LED framework was developed to handle LEDs found in embedded systems 
(usually connected to GPIOs) that needed to be connected to software triggers 
or controlled by drivers and/or specific userspace applications. Webcam LEDs 
seem a bit out of scope to me, especially the "light" LED that might be better 
handled by a V4L2 set of controls (we're currently missing controls for camera 
flashes, be they LEDs or Xenon based).

I'll let Richard speak on this.

-- 
Regards,

Laurent Pinchart
