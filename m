Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0BWNg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 08:36:28 -0500
Message-ID: <4B83D9D0.6000105@infradead.org>
Date: Tue, 23 Feb 2010 10:36:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Brandon Philips <brandon@ifup.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org>	 <20100121024605.GK4015@jenkins.home.ifup.org>	 <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com>	 <20100222225426.GC4013@jenkins.home.ifup.org>	 <4B839687.4090205@redhat.com>	 <e69623b3a970d166a31af8258040a471.squirrel@webmail.xs4all.nl>	 <4B839E80.8050607@redhat.com>	 <1a297b361002230138k20c38a03m2f149b18ea44ed96@mail.gmail.com>	 <4B83C860.6000108@infradead.org> <1a297b361002230507v53aa12d8te780b5fd0463b8c5@mail.gmail.com>
In-Reply-To: <1a297b361002230507v53aa12d8te780b5fd0463b8c5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
>>> What's the advantage in merging the dvb and v4l2 utils, other than to
>>> make the download/clone bigger ?
>> There aren't any big advantages on merging, nor there are big advantages on keeping
>> them alone.
>>
>> Advantages to merge:
>>        - One single release control. Currently, only Hans de Goede is doing a
>> good job with release names, on libv4l. By having everything into one place, all other
>> v4l2-apps and dvb-apps will have a release name, making easier even for us when helping
>> people with troubles (as we'll know for sure if they're using the latest version or
>> a very old version;
>>        - One single tree for the user to download, for IR, DVB and V4L apps;
>>        - Distro packagers will have one single tarball to maintain.
>>
>> Disadvantages:
>>        - More people will need access to the same git master tree;
>>        - The tree will be bigger.
> 
> 
> It is quite noble to think of having to have everything unified in the
> world. But that doesn't seem how things are in practice. It's quite
> understood that the concept of "one-single-ring-to-rule-them-all"
> doesn't work well.
> 
> The mercurial dvb-apps tree has worked quite well for me as well as
> the other few people who have been involved with it and don't have any
> problems in that arena and I am very happy with it on that front.
> 
> FWIW, I am not very much interested to move to git.
> 
> Are we making a mockery, switching between SCM's every now and then .. ?
> 
> Maybe there are others as well, who feel that way. But that's not the
> more important point. For me, it is like simply that a simple update
> is quite fast and easy.

I don't think moving it to git would bring any significant advantage or 
disadvantage.

> With regards to distro stuff; This is best left to distro vendors.

Agreed.

> With regards to release control, we have had a 1.1.1 release. Looking
> back, we haven't had a proper stable state yet, for another release.

Hmm...
	http://www.linuxtv.org/downloads/

May, 18 2006... 

$ hg log -d ">05/18/2006" -p|diffstat -p1|grep changed
 1402 files changed, 66559 insertions(+), 16267 deletions(-)

Sorry, but it is really failing with release control. There were _lots_ of change
since 2006, including several new applications, and tons of new channel/transponders
added to it.

> Thinking of which, it is more of these discussions that hold back real
> development rather than anything else. Moving to git, or have a merged
> tree with v4l2 and dvb utils is not going to make dvb-apps development
> any faster.
> 
> On the contrary, I don't think it is going to help dvb-apps in anyway
> on the development front, but rather make it worser.

Why would it be worse?

> My few cents, being one of the dvb-apps maintainers and author of some
> the bits and pieces in it.

PS.: while removing that "need maintainer" warning from the wiki, I noticed that,
just like v4l2-apps, there's one application there for IR (util/av7110_loadkeys).

Even if we decide to keep the trees separate, we should really put this utility 
and the IR code at v4l2-apps at the same place.

-- 

Cheers,
Mauro
