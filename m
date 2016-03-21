Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45829 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbcCUKif (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 06:38:35 -0400
Subject: Re: cron job: media_tree daily build: OK
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20160321040508.0C6691800EC@tschai.lan>
 <20160321065708.281a4aa4@recife.lan>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56EFCF26.3030709@xs4all.nl>
Date: Mon, 21 Mar 2016 11:38:30 +0100
MIME-Version: 1.0
In-Reply-To: <20160321065708.281a4aa4@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 10:57 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 21 Mar 2016 05:05:07 +0100
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
> 
>> This message is generated daily by a cron job that builds media_tree for
>> the kernels and architectures in the list below.
>>
>> Results of the daily build of media_tree:
>>
>> date:		Mon Mar 21 04:00:22 CET 2016
>> git branch:	test
>> git hash:	b39950960d2b890c21465c69c7c0e4ff6253c6b5
>> gcc version:	i686-linux-gcc (GCC) 5.3.0
>> sparse version:	v0.5.0-56-g7647c77
>> smatch version:	Warning: /share/smatch/smatch_data/ is not accessible.
>> Use --no-data or --data to suppress this message.
>> v0.5.0-3353-gcae47da
> 
> Not sure how you're running smatch, but what I do here is to run
> it as:
> 	/<smatch_dir>/smatch
> 
> This way, it finds the smatch_data dir at /<smatch_dir, with also
> suppress several false positive error messages from the smatch logs.
> 
> As a side effect, it simplifies a little bit the procedure to update
> smatch's version.

It was a botched smatch install. It should be OK for the next build.

Thanks for noticing this!

	Hans

