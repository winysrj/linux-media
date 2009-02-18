Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:49510 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZBRPeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:34:24 -0500
Date: Wed, 18 Feb 2009 09:34:22 -0600
From: David Engel <david@istwok.net>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090218153422.GC15359@opus.istwok.net>
References: <20090217155335.GB6196@opus.istwok.net> <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net> <499B1E19.80302@linuxtv.org> <20090218051945.GA12934@opus.istwok.net> <499C218D.7050406@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C218D.7050406@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2009 at 09:56:13AM -0500, Steven Toth wrote:
>> I then removed the 250 from slot 4 leaving the 115s in slots 1 and 2.
>> The ber was through the roof and the recorded strams were filled with
>> errors and were barely playable at best.
>
> This ^^^^ is bad, you have something wrong with your feeds. They're 
> probably over amp'd and your leaking RF like crazy.
>
> Go back to basics, put the single unsplit and unamped feed into a single 
> 115 and get that working reliably. Then, split (or amp) and try the 
> second 115.
>
> Try to work out what's causing BER to be > 0 and fix that first.
>
> Personally, I wouldn't add the 250/350 back into the system until I had 
> both 115's running flawlessly with 0 BER and 0 UNC.
>
> Chances are, the 250/350 will work correctly after this - unless the 
> drivers really do have a DMA issue. It's too early to say given the 
> BER/UNC issues you're seeing though.

OK.  I've got another window this evening where I can do some testing
without disupting things too much.

David
-- 
David Engel
david@istwok.net
