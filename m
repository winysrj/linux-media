Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab0CCOzz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Mar 2010 09:55:55 -0500
Message-ID: <4B8E7872.3000602@redhat.com>
Date: Wed, 03 Mar 2010 11:55:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: git over http from linuxtv
References: <4B82F7ED.6020502@redhat.com>	 <1267550594.27183.22.camel@masi.mnp.nokia.com>	 <4B8D6231.1020806@redhat.com> <1267614726.27183.55.camel@masi.mnp.nokia.com>
In-Reply-To: <1267614726.27183.55.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m7aalton wrote:
> Hello.
> 
> On Tue, 2010-03-02 at 20:08 +0100, ext Mauro Carvalho Chehab wrote:
>> m7aalton wrote:
>>> Hi.
>>>
>>> Is it possible to access the linuxtv.org git repositories using http?
>>> I tried to do this:
>>>
>>> git remote add linuxtv git://linuxtv.org/v4l-dvb.git
>> You should be able to use both URL's:
>>
>> URL	http://git.linuxtv.org/v4l-dvb.git
>> 	git://linuxtv.org/v4l-dvb.git
>>
>> There were a miss-configuration for the http URL. I just fixed it.
> 
> 
> Now it works better but I still couldn't clone it properly. The update
> from linuxtv didn't seem to do anything....
> 
> Here's what happened:
> 
> $ git clone
> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> v4l-dvb
> 
> $ cd v4l-dvb
> 
> $ git remote add linuxtv http://git.linuxtv.org/v4l-dvb.git
> 
> $ git remote update
> Updating origin
>>From http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
>    13dda80..3a5b27b  master     -> origin/master
> Updating linuxtv
> 
> $ git branch -a
> * master
>   origin/HEAD
>   origin/master
> 
> $ git checkout -b media-master linuxtv/master
> fatal: git checkout: updating paths is incompatible with switching
> branches.
> Did you intend to checkout 'linuxtv/master' which can not be resolved as
> commit?

This happens when you try to use a gitweb URL instead of the proper one. At the above,
you've used the wrong URL. The correct one is:
	 http://linuxtv.org/git/v4l-dvb.git

You don't need to re-do the entire procedure. Just edit .git/config and put the
correct URL there for the linuxtv remote.

-- 

Cheers,
Mauro
