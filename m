Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62929 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZH0RGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 13:06:18 -0400
Message-ID: <4A96BD05.1080205@googlemail.com>
Date: Thu, 27 Aug 2009 18:06:13 +0100
From: Peter Brouwer <pb.maillists@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
References: <20090827045710.2d8a7010@pedra.chehab.org>
In-Reply-To: <20090827045710.2d8a7010@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

Hi Mauro, All

Would it be an alternative to let lirc do the mapping and just let the driver 
pass the codes of the remote to the event port.
That way you do not need to patch the kernel for each new card/remote that comes 
out.
Just release a different map file for lirc for the remote of choice.

Peter
> After years of analyzing the existing code and receiving/merging patches
> related to IR, and taking a looking at the current scenario, it is clear to me
> that something need to be done, in order to have some standard way to map and
> to give precise key meanings for each used media keycode found on
> include/linux/input.h.
> 
> Just as an example, I've parsed the bigger keymap file we have
> (linux/media/common/ir-common.c). Most IR's have less than 40 keys, most are
> common between several different models. Yet, we've got almost 500 different
> mappings there (and I removed from my parser all the "obvious" keys that there
> weren't any comment about what is labeled for that key on the IR).
> 
> The same key name is mapped differently, depending only at the wish of the
> patch author, as shown at:
> 
> 	http://linuxtv.org/wiki/index.php/Ir-common.c
> 
> It doesn't come by surprise, but currently, almost all media player
> applications don't care to properly map all those keys.
> 
> I've tried to find comments and/or descriptions about each media keys defined
> at input.h without success. Just a few keys are commented at the file itself.
> (or maybe I've just seek them at the wrong places).
> 
> So, I took the initiative of doing a proposition for standardizing those keys
> at:
> 
> 	http://linuxtv.org/wiki/index.php/Proposal
> 
> While I tried to use the most common binding for a key, sometimes the "commonly
> used" one is so weird that I've used a different key mapping.
> 
> Please, don't take it as a finished proposal. For sure we need to adjust it.
> Being it at wiki provides a way for people to edit, add comments and propose
> additional keycode matches.
> 
> Also, there are several keys found on just one IR that didn't match any existing
> keycode. So, I just decided to keep those outside the table, for now, to focus
> on the mostly used ones.
> 
> That's said, please review my proposal. Feel free to update the proposal and
> the current status if you think it is pertinent for this discussion.
> 
> I'm not currently proposing to create any new keycode, but it probably makes
> sense to create a few ones, like KEY_PIP (for picture in picture).
> 
> If we can go to a common sense, I intend to add it into a chapter at V4L2 API,
> in order to be used by both driver and userspace developers, submit some
> patches to fix some mappings and to add the proper comments to input.h.
> 
> Comments?
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

