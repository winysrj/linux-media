Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41707 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1AJMwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:52:47 -0500
Received: by iwn9 with SMTP id 9so19128167iwn.19
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 04:52:46 -0800 (PST)
Message-ID: <4D2B0119.4030007@gmail.com>
Date: Mon, 10 Jan 2011 10:52:41 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: CityK <cityk@rogers.com>
CC: Linux-media <linux-media@vger.kernel.org>,
	vincent.mcintyre@gmail.com
Subject: Re: difference mchehab/new_build.git to media_build.git ?
References: <4D29FD05.2090501@rogers.com>
In-Reply-To: <4D29FD05.2090501@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-01-2011 16:23, CityK escreveu:
> vincent.mcintyre wrote:
>> Thanks for clarifying this. Doesn't this justify a one-line NEWS item?
>> I can understand not wanting to mention it while still experimental, but now...
> 
> Last night (well, actually the wee wee hours of this morning), I took the time to:
> - add a news announcement regarding media_build on the front page of the wiki
> - update the  http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers article accordingly

Thanks for the changes!

You can add a "more advanced" approach. That's what I currently do here:

$ git clone git://linuxtv.org/media_build.git
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git media_tree
$ cd media_tree
$ git remote add linuxtv git://linuxtv.org/media_tree.git
$ git remote update
$ git checkout -b media-master remotes/linuxtv/staging/for_v2.6.38-rc1
$ cd ../media_build/linux
$ make dir DIR=../media_tree
$ cd ..

The "make dir" target will associate the development git tree with the media_tree,
in a way that, if you change a file or update the media_tree, the new_build scripts
will sync its copy with the media_tree ones, re-applying the patches if needed,
before building the targets.

You should try it. It helps a lot if you need to keep your drivers in track with the
upstream ones.

> I suspect that what has precluded any earlier case of a widely visible announcement being made, beyond those tidbits that have appeared on the mailing list, is a combination of:
> - the necessity for having someone actually find and take time to perform such an administrative task
> - and, amongst most, a case of general unfamiliarity  with the new system
> - and, a question of maintainership of the new system and whether or not its status is still classified as experimental or has reached maturity
> - and, access rights required to modify the Linuxtv proper website in regards to these developments

True. Btw, as we don't have anyone dedicated to maintain the media_build, 
I gave write rights to other people for the media_build tree. As I found
it useful to myself, I'm also keeping it on a reasonable stable (although
I only use the "make dir" way, so I probably won't notice a bug with make
untar and related targets). If someone has time and interests on helping
to maintaining it, please ping me. 

> Speaking of time, I've now expended all of mine, and then some (as per usual), which I can devote to this matter.  
> Hopefully someone can take a look and correct any mistakes I've made or add any points I've overlooked on the wiki.
> As well, hopefully someone else can take care of the other parts of the website that need to be updated.

Thanks!

Mauro.
