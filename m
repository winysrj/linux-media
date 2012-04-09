Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51212 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2DIMCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 08:02:18 -0400
Received: by vbbff1 with SMTP id ff1so2199570vbb.19
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2012 05:02:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F804CDC.3030306@gmail.com>
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
	<4F804CDC.3030306@gmail.com>
Date: Mon, 9 Apr 2012 14:02:17 +0200
Message-ID: <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com>
Subject: Re: RTL28XX driver
From: Thomas Mair <thomas.mair86@googlemail.com>
To: gennarone@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gainluca,

thanks for your information. I did get in touch with Realtek and they
provided me with the datasheet for the RTL2832U. So what I will try to
do is write a demodulator driver for the RTL2832 demod chip following
the information of the datasheet and the Realtek driver. I will follow
Antti's RTL2830 driver structure.

For now there is only one question left regarding the testing of the
drivers. What is the best way to test and debug the drivers. Sould I
compile the 3.4 kernel and use it, or is it safer to set up a
structure like the one I already have to test the driver with a stable
kernel?

Greetings
Thomas

2012/4/7 Gianluca Gennari <gennarone@gmail.com>:
> Il 06/04/2012 11:11, Thomas Mair ha scritto:
>> Hello everyone,
>>
>> i own a TerraTec Cinergy T Stick Black device, and was able to find a
>> working driver for the device. It seems to be, that the driver was
>> originally written by Realtek and has since been updated by different
>> Developers to meet DVB API changes. I was wondering what would be the
>> necessary steps to include the driver into the kernel sources?
>>
>> The one thing that needs to be solved before even thinking about the
>> integration, is the licencing of the code. I did find it on two
>> different locations, but without any licencing information. So
>> probably Realtek should be contacted. I am willing to deal with that,
>> but need furter information on under whitch lisence the code has to be
>> relased.
>>
>> So far, I put up a Github repository for the driver, which enables me
>> to compile the proper kernel modue at
>> https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
>> The modificatioins to the driver where taken from openpli
>> http://openpli.git.sourceforge.net/git/gitweb.cgi?p=openpli/openembedded;a=blob;f=recipes/linux/linux-etxx00/dvb-usb-rtl2832.patch;h=063114c8ce4a2dbcf8c8dde1b4ab4f8e329a2afa;hb=HEAD
>>
>> In the driver sources I stumbled accross many different devices
>> containig the RTL28XX chipset, so I suppose the driver would enably
>> quite many products to work.
>>
>> As I am relatively new to the developement of dvb drivers I appreciate
>> any help in stabilizing the driver and proper integration into the dvb
>> API.
>>
>
> Hi Thomas,
> the Realtek driver you mention is the full version, which supports 3
> demodulators (2832=DVB-T, 2836=DTMB, 2840=DVB-C) and 10 different tuners.
> There is also a simplified version of the driver which supports only
> DVB-T and 4 tuners: this is probably a better starting base for your
> project.
>
> You can find the simplified driver here:
>
> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-4_tuner
>
> My friend Ambrosa got it directly from Realtek. You can mail the 2
> driver authors directly:
>
> author:         Dean Chung <DeanChung@realtek.com>
> author:         Chialing Lu <chialing@realtek.com>
>
> as they have been quite collaborative last year. I think they can also
> provide you some information about the code license.
>
> The rtl2832 devices I've seen so far use either the Fitipower fc0012 or
> the Elonics E4000 tuner. For the first one there is a driver from
> Hans-Frieder Vogt that is not yet included in the development tree, but
> it has been posted recently on this list.
>
> If your stick uses this tuner, then the problem reduces to write the
> demodulator driver (as Antti already explained).
>
> Best regards,
> Gianluca
>
