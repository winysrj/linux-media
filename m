Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1CXR3U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 13:29:20 -0400
Message-ID: <4D8B7F68.8050209@redhat.com>
Date: Thu, 24 Mar 2011 14:29:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] ignore Documentation/DocBook/media/
References: <4D80C7BD.3030704@matrix-vision.de> <4D8B6475.6030707@matrix-vision.de>
In-Reply-To: <4D8B6475.6030707@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-03-2011 12:34, Michael Jones escreveu:
> On 03/16/2011 03:22 PM, Michael Jones wrote:
>> >From 81a09633855b88d19f013d7e559e0c4f602ba711 Mon Sep 17 00:00:00 2001
>> From: Michael Jones <michael.jones@matrix-vision.de>
>> Date: Thu, 10 Mar 2011 16:16:38 +0100
>> Subject: [PATCH] ignore Documentation/DocBook/media/
>>
>> It is created and populated by 'make htmldocs'
>>
>>
>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
>> ---
>>  Documentation/DocBook/.gitignore |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/.gitignore b/Documentation/DocBook/.gitignore
>> index c6def35..679034c 100644
>> --- a/Documentation/DocBook/.gitignore
>> +++ b/Documentation/DocBook/.gitignore
>> @@ -8,3 +8,4 @@
>>  *.dvi
>>  *.log
>>  *.out
>> +media/
> 
> In general, where do patches on this list land?  On
> http://linuxtv.org/wiki/index.php/Developer_Section
> the link to "Current git log" is broken.  The link to 'Git V4L-DVB
> development repository' is v4l-dvb.git which is suspiciously inactive:
> 2.6.37-rc8, from 2 months ago.  Judging by the activity level, I guess
> that patches from this mailing list currently land in branch
> 'staging/for_v2.6.39' of 'http://git.linuxtv.org/media_tree.git'?

Yes, that's true (and, probably on next week, it will be at the branch
staging/for_v2.6.40 of the same git tree).

If you see anything pointing to the wrong place, please help us fixing it,
by editing our wiki or sending us patches.

> And what's the destiny of this patch in particular?  It doesn't seem to
> have even been picked up by patchwork.

Patchwork is subscribed at the linux-media ML. So, every email sent to the
ML are analyzed and, if it looks like a patch, it will catch it.

If your patch weren't caught, then one of the following things happened:
	1) Patch was broken. Some emailers love to break patches by mangling
	   whitespaces/tabs;
	2) The patch is not inlined, but, instead, it is on a mime message,
and the patch has a wrong mime type (the right type is text/x-patch). If the
attachment type is text/plain, patchwork will try to get a patch there using
some euristics. If the mime type is application/binary (as some really bad
non-Linux emailers do), the patch will be silently discarded, as patchwork
doesn't know how to handle a binary blob;
	3) Some bug at patchwork;
	4)The email were not received by patchwork.kernel.org.

Your patch seems correct, so it is probably (3) or (4). One of the common issues
for (3) is python bad habit of aborting scripts if they contain a character
upper than 127 and the codeset is wrong. 

Just try to re-send it to the ML and see if Patchwork will catch.

Cheers,
Mauro
