Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49521 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2DFJgs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 05:36:48 -0400
Message-ID: <4F7EB92E.3050902@iki.fi>
Date: Fri, 06 Apr 2012 12:36:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
In-Reply-To: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.04.2012 12:11, Thomas Mair wrote:
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

Biggest problem here is missing demodulator driver. RTL2832U chip 
integrates demod called RTL2832. DVB USB device contains logically three 
entity: USB-interface, demodulator and tuner. All those needs own Kernel 
driver. In case of RTL2832U there is already RTL28XXU USB -interface 
driver ready as I did it for RTL2831U. Those two chips uses basically 
same USB -interface but demodulator is different. During the RTL2831U 
development I also ran RTL2832U device using same USB -interface driver 
so I know it works.

So look example from RTL2831U (which is Kernel modules: dvb_usb_rtl28xxu 
and rtl2830) and try to implement new demod driver.

You will also need RF-tuner driver, which may or may not exists 
depending your device. There is a lot of existing tuner driver but 
unfortunately RTL2832U designs uses a lot of new tuners and thus no 
existing drivers for all.

There is no developer working for RTL2832U supports currently AFAIK.

regards
Antti
-- 
http://palosaari.fi/
