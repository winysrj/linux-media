Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:33048 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758325AbcIHN7H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 09:59:07 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v3] docs-rst: ignore arguments on macro definitions
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160908084018.492d59bf@vento.lan>
Date: Thu, 8 Sep 2016 15:58:23 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B1CE364F-5026-4CAF-9F57-528D4F3CEB37@darmarit.de>
References: <e4955d6ed9b730f544fe40b0344c4451dd415cda.1472476362.git.mchehab@s-opensource.com> <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de> <20160908084018.492d59bf@vento.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 08.09.2016 um 13:40 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Hi Jon/Markus,
> 
> Em Mon, 29 Aug 2016 16:12:39 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Am 29.08.2016 um 15:13 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>> 
>>> A macro definition is mapped via .. c:function:: at the
>>> ReST markup when using the following kernel-doc tag:
>>> 
>>> 	/**
>>> 	 * DMX_FE_ENTRY - Casts elements in the list of registered
>>> 	 *               front-ends from the generic type struct list_head
>>> 	 *               to the type * struct dmx_frontend
>>> 	 *
>>> 	 * @list: list of struct dmx_frontend
>>> 	 */
>>> 	 #define DMX_FE_ENTRY(list) \
>>> 	        list_entry(list, struct dmx_frontend, connectivity_list)
>>> 
>>> However, unlike a function description, the arguments of a macro
>>> doesn't contain the data type.
>>> 
>>> This causes warnings when enabling Sphinx on nitkpick mode,
>>> like this one:
>>> 	./drivers/media/dvb-core/demux.h:358: WARNING: c:type reference target not found: list  
>> 
>> I think this is a drawback of sphinx's C-domain, using function
>> definition for macros also. From the function documentation
>> 
>> """This is also used to describe function-like preprocessor
>>    macros. The names of the arguments should be given so
>>    they may be used in the description."""
>> 
>> I think about to fix the nitpick message for macros (aka function
>> directive) in the C-domain extension (we already have).
>> 
>> But for this, I need a rule to distinguish between macros
>> and functions ... is the uppercase of the macro name a good
>> rule to suppress the nitpick message? Any other suggestions?
> 
> What's the status of the C domain patches meant to fix this issue?
> 
> I managed to fix most warnings on media documents on nitpick mode.
> With this patch applied, there are only 21 warnings (and all are
> due to the lack of function or struct documentation). I'm about
> to patchbomb such fixup series.
> 
> Yet, without  this patch, and latest docs-next, there are 20 extra
> bogus warnings, due to function parameters:
> 
> ./drivers/media/dvb-core/dvb_ringbuffer.h:121: WARNING: c:type reference target not found: rbuf
> ./drivers/media/dvb-core/dvb_ringbuffer.h:121: WARNING: c:type reference target not found: offs
> ./drivers/media/dvb-core/dvb_ringbuffer.h:130: WARNING: c:type reference target not found: rbuf
> ./drivers/media/dvb-core/dvb_ringbuffer.h:130: WARNING: c:type reference target not found: num
> ./drivers/media/dvb-core/dvb_ringbuffer.h:173: WARNING: c:type reference target not found: rbuf
> ./drivers/media/dvb-core/dvb_ringbuffer.h:173: WARNING: c:type reference target not found: byte
> ./drivers/media/dvb-core/demux.h:358: WARNING: c:type reference target not found: list
> ./include/media/media-device.h:263: WARNING: c:type reference target not found: mdev
> ./include/media/media-device.h:495: WARNING: c:type reference target not found: mdev
> ./include/media/media-device.h:495: WARNING: c:type reference target not found: udev
> ./include/media/media-device.h:495: WARNING: c:type reference target not found: name
> ./include/media/media-entity.h:527: WARNING: c:type reference target not found: gobj
> ./include/media/media-entity.h:536: WARNING: c:type reference target not found: gobj
> ./include/media/media-entity.h:545: WARNING: c:type reference target not found: gobj
> ./include/media/media-entity.h:554: WARNING: c:type reference target not found: gobj
> ./include/media/media-entity.h:563: WARNING: c:type reference target not found: intf
> ./include/media/media-entity.h:1041: WARNING: c:type reference target not found: entity
> ./include/media/media-entity.h:1041: WARNING: c:type reference target not found: operation
> ./include/media/v4l2-ctrls.h:397: WARNING: c:type reference target not found: hdl
> ./include/media/v4l2-ctrls.h:397: WARNING: c:type reference target not found: nr_of_controls_hint
> 
> So, it would be great if we could either merge this patch or the ones that
> Markus did (assuming they're ready for merge).

I fixed the remarks of Jon and resend v2 yesterday ...

https://www.mail-archive.com/linux-media@vger.kernel.org/msg102259.html

sorry, I'am currently in a hurry, may do you like to test the
patch, to see if we get rid of those 20 extra bogus warnings?

Thanks!

-- Markus --


