Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0BWJWh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 04:22:37 -0500
Message-ID: <4B839E80.8050607@redhat.com>
Date: Tue, 23 Feb 2010 10:23:12 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Brandon Philips <brandon@ifup.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org>    <20100121024605.GK4015@jenkins.home.ifup.org>    <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com>    <20100222225426.GC4013@jenkins.home.ifup.org>    <4B839687.4090205@redhat.com> <e69623b3a970d166a31af8258040a471.squirrel@webmail.xs4all.nl>
In-Reply-To: <e69623b3a970d166a31af8258040a471.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/23/2010 10:01 AM, Hans Verkuil wrote:
>
>> Hi,
>>
>> On 02/22/2010 11:54 PM, Brandon Philips wrote:
>>> On 18:24 Sat 23 Jan 2010, Hans de Goede wrote:
>>>>> lib/
>>>>> 	libv4l1/
>>>>> 	libv4l2/
>>>>> 	libv4lconvert/
>>>>> utils/
>>>>> 	v4l2-dbg
>>>>> 	v4l2-ctl
>>>>> 	cx18-ctl
>>>>> 	ivtv-ctl
>>>>> contrib/
>>>>> 	test/
>>>>> 	everything else
>>>>>
>>>
>>>     git clone git://ifup.org/philips/create-v4l-utils.git
>>>     cd create-v4l-utils/
>>>     ./convert.sh
>>>
>>> You should now have v4l-utils.git which should have this directory
>>> struture. If we need to move other things around let me know and I can
>>> tweak name-filter.sh
>>>
>>
>> Ok, so this will give me a local tree, how do I get this onto linuxtv.org
>> ?
>>
>> Also I need someone to pull:
>> http://linuxtv.org/hg/~hgoede/libv4l
>>
>> (this only contains libv4l commits)
>>
>> Into the:
>> http://linuxtv.org/hg/v4l-dvb
>>
>> Repository, I guess I can ask this directly to Douglas?
>>
>>> Thoughts?
>>
>> I've one question, I think we want to do tarbal releases
>> from this new repo (just like I've been doing with libv4l for a while
>> already), and then want distro's to pick up these releases, right ?
>>
>> Are we going to do separate tarbals for the lib and utils directories,
>> or one combined tarbal. I personally vote for one combined tarbal.
>>
>> But this means we will be inflicting some pains on distro's because their
>> libv4l packages will go away and be replaced by a new v4l-utils package.
>
> I would call it media-utils. A nice name and it reflects that it contains
> both dvb and v4l utilities.
>

Well, the judge is still out on also adding the dvb utils to this git repo.
I'm neutral on that issue, but I will need a co-maintainer for those bits
if they end up in the new v4l-utils repo too.

About the name, if the dvb utils get added and we want to reflect that, lets
call it v4l-dvb-utils. media-utils is not a very descriptive name for v4l-dvb
project outsiders.






>> This is something distro's should be able to handle (it happens more
>> often, and I
>> know Fedora has procedures for this).
>>
>> An alternative would be to name the repo and the tarbals libv4l, either is
>> fine
>> with me (although I'm one of the distro packagers who is going to feel the
>> pain
>> of a package rename and as such wouldn't mind using libv4l as name for the
>> repo and the new tarbals).
>
> We never had a proper release procedure for all the utilities. It's about
> time that we start with that and do proper packaging. So I'd rather make a
> clean new start now instead of just patching things up.
>

Well we need to do some patching up anyways as I would like to align the
versioning of these new tarbals with libv4l versioning, so the first release
/ tarbal will most likely be something-0.8.0.tar.gz

Regards,

Hans
