Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:39662 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZBHVWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2009 16:22:44 -0500
In-Reply-To: <412bdbff0902081100q4e625a59p42cba55d942010bc@mail.gmail.com>
References: <B7621984-DEB8-4F0C-B5EF-733CD30E7441@alice-dsl.net> <412bdbff0902081100q4e625a59p42cba55d942010bc@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <77294D52-7BCA-4E11-A589-861692FAA513@alice-dsl.net>
Cc: Patrick Boettcher <patrick.boettcher@desy.de>,
	pboettcher@dibcom.fr, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?Michael_M=FCller?= <mueller_michael@alice-dsl.net>
Subject: Use ir_keymaps.c for dibcom driver (was: Re: [PATCH] Add Elgato EyeTV Diversity to dibcom driver)
Date: Sun, 8 Feb 2009 22:07:58 +0100
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 08.02.2009 um 20:00 schrieb Devin Heitmueller:

> On Sun, Feb 8, 2009 at 1:51 PM, Michael Müller
> <mueller_michael@alice-dsl.net> wrote:
>> In December you wrote that you 'should work on getting the dib0700  
>> driver
>> integrated with ir_keymaps.c so that the it is consistent with other
>> drivers.' Did you already started to work on this? Should I change  
>> my patch
>> to use the ir_keymaps.c way? Which driver is a good example how to  
>> use it?
>>
>> Regards
>>
>> Michael
>
> Hello Michael,
>
> While I am indeed strongly in favor of integrating dib0700 with
> ir_keymaps.c so it is consistent with the other drivers, I have been
> tied up in another project and haven't had any cycles to do the work
> required.
>
> By all means, if you want to propose a patch, I would be happy to
> offer feedback/comments.

Hi Devin,

yes, it was my intention to offer some help.

I had a first look into the existing codes that seem to use  
ir_keymaps.c already (I searched for ir_input_init()):
dvb/ttpci/budget-ci.c
video/bt8xx/bttv-input.c
video/cx88/cx88-input.c
video/em28xx/em28xx-input.c
video/ir-kbd-i2c.c
video/saa7134/saa7134-input.c

My hope was to find some similarities that I could use for dibcom.  
But everything looks different. And they deal with GPIO. So it looks  
much more complicated than just simply adding some keys to a table. ;-)

Do you have an idea which of the modules listed above is closest to  
the dibcom module? Can you (easily) create a frame/template that I  
can use for a start and I add details and does the testing?

Is the existing ir_keymaps approach already able to handle the case  
that I need to set dvb_usb_dib0700_ir_proto=0 (=> no NEC protocol)  
for my Elgato?

 From a structure point of view wouldn't it be better if we would  
collect the different keytabs in different files for each driver? If  
all keymaps are collected in a single file you would always load the  
full set of keymaps into the memory (and if a dvb module is compiled  
into the kernel stored in the kernel binary).

Regards

Michael