Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:39847 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab2LRWJJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 17:09:09 -0500
Message-ID: <50D0E7A7.90002@schinagl.nl>
Date: Tue, 18 Dec 2012 23:01:11 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: pfister@linuxtv.org, adq_dvb@lidskialf.net, js@linuxtv.org,
	cus@fazekas.hu, mws@linuxtv.org, jmccrohan@gmail.com,
	jirislaby@gmail.com, shaulkr@gmail.com, mkrufky@linuxtv.org,
	mchehab@redhat.com, lubomir.carik@gmail.com
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl>
In-Reply-To: <507FE752.6010409@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunatly, I have had zero replies.

So why bring it up again? On 2012/11/30 Jakub Kasprzycki provided us 
with updated polish DVB-T frequencies for his region. This has yet to be 
merged, almost 3 weeks later.

While I know people are busy and merging frequency updates doesn't seem 
critical, for people who somewhat depend on them, the sooner, the better.

Since I didn't expect anybody to actually do the work, just was asking 
for your thoughts, I've done the work. I've setup a repository and 
purged all unrelated files. All history should have been preserved.

I'll quickly repeat why I think this approach would be quite reasonable.

* dvb-apps binary changes don't result in unnecessary releases
* frequency updates don't result in unnecessary dvb-app releases
* Less strict requirements for commits (code reviews etc)
* Possibly easier entry for new submitters
* much easier to package (tag it once per month if an update was)
* Separate maintainer possible
* just seems more logical to have it separated ;)

This obviously should find a nice home on linuxtv where it belongs!

Here is my personal repository with the work I mentioned done.
git://git.schinagl.nl/dvb_frequency_scanfiles.git

If an issue is that none of the original maintainers are not looking 
forward to do the job, I am willing to take maintenance on me for now.

Anyway, hopefully this time we can get some form of discussion going :)

Oliver

On 10/18/12 13:26, Oliver Schinagl wrote:
> Hello list,
>
> I was talking to someone over at tvheadend and was told that the
> linux-media initial scan files tend to be often very out dated. Also
> when newer files are submitted, requests to merge them are simply being
> ignored. Obviously I have zero proof to back those claims. True or not,
> they have decided to keep a local copy and try to keep that up to date
> as possible. One of the reasons to take this approach, is because major
> distro's also do it in this way.
> 1
> This obviously results in a duplication of work and since it's factual
> data really wasted resources, no central repository of said factual
> data, but spread and makes it confusing on top of that for users of this
> data.
>
> Now I don't know the proper solution or if it really is a problem. Well
> it appears to be so I guess ;)
>
> Something that comes to mind, is to split off the initial scan files
> from the dvb-apps package and have a seperate git tree for it, like for
> example the firmware git tree. I feel this has several advantages over
> the current setup.
>
> One could have /usr/share/dvb/ as a git tree and simply pull to have an
> up to date tree.
> Initialscan file 'users (as in developers)' can more easily clone it and
> do pull requests.
> Possibly more lenient commit access, e.g. allow a 'trusted' developer of
> a dvb project to have commit rights, without much risk of breaking any
> source code.
> Other things I haven't thought of yet.
> Since there really isn't a 'stable' release, current trunk can be
> considered the go to release, unverified changes could live in a branch?
>
> Again, if everybody can firmly claim there is no problem and that the
> initial scanfiles are updated nearly when an actually change takes
> place, then we should try convince downstream maintainers of course.
>
> Anyway, this is just something that was on my mind and wanted some
> feedback on.
>
> Oliver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

