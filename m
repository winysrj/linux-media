Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62215 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2JEXfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 19:35:38 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so5276215iea.19
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2012 16:35:37 -0700 (PDT)
Message-ID: <1349480071.5069.18.camel@dcky-ubuntu64>
Subject: Re: hvr-1600 fails frequently on multiple recordings
From: Patrick Dickey <pdickeybeta@gmail.com>
Reply-To: pdickeybeta@gmail.com
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Date: Fri, 05 Oct 2012 18:34:31 -0500
In-Reply-To: <k4im62$6tu$1@ger.gmane.org>
References: <k4im62$6tu$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Have you checked on the Ubuntu Forums for any information about this?
There's a thread about 0-byte recordings there, which might have some
solutions for you. I had the same issue with analog recording a while
back, and found that in my case, it was due to having a second hard
drive listed as a storage directory. If the hard drive didn't spin up
quick enough, the recording failed.

Here's a link to the thread on their site:
http://ubuntuforums.org/showthread.php?t=1687846

Hope this helps, and have a great day:)
Patrick.

On Wed, 2012-10-03 at 20:44 -0400, Brian J. Murrell wrote: 
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
> 14f1:5b7a Conexant Systems, Inc. CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast Audio Decoder
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
> 
> Cheers,
> b.
> 

