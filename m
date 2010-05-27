Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63626 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0E0LFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 07:05:35 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005270809110.2293@axis700.grange>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
	<AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
	<Pine.LNX.4.64.1005270809110.2293@axis700.grange>
Date: Thu, 27 May 2010 19:05:34 +0800
Message-ID: <AANLkTik0DHDhmr78xOG2cTUgrTWZKzYDwBl27TXHgcGp@mail.gmail.com>
Subject: Re: Idea of a v4l -> fb interface driver
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 27, 2010 at 2:56 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> (adding V4L ML to CC and preserving the complete reply for V4L readers)
>
> On Thu, 27 May 2010, Jaya Kumar wrote:
>
>> On Wed, May 26, 2010 at 10:09 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
> Ok, let me explain what exactly I meant. Above I referred to "display
> drivers," which is not the same as a "framebuffer controller driver" or
> whatever you would call it. By framebuffer controller driver I mean a
> driver for the actual graphics engine on a certain graphics card or an
> SoC. This is the part, that reads data from the actual framebuffer and
> outputs it to some hardware interface to a display device. Now this
> interface can be a VGA or a DVI connector, it can be one of several bus
> types, used with various LCD displays. In many cases this is all you have
> to do to get the output to your display. But in some cases the actual
> display on the other side of this bus also requires a driver. That can be
> some kind of a smart display, it can be a panel with an attached display
> controller, that must be at least configured, say, over SPI, it can be a
> display, attached to the host over the MIPI DSI bus, and implementing some
> proprietary commands. In each of these cases you will have to write a
> display driver for this specific display or controller type, and your
> framebuffer driver will have to interface with that display driver. Now,
> obviously, those displays can be connected to a variety of host systems,
> in which case you will want to reuse that display driver. This means,
> there has to be a standard fb-driver - display-driver API. AFAICS, this is
> currently not implemented in fbdev, please, correct me if I am wrong.

Thanks Guennadi, your clarification is useful. Yes, you are correct.
There is no general fbdev API provided so that a host controller
driver and a independent display panel driver can interface in a clean
abstracted way.

You've raised the MIPI-DSI issue. It is a good area to focus the
discussion on for fbdev minded people and one that needs to be
resolved soon so that we don't get dozens of host controller specific
mipi display panel drivers. I had seen that omap2 fbdev has a portion
of the MIPI-DSI command set exposed to their various display panel
drivers which then hands off these commands to the omap specific
lcd_mipid.c which uses spi. I see you've also implemented a similar
concept in sh-mobile. When I saw the multiple display panel drivers
showing up in omap, I raised a concern with Tomi and I think there was
an intent to try to improve the abstraction. I'm not sure how far that
has progressed. Are you saying v4l would help us in that area? I'm not
yet able to follow the details of how using v4l would help address the
need for mipi-dsi abstraction. Could you elaborate on that?

Thanks,
jaya
