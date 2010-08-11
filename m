Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab0HKNQZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 09:16:25 -0400
Message-ID: <4C62A2AF.9070805@redhat.com>
Date: Wed, 11 Aug 2010 10:16:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: A problem with http://git.linuxtv.org/media_tree.git
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>	 <201008091838.13247.hverkuil@xs4all.nl>	 <1281425501.14489.7.camel@masi.mnp.nokia.com>	 <b141c1c6bfc03ce320b94add5bb5f9fc.squirrel@webmail.xs4all.nl>	 <1281441830.14489.27.camel@masi.mnp.nokia.com>	 <4C614294.7080101@redhat.com>	 <1281518486.14489.43.camel@masi.mnp.nokia.com>	 <757d559ab06463d8b5e662b9aeeec701.squirrel@webmail.xs4all.nl>	 <1281526453.14489.50.camel@masi.mnp.nokia.com> <1281527073.14489.59.camel@masi.mnp.nokia.com>
In-Reply-To: <1281527073.14489.59.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 11-08-2010 08:44, Matti J. Aaltonen escreveu:
> Hi again.
> 
> On Wed, 2010-08-11 at 14:34 +0300, Matti J. Aaltonen wrote:
>> Hello.
>>
>> On Wed, 2010-08-11 at 12:56 +0200, ext Hans Verkuil wrote:
>>>> Hi.
>>>>
>>>> I cloned your tree at 	http://linuxtv.org/git/media_tree.git and checked
>>>> out the origin/staging/v2.6.37 branch and the
>>>> Documentation/video4linux/v4l2-controls.txt  just isn't there. I asked
>>>> one of my colleagues to do the same and the result was also the same.
>>>
>>> The file is in the v2.6.36 branch. It hasn't been merged yet in the
>>> v2.6.37 branch.
>>
>> 37 above was a typo, sorry. My point was that we couldn't find it in the
>> origin/staging/v2.6.36 branch... and that the branch lags behind of what
>> can be seen via the git web interface...
>>
>> B.R.
>> Matti
> 
> I'd suggest - if that's not too much trouble - that you'd clone the tree
> using http (from http://linuxtv.org/git/media_tree.git) and then checked
> out the 36 branch and see that it works for you and then post the
> command you used and then I'll admit what I did wrong - if necessary:-)

You should try to avoid using http method for clone/fetch. It depends on some 
files that are created by running "git update-server-info". There's a script to
run it automatically after each push. Yet, the better is to use git.

I've just ran it right now. Maybe this solved the issue.

Cheers,
Mauro
