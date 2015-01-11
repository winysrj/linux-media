Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:50191 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbbAKKkT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 05:40:19 -0500
Message-ID: <54B250C2.9050705@schinagl.nl>
Date: Sun, 11 Jan 2015 11:30:26 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
MIME-Version: 1.0
To: Brian Burch <brian@pingtoo.com>,
	Jonathan McCrohan <jmccrohan@gmail.com>,
	Adam Laurie <adam@algroup.co.uk>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-t scan tables
References: <54ADCBBC.4050400@algroup.co.uk> <54AE4333.9070301@schinagl.nl> <54AE4A6D.6080602@pingtoo.com> <54AE4DE6.1040602@schinagl.nl> <92F63096-11DC-434E-81C0-673263E56459@gmail.com> <54AF1143.3090308@pingtoo.com>
In-Reply-To: <54AF1143.3090308@pingtoo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Brian,

On 01/09/2015 12:22 AM, Brian Burch wrote:
> On 08/01/15 13:16, Jonathan McCrohan wrote:
>> Hi Olliver/Brian/Adam,
>>
>> On 8 January 2015 09:29:10 GMT+00:00, Olliver Schinagl <oliver@schinagl.nl> wrote:
>>> <snip>
>>>> Because I am basically an ubuntu user, I took the source from the
>>>> latest debian unstable repository to generate my patch. I submitted
>>> it
>>>> as an ubuntu "bug" so it would be documented and distributed
>>>> throughout that particular distribution tree. I felt (perhaps
>>> wrongly)
>>>> that submitting directly to the original developers would a) miss the
>>>> documentation cascade, and b) might not be committed to the ubuntu
>>>> repositories as quickly.
>>> While this might be the fastest way to get a seperated patch into
>>> ubuntu, ideally we'd like to have it as quickly as possible in the main
>>>
>>> tree. I'm not sure how quickly or _if at all_ ubuntu sends their table
>>> patches upstream! I would imagine the ubuntu devs keeping the patch
>>> until the patch fails, indicating that it has landed upstream ...
>>>
>>> So while faster in ubuntu, it wlll be slower, or not at all everywhere
>>> else :(.
>   >
>> Submitting a bug against dtv-scan-tables to the Debian/Ubuntu bug tracker isn't the worst thing in the world; I maintain the package in Debian and keep it up to date. Ubuntu then syncs the package from Debian. I monitor both bug trackers for bug reports and send any upstream.
> There are a LOT of distros that branch off this particular tree. I use
> four of them, for example.
>
> In the past I've submitted fixes to the original developers of other
> packages, but it has taken months or years to get them pulled into the
> distros that matter to me. It is very frustrating to have a fix accepted
> but /still/ having to manually patch my own systems to maintain
> synchronisation with the main repositories.
Yes, that's the reason why we split off the dtv-scan-tables from the 
dvb-utils repository, as some of those changes where lingering for ages.
>
> I've been advised by the ubuntu maintenance people that the best way to
> close the loop is to start at their end. If the report and the patch are
> credible, they usually push it upstream using the best path quite quickly.
While it's an extra step and takes a bit longer, it certainly works ;)

cc-ing me and the linux-media list with dtv-scan-tables in the subject 
does both ;)

The big difference with normal code patches, and dvb patches is, we more 
or less rely on the persons in the area to verify the data, there's only 
very little that can get 'reviewed' as we don't know if the data is 
right or wrong.
>
> I hope to have a change to au_SunshineCoast quite soon, so I am very
> pleased to know that Jonathan will be looking after any changes that
> flow along my chosen path.
cc me + ml and it'll happen faster.
>
> I don't think there is a "perfect" solution, but ubuntu/debian bugs
> often turn up high on general searches. If a fix exists, it is much
> easier to get maintainers of non-debian distros to accept a bug report,
> easy for them to pull down the source and then quickly release an update.
also true, I like how tv-headend handles this, they pull the latest git 
periodically I think.
>
> (Thinks... it is a pity this thread didn't take place on the appropriate
> mailing list).
CC-ed the list :)
>
> Best wishes, and thanks for the very useful software!
Technically, it's not software ;)
olliver
>
> Brian
>
>> Best to send them directly upstream to linux-media@vger.kernel.org if you can manage it though :-)
>>
>> Jon
>>

