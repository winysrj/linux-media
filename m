Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:33452 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZBILzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 06:55:20 -0500
Date: Mon, 9 Feb 2009 12:54:33 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: =?ISO-8859-15?Q?Michael_M=FCller?= <mueller_michael@alice-dsl.net>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	pboettcher@dibcom.fr, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
Subject: Re: Use ir_keymaps.c for dibcom driver (was: Re: [PATCH] Add Elgato
 EyeTV Diversity to dibcom driver)
In-Reply-To: <77294D52-7BCA-4E11-A589-861692FAA513@alice-dsl.net>
Message-ID: <alpine.LRH.1.10.0902091249420.21232@pub2.ifh.de>
References: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net> <412bdbff0902081100q4e625a59p42cba55d942010bc@mail.gmail.com> <77294D52-7BCA-4E11-A589-861692FAA513@alice-dsl.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579715087-2093192219-1234180473=:21232"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579715087-2093192219-1234180473=:21232
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi,

On Sun, 8 Feb 2009, Michael Müller wrote:
>> While I am indeed strongly in favor of integrating dib0700 with
>> ir_keymaps.c so it is consistent with the other drivers, I have been
>> tied up in another project and haven't had any cycles to do the work
>> required.
>> 
>> By all means, if you want to propose a patch, I would be happy to
>> offer feedback/comments.
>
> Hi Devin,
>
> yes, it was my intention to offer some help.
>
> My hope was to find some similarities that I could use for dibcom. But 
> everything looks different. And they deal with GPIO. So it looks much more 
> complicated than just simply adding some keys to a table. ;-)
>
> Do you have an idea which of the modules listed above is closest to the 
> dibcom module? Can you (easily) create a frame/template that I can use for a 
> start and I add details and does the testing?
>
> Is the existing ir_keymaps approach already able to handle the case that I 
> need to set dvb_usb_dib0700_ir_proto=0 (=> no NEC protocol) for my Elgato?

If you are going to ir_keymap or any other superior solution (which I'm 
for), please don't consider the dib0700-driver only, but think about the 
whole dvb-usb-framework... Only the driver specific part can be found in 
the drivers. The input-stuff is located in dvb-usb-remote.c

Loading the ir-tables from userspace would be the preferred solution, like 
that any IR-receiver on any device could handle any remote-control 
(requiring a generic IR-decoder in the device's firmware) without changing 
the kernel-module-driver...

Is lirc already in-kernel now? Can the event-interface handle raw keys (so 
that a user-space thing could translate them to their real meaning?)

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
--579715087-2093192219-1234180473=:21232--
