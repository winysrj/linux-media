Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61010 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2DGOTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 10:19:13 -0400
Received: by wejx9 with SMTP id x9so1909193wej.19
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 07:19:12 -0700 (PDT)
Message-ID: <4F804CDC.3030306@gmail.com>
Date: Sat, 07 Apr 2012 16:19:08 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
In-Reply-To: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 06/04/2012 11:11, Thomas Mair ha scritto:
> Hello everyone,
> 
> i own a TerraTec Cinergy T Stick Black device, and was able to find a
> working driver for the device. It seems to be, that the driver was
> originally written by Realtek and has since been updated by different
> Developers to meet DVB API changes. I was wondering what would be the
> necessary steps to include the driver into the kernel sources?
> 
> The one thing that needs to be solved before even thinking about the
> integration, is the licencing of the code. I did find it on two
> different locations, but without any licencing information. So
> probably Realtek should be contacted. I am willing to deal with that,
> but need furter information on under whitch lisence the code has to be
> relased.
> 
> So far, I put up a Github repository for the driver, which enables me
> to compile the proper kernel modue at
> https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
> The modificatioins to the driver where taken from openpli
> http://openpli.git.sourceforge.net/git/gitweb.cgi?p=openpli/openembedded;a=blob;f=recipes/linux/linux-etxx00/dvb-usb-rtl2832.patch;h=063114c8ce4a2dbcf8c8dde1b4ab4f8e329a2afa;hb=HEAD
> 
> In the driver sources I stumbled accross many different devices
> containig the RTL28XX chipset, so I suppose the driver would enably
> quite many products to work.
> 
> As I am relatively new to the developement of dvb drivers I appreciate
> any help in stabilizing the driver and proper integration into the dvb
> API.
> 

Hi Thomas,
the Realtek driver you mention is the full version, which supports 3
demodulators (2832=DVB-T, 2836=DTMB, 2840=DVB-C) and 10 different tuners.
There is also a simplified version of the driver which supports only
DVB-T and 4 tuners: this is probably a better starting base for your
project.

You can find the simplified driver here:

https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-4_tuner

My friend Ambrosa got it directly from Realtek. You can mail the 2
driver authors directly:

author:         Dean Chung <DeanChung@realtek.com>
author:         Chialing Lu <chialing@realtek.com>

as they have been quite collaborative last year. I think they can also
provide you some information about the code license.

The rtl2832 devices I've seen so far use either the Fitipower fc0012 or
the Elonics E4000 tuner. For the first one there is a driver from
Hans-Frieder Vogt that is not yet included in the development tree, but
it has been posted recently on this list.

If your stick uses this tuner, then the problem reduces to write the
demodulator driver (as Antti already explained).

Best regards,
Gianluca

