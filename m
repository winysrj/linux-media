Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60417 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2DFJL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 05:11:58 -0400
Received: by ghrr11 with SMTP id r11so1212804ghr.19
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2012 02:11:58 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 6 Apr 2012 11:11:58 +0200
Message-ID: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
Subject: RTL28XX driver
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

i own a TerraTec Cinergy T Stick Black device, and was able to find a
working driver for the device. It seems to be, that the driver was
originally written by Realtek and has since been updated by different
Developers to meet DVB API changes. I was wondering what would be the
necessary steps to include the driver into the kernel sources?

The one thing that needs to be solved before even thinking about the
integration, is the licencing of the code. I did find it on two
different locations, but without any licencing information. So
probably Realtek should be contacted. I am willing to deal with that,
but need furter information on under whitch lisence the code has to be
relased.

So far, I put up a Github repository for the driver, which enables me
to compile the proper kernel modue at
https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
The modificatioins to the driver where taken from openpli
http://openpli.git.sourceforge.net/git/gitweb.cgi?p=openpli/openembedded;a=blob;f=recipes/linux/linux-etxx00/dvb-usb-rtl2832.patch;h=063114c8ce4a2dbcf8c8dde1b4ab4f8e329a2afa;hb=HEAD

In the driver sources I stumbled accross many different devices
containig the RTL28XX chipset, so I suppose the driver would enably
quite many products to work.

As I am relatively new to the developement of dvb drivers I appreciate
any help in stabilizing the driver and proper integration into the dvb
API.

Greetings
Thomas
