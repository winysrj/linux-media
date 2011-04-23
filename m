Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:55815 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab1DWTwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 15:52:47 -0400
Message-ID: <4DB32DEB.7050801@usa.net>
Date: Sat, 23 Apr 2011 21:52:11 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <201104231940.34575@orion.escape-edv.de> <4DB320EF.3080301@usa.net> <201104232114.31998@orion.escape-edv.de>
In-Reply-To: <201104232114.31998@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23/04/11 21:14, Oliver Endriss wrote:
>>> If you are running 2.6.39rc4, you must apply patch
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg29870.html
>>> Otherwise the data will be garbled.
>> Oliver, this patch was applied already. I'm hacking the ts_read/ts_write
>> method, but so far, haven't manage to get it work.
> Basically you should not have to hack anything.
>
> - Setup the CI as with any conventional device.
> - Write the encrypted stream into sec0.
> - Read the decrypted stream from sec0.
>
> This should work. (Please note that I could do some loopback tests only,
> as I am not watching paytv.)
Oliver,

Is there a preferred way to do this (read/write from sec0) ? I mean, does a

'gnutv -channels file -out stdout  channelname > sec0'

and

'cat sec0 | mplayer -'

should work according to your tests ?
