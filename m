Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:34358 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZH1Kun (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 06:50:43 -0400
Date: Fri, 28 Aug 2009 12:50:27 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-15?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
In-Reply-To: <20090828041459.67c1499a@pedra.chehab.org>
Message-ID: <alpine.LRH.1.10.0908281150120.10085@pub6.ifh.de>
References: <20090827045710.2d8a7010@pedra.chehab.org> <20090827183636.GG26702@sci.fi> <20090827185853.0aa2de76@pedra.chehab.org> <829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com> <20090828004628.06f34d12@pedra.chehab.org>
 <20090828041459.67c1499a@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, 28 Aug 2009, Mauro Carvalho Chehab wrote:

> Em Fri, 28 Aug 2009 00:46:28 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
>
>> So, we need a sort of TODO list for IR changes. A start point (on a random
>> order) would be something like:
>>
>> 2) Implement a v4l handler for EVIOCGKEYCODE/EVIOCSKEYCODE;
>> 3) use a different arrangement for IR tables to not spend 16 K for IR table,
>> yet allowing RC5 full table;
>> 4) Use the common IR framework at the dvb drivers with their own iplementation;
>> 5) Allow getkeycode/setkeycode to work with the dvb framework using the new
>> methods;
>
> Ok, I have a code that handles the above for dvb-usb. Se enclosed. It turned to be
> simpler than what I've expected originally ;)

Yeah, this is due to the nature of modularity of dvb-usb. Saying that, all 
drivers which have (re)implemented IR-handling needs to ported as well. Or 
included in dvb-usb :P .

> Tested with kernel 2.6.30.3 and a dibcom device.
>
> While this patch works fine, for now, it is just a proof of concept, since there are a few
> details to be decided/solved for a version 2, as described bellow.

This is the answer to the question I had several times in the past years.

Very good job. It will solve the memory waste in the driver for 
key-tables filled up with keys for different remotes where the user of 
one board only has one. The code will also be smaller and easier to read.

This also allows the user to use any remote with any (sensitive) 
ir-sensor in a USB device.

Is there a feature in 'input' which allows to request a file (like 
request_firmware)? This would be ideal for a transition from 
in-kernel-keymaps to user-space-keymap-loading: By default it would 
request the file corresponding to the remote delivered with the device.

Is that possible somehow?

Patrick.





