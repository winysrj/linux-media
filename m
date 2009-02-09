Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110807.mail.gq1.yahoo.com ([67.195.13.230]:35845 "HELO
	web110807.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753826AbZBIHWQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 02:22:16 -0500
Date: Sun, 8 Feb 2009 23:22:14 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Reply-To: urishk@yahoo.com
Subject: Re: Use ir_keymaps.c for dibcom driver (was: Re: [PATCH] Add Elgato EyeTV Diversity to dibcom driver)
To: Devin Heitmueller <devin.heitmueller@gmail.com>,
	=?iso-8859-1?Q?Michael_M=FCller?= <mueller_michael@alice-dsl.net>
Cc: Patrick Boettcher <patrick.boettcher@desy.de>,
	pboettcher@dibcom.fr, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
In-Reply-To: <77294D52-7BCA-4E11-A589-861692FAA513@alice-dsl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <563080.66101.qm@web110807.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sun, 2/8/09, Michael Müller <mueller_michael@alice-dsl.net> wrote:

> From: Michael Müller <mueller_michael@alice-dsl.net>
> Subject: Use ir_keymaps.c for dibcom driver (was: Re: [PATCH] Add Elgato EyeTV Diversity to dibcom driver)
> To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
> Cc: "Patrick Boettcher" <patrick.boettcher@desy.de>, pboettcher@dibcom.fr, linux-dvb@linuxtv.org, linux-media@vger.kernel.org
> Date: Sunday, February 8, 2009, 11:07 PM
> Am 08.02.2009 um 20:00 schrieb Devin Heitmueller:
> 
> > On Sun, Feb 8, 2009 at 1:51 PM, Michael Müller
> > <mueller_michael@alice-dsl.net> wrote:
> >> In December you wrote that you 'should work on
> getting the dib0700 driver
> >> integrated with ir_keymaps.c so that the it is
> consistent with other
> >> drivers.' Did you already started to work on
> this? Should I change my patch
> >> to use the ir_keymaps.c way? Which driver is a
> good example how to use it?
> >> 
> >> Regards
> >> 
> >> Michael
> > 
> > Hello Michael,
> > 
> > While I am indeed strongly in favor of integrating
> dib0700 with
> > ir_keymaps.c so it is consistent with the other
> drivers, I have been
> > tied up in another project and haven't had any
> cycles to do the work
> > required.
> > 
> > By all means, if you want to propose a patch, I would
> be happy to
> > offer feedback/comments.
> 
> Hi Devin,
> 
> yes, it was my intention to offer some help.
> 
> I had a first look into the existing codes that seem to use
> ir_keymaps.c already (I searched for ir_input_init()):
> dvb/ttpci/budget-ci.c
> video/bt8xx/bttv-input.c
> video/cx88/cx88-input.c
> video/em28xx/em28xx-input.c
> video/ir-kbd-i2c.c
> video/saa7134/saa7134-input.c
> 
> My hope was to find some similarities that I could use for
> dibcom. But everything looks different. And they deal with
> GPIO. So it looks much more complicated than just simply
> adding some keys to a table. ;-)
> 
> Do you have an idea which of the modules listed above is
> closest to the dibcom module? Can you (easily) create a
> frame/template that I can use for a start and I add details
> and does the testing?
> 
> Is the existing ir_keymaps approach already able to handle
> the case that I need to set dvb_usb_dib0700_ir_proto=0
> (=> no NEC protocol) for my Elgato?
> 
> From a structure point of view wouldn't it be better if
> we would collect the different keytabs in different files
> for each driver? If all keymaps are collected in a single
> file you would always load the full set of keymaps into the
> memory (and if a dvb module is compiled into the kernel
> stored in the kernel binary).
> 
> Regards
> 
> Michael--
> To unsubscribe from this list: send the line
> "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html

May I suggest one more input...

There is SMS (Siano's based DTV devices) IR driver.

It's not on the main Mercurial (from one reason or another all SMS patches that have been submitted since August 08 are queued) but you can get it by taking the patches from the "vger"  list.

Currently it use its own keymaps, since the "ir_keymaps" and "ir_common" modules are not so common....

The main problem with the currently "common" driver that it mixes hardware (GPIO, timer base reading) with the truly common RC5 parsing and keymaps functionality.
Since the SMS driver needs only the parser and the keymaps (hardware reading is done in a totally different way from the method that is used by "ir_common"), it will be great if the common IR handling will have single interface such as 'ir_received_input(device *dev, u16 ir_word)', where ir_word is the raw 28 bit.

Hope to get your opinions on this issue,

Uri Shkolnik





      
