Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49455 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab2LLQjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 11:39:35 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm2so752711wib.16
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2012 08:39:34 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: "Fricke, Silvio" <SFricke@data-modul.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guitarte =?ISO-8859-1?Q?P=E9rez=2C_Jes=FAs?= Fernando
	<JGuitarte@data-modul.com>
Subject: Re: request for linux driver for Analogix ANX9804/ANX9805
Date: Wed, 12 Dec 2012 17:33:24 +0100
Message-ID: <2199300.65rVC8Ir9f@dibcom294>
In-Reply-To: <CB1254936A837D40B8C8611AEC83D691065C2388@MS-DM-M01.DATA-MODUL.com>
References: <CB1254936A837D40B8C8611AEC83D691065C2388@MS-DM-M01.DATA-MODUL.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 12 December 2012 13:20:46 Fricke, Silvio wrote:
> Hi,
> 
> We have developed a prototype of an i.mx6 CPU-module connected to an
> ANALOGIX AN9804 chip. This is a DisplayPort/HDMI-Transmitter [1]. This is
> a converter for simple rgb-signals to DisplayPort and HDMI signals. The
> ANX is connected with the i.mx6 over i2c. Audio plays in this context
> also a role.
> 
> The chip has these features:
>
>  [..]
> 
> I have checked it, and it does not exist any kind of linux driver for the
> ANX9804. My company doesn't have currently the skills (and manpower) to
> bring this device to mainline kernel. Have someone skills and courage to
> bring this hardware device to mainline kernel? I will offer one iMX6
> based development board for developing the device driver and after
> success of the project, for the developer as gift to dominate the world.

What do you call this then? http://members.efn.org/~rick/work/anx9804/

The development of such a driver basically driven by one thing: the 
information about how to program this device. Registers/firmwares/program-
flows.

In a second, yet important, step, you need to be know with which kind of 
(already existing or not) API you want to use this device.

In your Email there is no indication of both of this. Please clarify.

best regards,
--
Patrick

Kernel Labs Inc.
http://www.kernellabs.com/
