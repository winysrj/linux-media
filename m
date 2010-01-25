Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:63855 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab0AYTx7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 14:53:59 -0500
Message-ID: <4B5DF6C3.3010108@freemail.hu>
Date: Mon, 25 Jan 2010 20:53:39 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
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
> 
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

It seems removing the extra '/' helps:

v4l-dvb$ git remote rm uvcvideo
v4l-dvb$ git remote add uvcvideo git://linuxtv.org/pinchartl/uvcvideo.git
v4l-dvb$ git remote update
Updating origin
Updating uvcvideo
remote: Counting objects: 1944, done.
remote: Compressing objects: 100% (427/427), done.
remote: Total 1733 (delta 1486), reused 1551 (delta 1306)
Receiving objects: 100% (1733/1733), 312.47 KiB | 164 KiB/s, done.
Resolving deltas: 100% (1486/1486), completed with 169 local objects.
>From git://linuxtv.org/pinchartl/uvcvideo
 * [new branch]      master     -> uvcvideo/master
 * [new branch]      uvcvideo   -> uvcvideo/uvcvideo
v4l-dvb$ git branch -r
  origin/HEAD -> origin/master
  origin/master
  uvcvideo/master
  uvcvideo/uvcvideo
v4l-dvb$ git checkout -b test uvcvideo/uvcvideo
Branch test set up to track remote branch uvcvideo from uvcvideo.
Switched to a new branch 'test'


Now I can start to build and test this branch.

Regards,

	Márton Németh


