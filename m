Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35478 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab2JDOSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 10:18:21 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1020973iea.19
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2012 07:18:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506D79DE.3040403@interlinx.bc.ca>
References: <506D79DE.3040403@interlinx.bc.ca>
Date: Thu, 4 Oct 2012 10:18:21 -0400
Message-ID: <CAGoCfixs4QEYO+B7JgGYaENzxfAzZ3OXTBxQ+4VyHVjaveu7Gw@mail.gmail.com>
Subject: Re: hvr-1600 fails frequently on multiple recordings
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 4, 2012 at 7:58 AM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> I have a fairly new HVR-1600 which I have seen fail quite a number of
> times now when it's asked to record more than one channel on a clearqam
> multiplex.  This time it was 3 recordings at once.
>
> There's nothing at all in the kernel ring buffer, just mythtv reports a
> failed recording.  Usually one of the files being recorded to will only
> be 376 bytes long and the rest will be 0 bytes.
>
> I am running ubuntu's 3.2.0-27-generic kernel with what looks like a
> 1.5.1 cx18 driver.  The card is either a:
>
> 14f1:5b7a Conexant Systems, Inc. CX23418 Single-Chip MPEG-2 Encoder with
> Integrated Analog Video/Broadcast Audio Decoder
>
> or a:
>
> 4444:0016 Internext Compression Inc iTVC16 (CX23416) Video Decoder (rev 01)
>
> Sorry.  I don't recall which is which any more.
>
> But I really need to figure this out since failed recordings is causing
> all kinds of disappointment around here.  I'm really at the end of my
> rope with it.
>
> Tomorrow morning I am going to demote this card to secondary duty and
> promote my HVR-950Q to primary duty since I never had this kind of
> grief with it.  But even in secondary duty, it could very well be
> called upon to record multiple clearqam channels simultaneously so I
> would really like to get this figured out.
>
> Any ideas?

I think the real question at this point is: what version of MythTV are
you running?  I've seen so many reports recently of breakage in the
MythTV codebase related to recording, I am almost inclined to demand
you reproduce it outside of MythTV before we even spend any time
talking about it.

Also, has anything changed in your environment?  Was it working
before, and then you upgraded the kernel or Myth, and now it's not
working?  Or has there been a consistent pattern of failure over some
extended period of time?

The cx18 driver has changed very little as of late - the MythTV
codebase has changed heavily and people are all over the place
complaining about breakage.

I'm not trying to get into the finger-pointing game, but I just want
to better understand the history/background before I can make any
recommendations.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
