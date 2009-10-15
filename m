Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59674 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760200AbZJOPyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 11:54:12 -0400
Received: by fxm27 with SMTP id 27so1272005fxm.17
        for <linux-media@vger.kernel.org>; Thu, 15 Oct 2009 08:53:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909281909.15028.opensource@andmarios.com>
References: <200909281850.25492.opensource@andmarios.com>
	 <829197380909280856j42f37b66rf99ddaaad836461e@mail.gmail.com>
	 <200909281909.15028.opensource@andmarios.com>
Date: Thu, 15 Oct 2009 11:53:35 -0400
Message-ID: <829197380910150853l6797a053qd2d9e05ec3b7552e@mail.gmail.com>
Subject: Re: [linux-dvb] KWORLD 323U, kernel panic when trying to access ALSA
	interface
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Marios Andreopoulos <opensource@andmarios.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/28 Marios Andreopoulos <opensource@andmarios.com>:
> On Monday 28 of September 2009, Devin Heitmueller wrote:
>>
>> Hello Marios,
>>
>> I started doing some debugging em28xx audio on the HVR-950 and hit
>> what is probably the same panic (which occurs as soon as you run the
>> arecord command).  I've got a stack dump and am actively debugging the
>> issue.
>>
>> It seems that a regression has been recently introduced.
>>
>> Devin
>>
>>
>
> If there is any way I can help please let me know.
> I do not know much about developing or debugging software but I believe I'm able to follow instructions to get a dump or do some trials if there is a need.
>
> Thanks for the really quick reply,
> Marios

Hello Marios,

Sorry about the extended delay on this.  Please try out the following
tree and see if you still hit a panic:

http://www.kernellabs.com/hg/~dheitmueller/em28xx-audio-panic

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
