Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48613 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759547Ab0E0TAY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 15:00:24 -0400
Message-ID: <4BFEC141.6000202@gmx.de>
Date: Thu, 27 May 2010 21:00:17 +0200
From: Udo Richter <udo_richter@gmx.de>
MIME-Version: 1.0
To: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Idea of a v4l -> fb interface driver
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange> <19F8576C6E063C45BE387C64729E7394044E616F05@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044E616F05@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.05.2010 08:44, schrieb Hiremath, Vaibhav:
>> 		V4L(2) video output vs. framebuffer.
>>
>> Problem: Currently the standard way to provide graphical output on various
>> (embedded) displays like LCDs is to use a framebuffer driver. The
>> interface is well supported and widely adopted in the user-space, many
>> applications, including the X-server, various libraries like directfb,
>> gstreamer, mplayer, etc. In the kernel space, however, the subsystem has a
>> number of problems. It is unmaintained. The infrastructure is not being
>> further developed, every specific hardware driver is being supported by
>> the respective architecture community. But as video output hardware
>> evolves, more complex displays and buses appear and have to be supported,
>> the subsystem shows its aging. For example, there is currently no way to
>> write reusable across multiple platforms display drivers.


To add another point of view: I'm not completely sure how much these
topics overlap, but another area where there's display output available,
but not using some generic interface like fbdev, are DVB adapters with
video output capabilities, e.g. /dev/dvb/adapterX/osdY devices and similar.

The 'old' style Technotrend Full Featured DVB cards can only display
either mpeg streams or very basic and restricted OSD overlays, but the
newer generation of HD capable video decoders are usually capable of
displaying an RGB32 video overlay in HD resolution. If these decoder
cards would provide a framebuffer device, these devices could instantly
be used for various media applications on the TV, like xbmc. Actually,
the missing ability to run generic apps on DVB output devices is one of
their biggest disadvantage over regular graphics cards with video
acceleration.

Maybe such a v4l-fbdev interface could handle such devices too?


Cheers,

Udo
