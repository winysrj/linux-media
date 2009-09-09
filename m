Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45146 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZIIV7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 17:59:05 -0400
Received: by fxm17 with SMTP id 17so3713587fxm.37
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 14:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>
References: <62013cda0909091443g72ebdf1bge3994b545a86c854@mail.gmail.com>
Date: Wed, 9 Sep 2009 17:59:07 -0400
Message-ID: <829197380909091459x5367e95dnbd15f23e8377cf33@mail.gmail.com>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Clinton Meyer <clintonmeyer22@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 5:43 PM, Clinton Meyer<clintonmeyer22@gmail.com> wrote:
> Purchased a Hauppauge WinTV-HVR-950Q USB Hybrid TV stick to capture ATSC OTA TV.
>
> Am running MEPIS 8.06 on all three machines, Debian 5 Lenny based, KDE
> 3.5.10, kernel 2.6.27-1-mepis-smp
>
> All three machines now have wireless blocked, either do not connect or
> all packets dropped/blocked if a connection is made.
>
> Used the resources from LinuxTV (dot) org
>
> to get it working, they are referenced and posted as follows:
>  linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-950Q#Firmware
>
> ******** *********** **********
>  Quote:
> In order to use the LinuxTV driver, you need to download and install
> the firmware for the xc5000.
>
> Quote:
> wget  ... steventoth (dot) net/linux/xc50...25271_WHQL (dot) zip
> wget ... steventoth (dot) net/linux/xc5000/extract (dot) sh
>  sh extract (dot) sh
> cp dvb-fe-xc5000-1.1 (dot) fw /lib/firmware
> :Unquote
>
> Note: Though the usual directory location in which the firmware file
> is placed is /lib/firmware, this may differ in the case of some
> distros; consult your distro's documentation for the appropriate
> location.
>
> The firmware will be added lazily (on-demand) when you first use the driver.
> Drivers
>
> The xc5000 driver needed for this WinTV-HVR-950Q is already part of
> the latest Linux kernel (part of v4l-dvb drivers).
>
> Analog support was merged into the mainline v4l-dvb tree on March 18, 2009.
> :Unquote
> ******** *********** ********** ******** *********** **********
> So on Saturday I got this up and running... and Sunday morning
> recorded one show successfully that had set up on a timer.
>
> Then set up three consecutive shows for the afternoon.
> They were all part of a series on the same channel. Here are the results:
>
>     * Show A, 2.5 hours long, 13.2gb file size, appears to be OK.
>     * Show B, 2.0 hours long, 3.7gb file size, appears to be OK.
>      * Show C, supposed to be 2.0 hours long, result was 2.7gb file
> size, about the first hour is missing.
>
> At about this point, I lost wireless internet connectivity on TV
> recording laptop. Machine sees the access point, but won't connect.
>
> Went to my main desktop where i had first worked with this Hauppauge
> WinTV-HVR-950Q USB Hybrid TV stick and that machine also lost
> internet, even though it was right next to AP and got a very good
> signal.
>
> Thought it was maybe the AP, so switched it out for a working spare.
>  Same results.
> Packed up laptop and a spare laptop, along with a MEPIS 8.06 LiveCD
> and an 8.06 Live USB stick and hit the road to go to a reliable high
> speed wifi spot.
> Same results... changins ISPs resulted in the same issues.
>  Also same ting happened with the spare laptop, an IBM T43 Thinkpad I
> had also done the "wget ... steventoth (dot)
> net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL (dot) zip"
> firmware thing to.
>
> Was able to get one machine, while running a LIVE USB session, to
> connect, but zero packets received.. ALL were blocked. The connection
> information said ALL packets were dropped.
>  None of the two other machines connected to wireless on a LiveCD or
> LiveUSB thing too
> Three machines. All different brands (HP, Dell, and IBM) with
> different wifi cards. All three see the access point ESSID, but none
> connect.
>
> This does not *feel* good. What got flashed? Can this be resolved?
>
> Came home. No difference. Grabbed a laptop that i had NOT done the
> firmware thing to and that is what I am using to write this. Hooked
> right up to the AP.
>
> Please help... that is too much hardware disabled for me to think calmly.
> I'd really like to make the USB tv tuner work... what a great way to
> PVR / DVR, but I need wireless.
>
> Can provide any details requested to drive this towards a fix!
>
> Thank you,
> Clinton
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Clinton,

That is indeed curious.  It's hard to imagine how there could be
interference between the V4L subsystem and the wireless subsystem,
short of hitting some sort of timing condition on crappy wireless
drivers.

Here are a few questions:

1.  You specified you followed the instructions for the firmware, but
are you running the current v4l-dvb code, or are you just using
whatever came with your Debian kernel?  If you're actually using the
1.1 Xceive firmware, I'm assuming you're still using the old code.

2.  How reproducible is this?  Does it occur even if the device is
connected but you do not attempt any capturing with the device?  Does
it always drop out while capturing?

3.  What type of wireless cards are you using?  Are they implemented
over PCI, or USB?  If the wireless cards are USB based, perhaps there
is some sort of USB bandwidth issue.

4.  Are you actively watching the programs you are capturing?  Or are
you just saving the content to disk?  What application are you using
to capture the ATSC video?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
