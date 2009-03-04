Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:48329 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZCDXNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 18:13:10 -0500
Date: Wed, 4 Mar 2009 17:25:32 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to gspca, to support SQ905C cameras.
In-Reply-To: <20090304155153.35c58fc0@pedra.chehab.org>
Message-ID: <alpine.LNX.2.00.0903041706530.23054@banach.math.auburn.edu>
References: <20090212121348.49eab19a@free.fr> <alpine.LNX.2.00.0903031328290.21047@banach.math.auburn.edu> <20090304155153.35c58fc0@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Mar 2009, Mauro Carvalho Chehab wrote:

> On Tue, 3 Mar 2009 13:54:59 -0600 (CST)
> kilgota@banach.math.auburn.edu wrote:
>
>> The SQ905C cameras (0x2770:0x905C) cameras, as well as two other closely
>> related varieties (0x2770:0x9050 and 0x2770:0x913D) are supported in what
>> follows.
>
> Please check your patch with checkpatch.pl. There are lots of troubles, maybe
> some introduced by your emailer, since you have tons of whitespace issues.

OK, I will try it again in a following message, having gone through and 
checked everything, according to your suggestions. However, there was one 
thing which left me puzzled. It is the following:

I did the checkpatch.pl thing at the office, before coming home. It 
showed that I was overconfident in my ability to produce clean code. 
However, there was also a more serious problem.

In addition to finding whitespace issues, etc. checkpatch.pl said that the 
patch was corrupted. And it was. When I tried to apply it to a copy of 
J-F Moine's tree at the office, it would not apply, but instead gave me 
errors and rejects.

I am a bit puzzled by that, because this patch was applied at home and 
there were no such complaints. All I did was to send it to the office, 
using scp. So I have no clue where *that* problem came from. Therefore, in 
case that such a problem reoccurs, could I kindly ask permission in 
advance to do something like gzip the patch file and send it as an 
attachment? I really do not understand how that part of the problem could 
have happened. The mailer had nothing to do with it. I was merely 
working with the same file that I sent over to the office via scp, which 
had not been mailed to anybody at all.

Naturally, I will send the revised file in the regular way, in the body of 
an e-mail message, first. But please let me know if there is such a 
problem again.

Theodore Kilgore
