Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:43460 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZIRHQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 03:16:34 -0400
Received: by bwz6 with SMTP id 6so507100bwz.37
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 00:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090918021141.2819e380@pedra.chehab.org>
References: <829197380909172140q124ce047nd45ad5d64b155fb3@mail.gmail.com>
	 <20090918021141.2819e380@pedra.chehab.org>
Date: Fri, 18 Sep 2009 03:16:36 -0400
Message-ID: <829197380909180016u16c1cb0am6f0c0ada1578bcfe@mail.gmail.com>
Subject: Re: Media Controller initial support for ALSA devices
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 18, 2009 at 1:11 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Fri, 18 Sep 2009 00:40:34 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
>
>> Hello Hans,
>>
>> If you can find a few minutes, please take a look at the following
>> tree, where I added initial support for including the ALSA devices in
>> the MC enumeration.  I also did a bit of cleanup on your example tool,
>> properly showing the fields associated with the given node type and
>> subtype (before it was always showing fields for the V4L subtype).
>>
>> http://kernellabs.com/hg/~dheitmueller/v4l-dvb-mc-alsa/
>>
>> I've implemented it for em28xx as a prototype, and will probably see
>> how the code looks when calling it from au0828 and cx88 as well (to
>> judge the quality of the abstraction).
>>
>> Comments welcome, of course...
>
> How do you expect that em28xx devices using snd-usb-audio to be enumerated?

There are two basic issues your question raises:

1.  Finding the correct ALSA device:  I wrote some code a few weeks
ago that does it by enumerating through the sound card entries and
digging through the usb interface pointers to find the one that
matches.  I'm just not happy with the code yet and wasn't ready to
show it to anybody.  I've got the same basic issue with au0828, and
I've been thinking about it for a while.  Certainly the cases where we
have vendor audio or DMA audio for PCI devices are much more
straightforward.

2.  The second issue has to do with the loading sequence.  Because
each interface is bound separately, I'm not confident I can setup the
alsa device so early in the process, since in the case of the
snd-usb-audio the driver hasn't been initialized against the device
yet.  I'm still trying to work out the optimal scheme for this - for
example perhaps waiting until the media controller is opened for the
first time before doing the lookup.

In short, I am certainly aware of both issues and am actively working
on finding an optimal solution.  Either way though, the prototype code
is good enough for us to start exercising the userland interface and
evaluate how well it will integrate into applications for common use
cases.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
