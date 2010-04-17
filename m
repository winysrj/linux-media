Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:45124 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0DQH6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 03:58:36 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o3H7wa4C011211
	for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 00:58:36 -0700
Received: from smtp1.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp1.sscnet.ucla.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id upIgiJSdbTne for <linux-media@vger.kernel.org>;
	Sat, 17 Apr 2010 00:58:24 -0700 (PDT)
Received: from smtp5.sscnet.ucla.edu (smtp5.sscnet.ucla.edu [128.97.229.235])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o3H7wK7B011208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 00:58:20 -0700
Received: from weber.sscnet.ucla.edu (weber.sscnet.ucla.edu [128.97.42.3])
	by smtp5.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o3H7wEaA024214
	for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 00:58:14 -0700
Received: from [128.97.221.45] ([128.97.221.45])
	by weber.sscnet.ucla.edu (8.14.2/8.14.2) with ESMTP id o3H7wDCm011036
	for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 00:58:14 -0700 (PDT)
Message-ID: <4BC96A12.2040007@cogweb.net>
Date: Sat, 17 Apr 2010 00:58:10 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: zvbi-atsc-cc device node conflict
References: <4BC8F087.3050805@cogweb.net>	 <u2g829197381004161714z2f0b827eu824a3bcb17d2aa17@mail.gmail.com> <g2w846899811004162344ib3c9223ek8bcef2df83e7f23b@mail.gmail.com>
In-Reply-To: <g2w846899811004162344ib3c9223ek8bcef2df83e7f23b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HoP wrote:
> 2010/4/17 Devin Heitmueller <dheitmueller@kernellabs.com>:
>   
>> On Fri, Apr 16, 2010 at 7:19 PM, David Liontooth <lionteeth@cogweb.net> wrote:
>>     
>>> I'm using a HVR-1850 in digital mode and get good picture and sound using
>>>
>>>  mplayer -autosync 30 -cache 2048 dvb://KCAL-DT
>>>
>>> Closed captioning works flawlessly with this command:
>>>
>>> zvbi-atsc-cc -C test-cc.txt KCAL-DT
>>>
>>> However, if I try to run both at the same time, I get a device node
>>> conflict:
>>>
>>>  zvbi-atsc-cc: Cannot open '/dev/dvb/adapter0/frontend0': Device or resource
>>> busy.
>>>
>>> How do I get video and closed captioning at the same time?
>>>       
>> To my knowledge, you cannot run two userland apps streaming from the
>> frontend at the same time.  Generally, when people need to do this
>> sort of thing they write a userland daemon that multiplexes.
>> Alternatively, you can cat the frontend to disk and then have both
>> mplayer and your cc parser reading the resulting file.
>>
>>     
>
> Usually there is some way, for ex. command line option,
> how to say to "second" app that frondend is already locked.
> Then second app simply skips tuning at all.
>
> Rest processing is made using demux and dvr devices,
> so there is not reason why 2 apps should tune in same
> time.
>
> /Honza
>   
Thanks! I'm trying to create separate recordings of the video/audio file 
on the one hand and the closed captioning on the other.

In one console, I issue
 
  azap -r KOCE-HD

In a second, I issue

  cat /dev/dvb/adapter0/dvr0 > test-cat3.mpeg

I cannot at the same time run this in a third:

  zvbi-atsc-cc -C test-cc.txt KOCE-HD

because of resource conflict.

Using cat works, but how do I get closed captioning from the resulting 
mpeg file?

If I can get that to work, that would be great -- but not particularly 
elegant. Does someone have an example of a multiplexing userland daemon 
that allows me to spit out video to one file and text to another?

Cheers,
Dave




