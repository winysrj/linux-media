Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45687 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZJ1Qnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 12:43:32 -0400
Received: by ewy4 with SMTP id 4so925777ewy.37
        for <linux-media@vger.kernel.org>; Wed, 28 Oct 2009 09:43:36 -0700 (PDT)
Message-ID: <4AE874AF.5050606@gmail.com>
Date: Thu, 29 Oct 2009 00:43:27 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
CC: linux-media@vger.kernel.org
Subject: Re: saa716x
References: <20091023174502.0608cd4e@rechenknecht2k7> <829197380910230908p733ee69bt79043b78ca5ad81f@mail.gmail.com> <20091028172914.0480e7d1@piBook>
In-Reply-To: <20091028172914.0480e7d1@piBook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benjamin Valentin wrote:
> Am Fri, 23 Oct 2009 12:08:22 -0400
> schrieb Devin Heitmueller <dheitmueller@kernellabs.com>:
> 
> 
>> You cannot use a saa7162 based device with the saa7164 driver.  They
>> chipsets are too dissimilar.
> 
> This was why I tried the saa716x driver [1] that should work for
> saa7160, saa7161 and saa7162 based devices.
> However, after downloading and compiling the driver and loading all
> saa716x_* modules, there was no /dev/dvb nor /dev/video, neither were
> there any messages from saa716x in dmesg (but lsmod did show them up as
> loaded) Despite
> MAKE_ENTRY(NXP_REFERENCE_BOARD, PCI_ANY_ID, SAA7162,&saa716x_atlantis_config)
> should have been true for my card as far as I understand, I've added 
> #define PINNACLE                0x1131
> #define PINNACLE_PCTV_7010IX    0x7162
> 
> MAKE_ENTRY(PINNACLE, PINNACLE_PCTV_7010IX, SAA7162, &saa716x_atlantis_config)
> with no change after repeating the procedure (and unloading the
> saa716x_hybrid module of cause)
> 
> lspci oddly recognizes the board as Pinnacle PCTV 3010iX, which only
> has one tuner module.
> 
> I've included lspci and dmesg output.
> 
> I'm looking forward for someone who could explain what is happening
> here and what I may do about it.
> 
> Best regards
> benjamin
> 
> [1] http://jusst.de/hg/saa716x/
> [2] http://www.computerbase.de/bildstrecke/14665/2/


sorry for forking out another discussion.
I am curious to know the status of saa716x driver, because I have a 
DMB-TH card with saa7160, does it has i2c and TS port working?

regards,
David
