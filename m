Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0BWMWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 07:22:10 -0500
Message-ID: <4B83C860.6000108@infradead.org>
Date: Tue, 23 Feb 2010 09:21:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Brandon Philips <brandon@ifup.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org>	 <20100121024605.GK4015@jenkins.home.ifup.org>	 <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com>	 <20100222225426.GC4013@jenkins.home.ifup.org>	 <4B839687.4090205@redhat.com>	 <e69623b3a970d166a31af8258040a471.squirrel@webmail.xs4all.nl>	 <4B839E80.8050607@redhat.com> <1a297b361002230138k20c38a03m2f149b18ea44ed96@mail.gmail.com>
In-Reply-To: <1a297b361002230138k20c38a03m2f149b18ea44ed96@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> On Tue, Feb 23, 2010 at 1:23 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>> On 02/23/2010 10:01 AM, Hans Verkuil wrote:
>>>> Hi,
>>>>
>>>> On 02/22/2010 11:54 PM, Brandon Philips wrote:
>>>>> On 18:24 Sat 23 Jan 2010, Hans de Goede wrote:
>>>>>>> lib/
>>>>>>>        libv4l1/
>>>>>>>        libv4l2/
>>>>>>>        libv4lconvert/
>>>>>>> utils/
>>>>>>>        v4l2-dbg
>>>>>>>        v4l2-ctl
>>>>>>>        cx18-ctl
>>>>>>>        ivtv-ctl
>>>>>>> contrib/
>>>>>>>        test/
>>>>>>>        everything else
>>>>>>>
>>>>>    git clone git://ifup.org/philips/create-v4l-utils.git
>>>>>    cd create-v4l-utils/
>>>>>    ./convert.sh
>>>>>
>>>>> You should now have v4l-utils.git which should have this directory
>>>>> struture. If we need to move other things around let me know and I can
>>>>> tweak name-filter.sh
>>>>>
>>>> Ok, so this will give me a local tree, how do I get this onto linuxtv.org
>>>> ?
>>>>
>>>> Also I need someone to pull:
>>>> http://linuxtv.org/hg/~hgoede/libv4l
>>>>
>>>> (this only contains libv4l commits)
>>>>
>>>> Into the:
>>>> http://linuxtv.org/hg/v4l-dvb
>>>>
>>>> Repository, I guess I can ask this directly to Douglas?
>>>>
>>>>> Thoughts?
>>>> I've one question, I think we want to do tarbal releases
>>>> from this new repo (just like I've been doing with libv4l for a while
>>>> already), and then want distro's to pick up these releases, right ?
>>>>
>>>> Are we going to do separate tarbals for the lib and utils directories,
>>>> or one combined tarbal. I personally vote for one combined tarbal.
>>>>
>>>> But this means we will be inflicting some pains on distro's because their
>>>> libv4l packages will go away and be replaced by a new v4l-utils package.
>>> I would call it media-utils. A nice name and it reflects that it contains
>>> both dvb and v4l utilities.
>>>
>> Well, the judge is still out on also adding the dvb utils to this git repo.
>> I'm neutral on that issue, but I will need a co-maintainer for those bits
>> if they end up in the new v4l-utils repo too.
>>
>> About the name, if the dvb utils get added and we want to reflect that, lets
>> call it v4l-dvb-utils. media-utils is not a very descriptive name for
>> v4l-dvb
>> project outsiders.
> 
> 
> What's the advantage in merging the dvb and v4l2 utils, other than to
> make the download/clone bigger ?

There aren't any big advantages on merging, nor there are big advantages on keeping
them alone.

Advantages to merge:
	- One single release control. Currently, only Hans de Goede is doing a
good job with release names, on libv4l. By having everything into one place, all other
v4l2-apps and dvb-apps will have a release name, making easier even for us when helping
people with troubles (as we'll know for sure if they're using the latest version or
a very old version;
	- One single tree for the user to download, for IR, DVB and V4L apps;
	- Distro packagers will have one single tarball to maintain.

Disadvantages:
	- More people will need access to the same git master tree;
	- The tree will be bigger.


-- 

Cheers,
Mauro
