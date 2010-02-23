Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:45246 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0BWOKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 09:10:00 -0500
Received: by fxm19 with SMTP id 19so3841382fxm.21
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 06:09:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B83D9D0.6000105@infradead.org>
References: <4B55445A.10300@infradead.org> <4B5B30E4.7030909@redhat.com>
	 <20100222225426.GC4013@jenkins.home.ifup.org>
	 <4B839687.4090205@redhat.com>
	 <e69623b3a970d166a31af8258040a471.squirrel@webmail.xs4all.nl>
	 <4B839E80.8050607@redhat.com>
	 <1a297b361002230138k20c38a03m2f149b18ea44ed96@mail.gmail.com>
	 <4B83C860.6000108@infradead.org>
	 <1a297b361002230507v53aa12d8te780b5fd0463b8c5@mail.gmail.com>
	 <4B83D9D0.6000105@infradead.org>
Date: Tue, 23 Feb 2010 18:09:57 +0400
Message-ID: <1a297b361002230609m574ce853v8c500a0971e7b4fe@mail.gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Brandon Philips <brandon@ifup.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2010 at 5:36 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Manu Abraham wrote:
>>>> What's the advantage in merging the dvb and v4l2 utils, other than to
>>>> make the download/clone bigger ?
>>> There aren't any big advantages on merging, nor there are big advantages on keeping
>>> them alone.
>>>
>>> Advantages to merge:
>>>        - One single release control. Currently, only Hans de Goede is doing a
>>> good job with release names, on libv4l. By having everything into one place, all other
>>> v4l2-apps and dvb-apps will have a release name, making easier even for us when helping
>>> people with troubles (as we'll know for sure if they're using the latest version or
>>> a very old version;
>>>        - One single tree for the user to download, for IR, DVB and V4L apps;
>>>        - Distro packagers will have one single tarball to maintain.
>>>
>>> Disadvantages:
>>>        - More people will need access to the same git master tree;
>>>        - The tree will be bigger.
>>
>>
>> It is quite noble to think of having to have everything unified in the
>> world. But that doesn't seem how things are in practice. It's quite
>> understood that the concept of "one-single-ring-to-rule-them-all"
>> doesn't work well.
>>
>> The mercurial dvb-apps tree has worked quite well for me as well as
>> the other few people who have been involved with it and don't have any
>> problems in that arena and I am very happy with it on that front.
>>
>> FWIW, I am not very much interested to move to git.
>>
>> Are we making a mockery, switching between SCM's every now and then .. ?
>>
>> Maybe there are others as well, who feel that way. But that's not the
>> more important point. For me, it is like simply that a simple update
>> is quite fast and easy.
>
> I don't think moving it to git would bring any significant advantage or
> disadvantage.
>
>> With regards to distro stuff; This is best left to distro vendors.
>
> Agreed.
>
>> With regards to release control, we have had a 1.1.1 release. Looking
>> back, we haven't had a proper stable state yet, for another release.
>
> Hmm...
>        http://www.linuxtv.org/downloads/
>
> May, 18 2006...
>
> $ hg log -d ">05/18/2006" -p|diffstat -p1|grep changed
>  1402 files changed, 66559 insertions(+), 16267 deletions(-)
>
> Sorry, but it is really failing with release control. There were _lots_ of change
> since 2006, including several new applications, and tons of new channel/transponders
> added to it.



I don't simply see how adding in a version number is going to help in
moving things ahead. Anyone wishing to download the latest tip can
dowload from
http://linuxtv.org/hg/dvb-apps/archive/tip.tar.bz2

if one is not content with cloning the whole tree.




>> Thinking of which, it is more of these discussions that hold back real
>> development rather than anything else. Moving to git, or have a merged
>> tree with v4l2 and dvb utils is not going to make dvb-apps development
>> any faster.
>>
>> On the contrary, I don't think it is going to help dvb-apps in anyway
>> on the development front, but rather make it worser.
>
> Why would it be worse?


Anything that which doesn't make things better, but that brings in an
overhead, is something worser.

- I would need to get going on with git

- It's going to be the 3rd time there is a SCM change. Changing it all
the time doesn't help the users nor the people who work on it.

- The additional overhead to download larger content, however small
that might be initially to start up with.

- mixing up things that which are not really tied to each other


>> My few cents, being one of the dvb-apps maintainers and author of some
>> the bits and pieces in it.
>
> PS.: while removing that "need maintainer" warning from the wiki, I noticed that,
> just like v4l2-apps, there's one application there for IR (util/av7110_loadkeys).
>
> Even if we decide to keep the trees separate, we should really put this utility
> and the IR code at v4l2-apps at the same place.


It has been there for ages, originally Holger had it there, during the
time of convergence.  FF card users have been using it since. Probably
FF users would like to mention what they would like to have and
comment on that.


Regards,
Manu
