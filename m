Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:55795 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3AGUOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 15:14:06 -0500
Received: by mail-bk0-f49.google.com with SMTP id jm19so8844026bkc.36
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 12:14:04 -0800 (PST)
Message-ID: <1357589638.4360.14.camel@canaries64>
Subject: Re: [PATCH] usb id addition for Terratec Cinergy T Stick Dual rev. 2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Damien Bally <biribi@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Date: Mon, 07 Jan 2013 20:13:58 +0000
In-Reply-To: <50EB2405.80309@iki.fi>
References: <5064A3AD.70009@free.fr> <5064ABD2.2060106@iki.fi>
	 <5065D1AC.5030800@free.fr> <5065E487.80502@iki.fi>
	 <1348860617.2782.26.camel@Route3278> <20120929143305.4859603e@redhat.com>
	 <50688332.7020406@free.fr> <20121001081540.69bdae23@redhat.com>
	 <50697CBE.8060001@iki.fi> <20121006124020.2cc2f534@redhat.com>
	 <50EB2405.80309@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2013-01-07 at 21:37 +0200, Antti Palosaari wrote:
> On 10/06/2012 06:40 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 01 Oct 2012 14:21:34 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> On 10/01/2012 02:15 PM, Mauro Carvalho Chehab wrote:
> >>> Em Sun, 30 Sep 2012 19:36:50 +0200
> >>> Damien Bally <biribi@free.fr> escreveu:
> >>>
> >>>>
> >>>>
> >>>> Le 29/09/2012 19:33, Mauro Carvalho Chehab a écrit :
> >>>>     It seems that the it931x variant has bcdDevice equal to 2.00,
> >>>>> from Damien's email:
> >>>>>
> >>>>>       idVendor           0x0ccd TerraTec Electronic GmbH
> >>>>>       idProduct          0x0099
> >>>>>       bcdDevice            2.00
> >>>>>       iManufacturer           1 ITE Technologies, Inc.
> >>>>>       iProduct                2 DVB-T TV Stick
> >>>>>       iSerial                 0
> >>>>>
> >>>>> If the af9015 variant uses another bcdDevice, the fix should be simple.
> >>>>
> >>>> Alas, according to
> >>>> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_Dual_RC the
> >>>> af9015 variant appears to have the same bcdDevice. I join both lsusb
> >>>> outputs for comparison.
> >>>
> >>> Well, then the alternative is to let both drivers to handle this USB ID,
> >>> and add a code there on each of them that will check if the device is the
> >>> right one, perhaps by looking at iProduct string. If the driver doesn't
> >>> recognize it, it should return -ENODEV at .probe() time. The USB core will
> >>> call the second driver.
> >>
> >> It is the easiest solution, but there should be very careful. Those
> >> strings could change from device to device. I used earlier af9015 eeprom
> >> hash (those string as coming from the eeprom) to map TerraTec dual
> >> remote controller and git bug report quite soon as it didn't worked.
> >> After I looked the reason I found out they was changed some not
> >> meaningful value.
> >
> > Yeah, those strings can change, especially when vendors don't care enough
> > to use a different USB ID/bcdDevice for different models. Yet, seems to
> > be the cleaner approach, among the alternatives.
> 
> Damien, care to test?
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_tuner
> 
> I split tuner out from IT9135 driver and due to that AF9035 driver 
> supports IT9135 too (difference between AF9035 and IT9135 is integrated 
> RF-tuner). I added iManufacturer based checks for both AF9015 and AF9035 
> drivers

I can't see the point of adding this to the af9035/af9033 driver. It is
going to turn into one enormous blob.

The it913x is a stable driver and has it own entity moving forward.

The only thing that needs to happen is the id is added to it913x driver
and if it doesn't apply drop it.

Nack.


Regards


Malcolm

