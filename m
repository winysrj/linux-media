Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59588 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759483Ab0E1Rr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 13:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005272216380.1703@axis700.grange>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
	<AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
	<Pine.LNX.4.64.1005270809110.2293@axis700.grange>
	<AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com>
	<Pine.LNX.4.64.1005272216380.1703@axis700.grange>
Date: Fri, 28 May 2010 13:47:55 -0400
Message-ID: <AANLkTikTBFPxbl5p9kI65bHt2UJZ5j0DAxFwJ6rzD77L@mail.gmail.com>
Subject: Re: Idea of a v4l -> fb interface driver
From: Alex Deucher <alexdeucher@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 28, 2010 at 4:21 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 27 May 2010, Alex Deucher wrote:
>
>> On Thu, May 27, 2010 at 2:56 AM, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>
> ...
>
>> > Ok, let me explain what exactly I meant. Above I referred to "display
>> > drivers," which is not the same as a "framebuffer controller driver" or
>> > whatever you would call it. By framebuffer controller driver I mean a
>> > driver for the actual graphics engine on a certain graphics card or an
>> > SoC. This is the part, that reads data from the actual framebuffer and
>> > outputs it to some hardware interface to a display device. Now this
>> > interface can be a VGA or a DVI connector, it can be one of several bus
>> > types, used with various LCD displays. In many cases this is all you have
>> > to do to get the output to your display. But in some cases the actual
>> > display on the other side of this bus also requires a driver. That can be
>> > some kind of a smart display, it can be a panel with an attached display
>> > controller, that must be at least configured, say, over SPI, it can be a
>> > display, attached to the host over the MIPI DSI bus, and implementing some
>> > proprietary commands. In each of these cases you will have to write a
>> > display driver for this specific display or controller type, and your
>> > framebuffer driver will have to interface with that display driver. Now,
>> > obviously, those displays can be connected to a variety of host systems,
>> > in which case you will want to reuse that display driver. This means,
>> > there has to be a standard fb-driver - display-driver API. AFAICS, this is
>> > currently not implemented in fbdev, please, correct me if I am wrong.
>>
>>
>> Another API to consider in the drm kms (kernel modesetting) interface.
>>  The kms API deals properly with advanced display hardware and
>> properly handles crtcs, encoders, and connectors.  It also provides
>> fbdev api emulation.
>
> Well, is KMS planned as a replacement for both fbdev and user-space
> graphics drivers? I mean, if you'd be writing a new fb driver for a
> relatively simple embedded SoC, would KMS apriori be a preferred API?

It's become the defacto standard for X and things like EGL are being
built onto of the API.  As for the kms vs fbdev, kms provides a nice
API for complex display setups with multiple display controllers and
connectors while fbdev assumes one monitor/connector/encoder per
device.  The fbdev and console stuff has yet to take advantage of this
flexibility, I'm not sure what will happen there.  fbdev emulation is
provided by kms, but it has to hide the complexity of the attached
displays.  For an soc with a single encoder and display, there's
probably not much advantage over fbdev, but if you have an soc that
can do TMDS and LVDS and possibly analog tv out, it gets more
interesting.

drm has historically been tied to pci, but Jordan Crouse recently
posted changes to support platform devices:
http://lists.freedesktop.org/archives/dri-devel/2010-May/000887.html

Alex
