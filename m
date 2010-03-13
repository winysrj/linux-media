Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166Ab0CMMdn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 07:33:43 -0500
Message-ID: <4B9B8665.9080706@redhat.com>
Date: Sat, 13 Mar 2010 13:34:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chicken Shack <chicken.shack@gmx.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: v4l-utils, dvb-utils, xawtv and alevt
References: <201003090848.29301.hverkuil@xs4all.nl>	 <1268197457.3199.17.camel@pc07.localdom.local> <4B98FABB.1040605@gmail.com>	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>	 <4B9A6089.4060300@redhat.com>	 <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com>	 <1268421039.1971.46.camel@brian.bconsult.de>  <4B9B35E4.7070702@redhat.com> <1268475324.1752.59.camel@brian.bconsult.de>
In-Reply-To: <1268475324.1752.59.camel@brian.bconsult.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/13/2010 11:15 AM, Chicken Shack wrote:
> Am Samstag, den 13.03.2010, 07:51 +0100 schrieb Hans de Goede:
>> Hi,
>>
>> On 03/12/2010 08:10 PM, Chicken Shack wrote:
>>> 1. Alevt 1.7.0 is not just another tool, but it is instead a
>>> self-contained videotext application consisting of three parts:
>>> a. alevt, b. alevt-date c. alevt-cap
>>>
>>> While the packed size of alevt is 78770 the complete size of the
>>> dvb-apps as a whole ranges around 350000.
>>>
>>> I am not against hosting this program at linuxtv.org, but if this
>>> decision is made the decision should be an intelligent one: alevt is a
>>> separate tree, and any other choice is simply a dumb one.
>>> Alevt-1.7.0 needs a lot of external dependencies, while the dvb-apps
>>> only need the libc6.
>
> Good morning Hans,
>

Good afternoon :)

> Definitely not.
> 3.95 is analogue only and thus is discontinued as version.
> 4.0 pre is the alpha-state tarball that you can get here:
>

Ah, ok. Well I must honestly say I've no interest in that I'm doing
package maintenance for the 3.95 release in Fedora and I know it
needs a lot of patching, AFAIK other distros are doing the same,
so it would be good to have / become a new upstream for xawtv 3.95,
to have a place to gather all the distro patches mostly and release
that, and where new patches if needed can accumulate and new
releases can be done from.


> http://dl.bytesex.org/cvs-snapshots/xawtv-20081014-100645.tar.gz
>
> Inofficial end of development somewhere in 2005 or 2006, last external
> contribution from October 2008.
>
> 4.0 pre introduced DVB support for mtt (videotext) and the main program
> xawtv.
> It also introduced this disgusting slow channel scanner called alexplore
> (DVB only) and dvbrowse as a complete new EPG solution for DVB only.
> And it introduced dvbradio which would be excellent after some
> investigation (->  learn to interpret channels.conf files).
>

I see, well if there is an interest in bits of the 4.0 code base, then
grabbing those bits and having a tree with them and doing regular
tarbal releases for distro's to consume might be in interesting project
for some one. I would like to advocate to not call this xawtv, as AFAIK
all distros are still shipping 3.95, and as you said the xawtv part of 4.0
is broken so likely would not be included, at which point it
would be good to no longer call the resulting project xawtv.

Regards,

Hans
