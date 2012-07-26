Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36402 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2GZUxg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 16:53:36 -0400
Received: by weyx8 with SMTP id x8so1630757wey.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 13:53:35 -0700 (PDT)
Message-ID: <5011AE50.6080600@uni-bielefeld.de>
Date: Thu, 26 Jul 2012 22:53:36 +0200
From: Robert Abel <abel@uni-bielefeld.de>
Reply-To: abel@uni-bielefeld.de
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: Advice on extending libv4l for media controller support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry to be late to the party... I wanted to follow up on this
discussion, but forgot and haven't read anything about it since...

On 10.05.2012 17:09, Ivan T. Ivanov wrote:
> On Wed, May 9, 2012 at 7:08 PM, Sergio Aguirre
> <sergio.a.aguirre@gmail.com> wrote:
>> I want to create some sort of plugin with specific media
>> controller configurations,
>> to avoid userspace to worry about component names and specific
>> usecases (use sensor resizer, or SoC ISP resizer, etc.).
> Probably following links can help you. They have been tested
> with the OMAP3 ISP.
>
> Regards,
> iivanov
>
> [1] http://www.spinics.net/lists/linux-media/msg31901.html
> [2]
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/32704

I recently extended Yordan Kamenov's libv4l-mcplugin to support multiple
trees per device with extended configurations (-stolen from- inspired by
media-ctl) not tied to specific device nodes (but to device names instead).

I uploaded the patches here
<https://sites.google.com/site/rawbdagslair/libv4l-mcplugin.7z?attredirects=0&d=1>(16kB).
Basically, I used Yordan's patches as a base and worked from there to
fix up his source code and Makefile for cross-compiling using
OpenEmbedded/Yocto.

There are a ton of minor issues with this, starting with the fact that I
did not put proper copyright notices in any of these files. Please
advise if this poses a problem.
Only integral frame size support and no support for native read() calls.
There's a dummy read() function, because for some reason this is
required in libv4l2 0.9.0-test though it's not mentioned anywhere. As
the original plug-in by Yordan, there is currently no cleaning-up of the
internal data structures.

I used this in conjunction with the Gumstix CASPA FS (MT9V032) camera
using some of Laurent's patches and some custom patches which add
ENUM_FMT support to the driver.

Basically, upon opening a given device, all trees are configured once to
load the respective end-point's formats for emulation of setting and
getting formats. Then regular format negotiation by the user application
takes place.

Regards,

Robert
