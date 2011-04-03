Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab1DCNk5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2011 09:40:57 -0400
Message-ID: <4D9878E1.7060603@redhat.com>
Date: Sun, 03 Apr 2011 10:40:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Debug code in HG repositories
References: <201101072053.37211@orion.escape-edv.de> <201101080056.40803@orion.escape-edv.de> <4D2AF5E6.1070007@redhat.com> <201101110210.49205@orion.escape-edv.de>
In-Reply-To: <201101110210.49205@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-01-2011 23:10, Oliver Endriss escreveu:
> On Monday 10 January 2011 13:04:54 Mauro Carvalho Chehab wrote:
>> Em 07-01-2011 21:56, Oliver Endriss escreveu:
>>> ...
>>> There are large pieces of driver code which are currently unused, and
>>> nobody can tell whether they will ever be needed.
>>>
>>> On the other hand a developer spent days writing this stuff, and now it
>>> does not exist anymore - without any trace!
>>>
>>> The problem is not, that it is missing in the current snapshot, but
>>> that it has never been in the git repository, and there is no way to
>>> recover it.
>>
>> The Mercurial tree will stay there forever. We still have there the old CVS 
>> trees used by DVB and V4L development.
>>>
>>> Afaics, the only way to preserve this kind of code is 'out-of-tree'.
>>> It is a shame... :-(
>>
>> I see your point. It is harder for people to re-use that code, as they are not
>> upstream.
> 
> The main problem is that they do not even know that the code exists.
> 
> Maybe I should add some comment to the driver, that someone should look
> into the HG repository, before he starts re-inventing the wheel.
> 
>> It is easy to recover the changes with:
>>
>> $ gentree.pl 2.6.37 --strip_dead_code linux/ /tmp/stripped
>> $ gentree.pl 2.6.37  linux/ /tmp/not_stripped
>> $ diff -upr /tmp/stripped/ /tmp/not_stripped/ >/tmp/revert_removed_code.patch
>>
>> As a reference and further discussions, I'm enclosing the diff.
> 
> The resulting diff is far from complete.
> In fact, the most interesting parts are missing.
> 
> Apparently, the command
>     gentree.pl 2.6.37  linux/ /tmp/not_stripped
> stripped all '#if 0' blocks, which are not followed by a comment.
> Just compare the original ngene_av.c with the resulting version in
> /tmp/non_stripped.

Oliver,

I fixed the script. Sorry for taking a long time. Too much stuff here.
The fix patch were already merged at -hg.

It will now produce the right results. A regex expression were waiting for
 something after #if 1/#if 0, with is generally ok, as lines end with \n.
However, due to the usage of chomp, the \n character were removed, and the 
regex failed on lines with just '#if 0'.

-

On most places, the code inside #if 0 are just legacy stuff, where people
were trying to implement a different code for something. However, at ngene,
the code inside #if 0 are there just because the ngene developers didn't find
time yet to work on them. So, it may make sense to add those code into mainstream,
if people will uncomment part of those code. So, feel free to send me a patch
adding the commented code, if you need.

Thanks,
Mauro
