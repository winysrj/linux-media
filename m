Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38970 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3EIRs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 13:48:29 -0400
Received: by mail-ea0-f182.google.com with SMTP id z16so1773356ead.13
        for <linux-media@vger.kernel.org>; Thu, 09 May 2013 10:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518BDFCE.1000805@libertysurf.fr>
References: <20130509144422.420FC8FF9BB@zimbra65-e11.priv.proxad.net>
	<518BBAE4.4010507@libertysurf.fr>
	<CADnq5_ODkgRUVc72w01L2BHGcp3OKTpENnKaL24PPdg96SYZpQ@mail.gmail.com>
	<518BDFCE.1000805@libertysurf.fr>
Date: Thu, 9 May 2013 13:48:27 -0400
Message-ID: <CADnq5_MSxz3atPGrHs8saX=6981ou3YXU8_nUCAy_TLW2374yg@mail.gmail.com>
Subject: Re: HD-Audio Generic HDMI/DP on wheezy
From: Alex Deucher <alexdeucher@gmail.com>
To: pdurand13@libertysurf.fr
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 9, 2013 at 1:41 PM, pierre <pdurand13@libertysurf.fr> wrote:
> Thanks for your quick ansver, but after modifing /etc/default/grub with
> GRUB_CMDLINE_LINUX="radeon.audio=1 and update-grub then reboot, nothing go
> better:

Perhaps I misunderstood what you were asking about.  radeon.audio=1
just enables auto routing via HDMI.  what exactly are you trying to
do?  Discrete graphics cards only support audio via HDMI or DP.

Alex


>
> May  9 19:32:37 retraite kernel: [    6.660223] snd_hda_intel 0000:01:00.1:
> irq 45 for MSI/MSI-X
> May  9 19:32:37 retraite kernel: [    6.660242] snd_hda_intel 0000:01:00.1:
> setting latency timer to 64
> May  9 19:32:37 retraite kernel: [    6.684425] HDMI status: Codec=0 Pin=3
> Presence_Detect=0 ELD_Valid=0
> May  9 19:32:37 retraite kernel: [    6.684523] input: HD-Audio Generic
> HDMI/DP,pcm=3 as
> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input6
> May  9 19:32:37 retraite kernel: [    6.996110] WARNING: You are using an
> experimental version of the media stack.
> May  9 19:32:37 retraite kernel: [    6.996111]     As the driver is
> backported to an older kernel, it doesn't offer
> May  9 19:32:37 retraite kernel: [    6.996112]     enough quality for its
> usage in production.
> May  9 19:32:37 retraite kernel: [    6.996113]     Use it with care.
> May  9 19:32:37 retraite kernel: [    6.996114] Latest git patches (needed
> if you report a bug to linux-media@vger.kernel.org):
> May  9 19:32:37 retraite kernel: [    6.996115]
> 02615ed5e1b2283db2495af3cf8f4ee172c77d80 [media] cx88: make core less
> verbose
> May  9 19:32:37 retraite kernel: [    6.996116]
> a3b60209e7dd4db05249a9fb27940bb6705cd186 [media] em28xx: fix oops at
> em28xx_dvb_bus_ctrl()
> May  9 19:32:37 retraite kernel: [    6.996117]
> 4494f0fdd825958d596d05a4bd577df94b149038 [media] s5c73m3: fix indentation of
> the help section in Kconfig
> May  9 19:32:37 retraite kernel: [    7.055361] WARNING: You are using an
> experimental version of the media stack.
> May  9 19:32:37 retraite kernel: [    7.055363]     As the driver is
> backported to an older kernel, it doesn't offer
> May  9 19:32:37 retraite kernel: [    7.055364]     enough quality for its
> usage in production.
> May  9 19:32:37 retraite kernel: [    7.055365]     Use it with care.
> May  9 19:32:37 retraite kernel: [    7.055366] Latest git patches (needed
> if you report a bug to linux-media@vger.kernel.org):
> May  9 19:32:37 retraite kernel: [    7.055367]
> 02615ed5e1b2283db2495af3cf8f4ee172c77d80 [media] cx88: make core less
> verbose
> May  9 19:32:37 retraite kernel: [    7.055369]
> a3b60209e7dd4db05249a9fb27940bb6705cd186 [media] em28xx: fix oops at
> em28xx_dvb_bus_ctrl()
> May  9 19:32:37 retraite kernel: [    7.055370]
> 4494f0fdd825958d596d05a4bd577df94b149038 [media] s5c73m3: fix indentation of
> the help section in Kconfig
>
> Pierre
>
> Le 09/05/2013 18:12, Alex Deucher a écrit :
>
> On Thu, May 9, 2013 at 11:04 AM, pierre <pdurand13@libertysurf.fr> wrote:
>
> Hi,
>
> Some difficult on wheezy, on my computer
> product: Inspiron 620
> vendor: Dell Inc.
> version: 00
> serial: D9V135J
> width: 64 bits
>
> My sound card is now defined as Caicos HDMI Audio [Radeon HD 6400 Series]
> Digital Stereo (HDMI) on Squeeze, it was HD-Audio Generic Digital Stereo
> (HDMI).
> It works but i'm not able to get analogic output, only HDMI / display port
> that i can't use.
>
> You need to enable the audio parameter in the radeon driver.  Boot with:
> radeon.audio=1
> on the kernel command line in grub.
>
> Alex
>
>
