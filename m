Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:46556 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0CCLMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 06:12:44 -0500
Subject: Re: git over http from linuxtv
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4B8D6231.1020806@redhat.com>
References: <4B82F7ED.6020502@redhat.com>
	 <1267550594.27183.22.camel@masi.mnp.nokia.com>
	 <4B8D6231.1020806@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 13:12:06 +0200
Message-ID: <1267614726.27183.55.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On Tue, 2010-03-02 at 20:08 +0100, ext Mauro Carvalho Chehab wrote:
> m7aalton wrote:
> > Hi.
> > 
> > Is it possible to access the linuxtv.org git repositories using http?
> > I tried to do this:
> > 
> > git remote add linuxtv git://linuxtv.org/v4l-dvb.git
> 
> You should be able to use both URL's:
> 
> URL	http://git.linuxtv.org/v4l-dvb.git
> 	git://linuxtv.org/v4l-dvb.git
> 
> There were a miss-configuration for the http URL. I just fixed it.


Now it works better but I still couldn't clone it properly. The update
from linuxtv didn't seem to do anything....

Here's what happened:

$ git clone
http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
v4l-dvb

$ cd v4l-dvb

$ git remote add linuxtv http://git.linuxtv.org/v4l-dvb.git

$ git remote update
Updating origin
>From http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
   13dda80..3a5b27b  master     -> origin/master
Updating linuxtv

$ git branch -a
* master
  origin/HEAD
  origin/master

$ git checkout -b media-master linuxtv/master
fatal: git checkout: updating paths is incompatible with switching
branches.
Did you intend to checkout 'linuxtv/master' which can not be resolved as
commit?

Cheers, 
Matti










> 
> > 
> > using http, but I couldn't figure out a working address. 
> > 
> > Thank you,
> > Matti Aaltonen
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


