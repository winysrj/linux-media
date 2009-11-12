Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:43993 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZKLTdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 14:33:09 -0500
Received: by ywh40 with SMTP id 40so615465ywh.33
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 11:33:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091112173130.GV31295@www.viadmin.org>
References: <20091112173130.GV31295@www.viadmin.org>
Date: Thu, 12 Nov 2009 14:27:23 -0500
Message-ID: <829197380911121127j19040ca8t7725ff26b164535e@mail.gmail.com>
Subject: Re: Organizing ALL device data in linuxtv wiki
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 12, 2009 at 12:31 PM, H. Langos <henrik-dvb@prak.org> wrote:
> Hi there,
>
> Like most wikis of the linuxtv wiki is plagued with duplicate
> and out-of-sync information. It is most apparent for devices,
> their features, their hardware, and most of all their status
> in regard to linux support.
>
> If you need an example of the mess take a look at
> http://www.linuxtv.org/wiki/index.php/TerraTec or
> http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards
> and try to find devices where the information on the
> page is consistent with the information on the device
> specific page.
>
> I've collected and concentrated data on about 150 devices
> (mostly DVB-T USB) in one place and experimented a lot
> with "wiki template voodoo". The result is a kind of minimalistic
> database application within the wiki (retaining the advantages
> of the wiki, like mature history and undo function,
> low entry threshold for new users....)
>
> Having _one_ article that holds the data means that there is
> just one place to update and maintain while the information
> can be shown in lots of articles (or inside the same article
> with different levels of detail).
>
> That article can be thought of as one big table with columns
> for attributes and rows for devices.
>
> Selection of columns is done by choosing the appropriate
> table templates (there are currently three different ones
> for different levels of detail).
>
> Selection of rows is done by passing selection
> attributes and selection values.
>
>
> It is roughly the equivalent of this sql statement:
>  SELECT a1,a2,a3... FROM datatemplate
>  [ WHERE s1 LIKE '%v1%' [ AND s2 LIKE '%v2%'
>    [AND s3 LIKE '%v3%' [AND s4 LIKE '%v4%' ]]]];
>
>
> Recently I expanded the "database schema" to contain
> the host interface(s) and the supported broadcasting standard(s).
> This way the same infrastructure can be used to hold information
> on anything from PCIe DVB-S2 to ISA NTSC devices and even
> fm radio devices.
>
> The current "database schema" is documented in
> http://www.linuxtv.org/wiki/index.php/Template:DVB-T_USB_Devices_ListData#Syntax_and_Semantics
>
> It is still geared towards DVB-T USB devices but I am sure
> it can be expanded/modified with little effort to support
> other types of hardware with the level of detail needed.
>
> What I'd like to get is
>
> A) Some feedback from users and developers in regard to
>   additional attributes needed or attributes (or
>   values) that can be merged.
>
>   E.g. I don't have a clue
>   * if satelite receivers have special attributes, or
>   * if ANALOG-PAL /-NTSC /-SECAM should be listed separately or
>   * if it would make sense to include links from a device
>   straight to the linux kernel's driver blob via
>   kernel.org's gitweb.
>
>   Please, keep in mind that the table is not there
>   to replace device specific pages with all their
>   detail but definetly should be part of the device's
>   page.
>
> B) Ideas about how to handle oem devices (clones). My
>   idea is to include them with just the "vendor" and
>   "device" attribute (so that users can easily find the
>   device in the table looking for the vendor) and to
>   use the "supported" attribute to indicate that this
>   device is just a clone of some other device. Problem
>   here is that you can't really link to that other
>   device directly or use data from that other device.
>   (Sorry, no sql JOIN operation on tables :-))
>
>
> Here are some examples of stuff that already works:
>
> Differnet views on same device in one article.
>
>  http://www.linuxtv.org/wiki/index.php/MSI_DigiVox_mini_II_V3.0
>  http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_nano_Stick_(73e)
>
>
> Selection on demodulator af9015
>
>  http://www.linuxtv.org/wiki/index.php/Afatech_AF9015
>
>
> Selection on hostinterface USB and stadard DVB-T
> (still a rather messy page as lots of old devices still
> need to be merged/moved into the "database")
>
>  http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices
>
>
> Some more examples and experiments:
>
>  http://www.linuxtv.org/wiki/index.php/HLPlayground2
>  http://www.linuxtv.org/wiki/index.php/HLPlayground2/doubleselection
>
>
> I hope the outlook of having just one place to update
> will inspire and motivate developers and wiki users alike
> to keep information on their device/driver up to date.
>
> cheers
> -henrik

Hello Henrik,

I have to wonder if maybe we are simply using the wrong tool for the
job.  Perhaps it would make sense to make a really simple web frontend
to a simple database for devices.  At least initially it would only
really need two tables.  Something along the lines of the following

VENDOR_TABLE
  int     vendor_id (index)
  text   vendor name

PRODUCT_TABLE
  int    product_id (index)
  text  product_name
  int    bus_type (0=usb, 1=pci, 2=pcie)
  text   usb id
  text   pci id
  int   vendor_id (links to vendors table)
  text  full_article_page_url
  bool  hardware_supports_dvb_t
  bool  hardware_supports_dvb_c
  bool  hardware_supports_atsc
  bool  hardware_supports_qam256
  bool  hardware_supports_pal
  bool  hardware_supports_ntsc
  bool  hardware_has_mpeg_decoder
  bool  hardware_has_ir
  bool  linux_supports_dvb_t
  bool  linux_supports_dvb_c
  bool  linux_supports_atsc
  bool  linux_supports_qam256
  bool  linux_supports_pal
  bool  linux_supports_ntsc
  bool  linux_has_mpeg_decoder
  bool  linux_has_ir

A simple db frontend like the above would allow users to search on
most of the relevant properties they care about (seeing all devices by
a single manufacturer, looking up devices by USB ID or PCI ID, looking
for devices that support a certain standard, etc)

I feel like the freeform nature of wikis just lends to the information
not being in a structured manner.  I don't doubt that a wiki can be
mangled to do something like this, but a real database seems like such
a cleaner alternative.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
