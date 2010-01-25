Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0AYTs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 14:48:26 -0500
Message-ID: <4B5DF582.1080602@infradead.org>
Date: Mon, 25 Jan 2010 17:48:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: git problem with uvcvideo
References: <4B5CBC31.5090701@freemail.hu> <201001251907.18266.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201001251907.18266.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Márton,
> 
> On Sunday 24 January 2010 22:31:29 Németh Márton wrote:
>> Hi,
>>
>> I'm trying to fetch the uvcvideo from
>>  http://linuxtv.org/git/?p=pinchartl/uvcvideo.git;a=summary .
>>
>> I tryied to follow the instructions but at the third step I get fatal error
>> messages:
> 
> [snip]
> 
> The http:// URL seems not to be available at the moment. I don't know if it's 
> a transient error or a deliberate decision not to provide git access through 
> http://

No, it is not a decision. However, using http for -git has some issues.

>> I also tried with the git:// link:
>>> v4l-dvb$ git remote rm uvcvideo
>>> v4l-dvb$ git remote add uvcvideo git://linuxtv.org//pinchartl/uvcvideo.git
>>> v4l-dvb$ git remote update
>>> Updating origin
>>> Updating uvcvideo
>>> fatal: The remote end hung up unexpectedly
>>> error: Could not fetch uvcvideo
>> Am I doing something wrong?
> 
> Please try git://linuxtv.org/pinchartl/uvcvideo.git. The URL on the webpage 
> has two / instead of one for some reason. Mauro, could that be fixed ?

The double bars were causing troubles with the git: url. 
I've fixed it at gitweb.

The git URL is working fine:

$ git clone -l --bare /git/linux-2.6.git/ uvcvideo && cd uvcvideo && git remote add uvcvideo git://linuxtv.org/pinchartl/uvcvideo.git && git remote update
Initialized empty Git repository in /home/mchehab/tst/uvcvideo/
Updating uvcvideo
remote: Counting objects: 1944, done.
remote: Compressing objects: 100% (427/427), done.
remote: Total 1733 (delta 1486), reused 1551 (delta 1306)
Receiving objects: 100% (1733/1733), 312.46 KiB, done.
Resolving deltas: 100% (1486/1486), completed with 169 local objects.
>From git://linuxtv.org/pinchartl/uvcvideo
 * [new branch]      master     -> uvcvideo/master
 * [new branch]      uvcvideo   -> uvcvideo/uvcvideo

However, the html URL is currently broken:

$ rm -rf uvcvideo/ && git clone -l --bare /git/linux-2.6.git/ uvcvideo && cd uvcvideo && git remote add uvcvideo http://linuxtv.org/git/pinchartl/uvcvideo.git && git remote update 
Initialized empty Git repository in /home/mchehab/tst/uvcvideo/uvcvideo/
Updating uvcvideo

Probably, the rewrite rules at the server for http are incomplete. I'll see if I can fix it.

cheers,
Mauro.
