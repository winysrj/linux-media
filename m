Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab0CMGoB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 01:44:01 -0500
Message-ID: <4B9B35E4.7070702@redhat.com>
Date: Sat, 13 Mar 2010 07:51:16 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Chicken Shack <chicken.shack@gmx.de>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: v4l-utils, dvb-utils, xawtv and alevt
References: <201003090848.29301.hverkuil@xs4all.nl>	 <1268197457.3199.17.camel@pc07.localdom.local> <4B98FABB.1040605@gmail.com>	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>	 <4B9A6089.4060300@redhat.com>	 <1a297b361003120820h768bc388n81077a4b6cfe71e6@mail.gmail.com> <1268421039.1971.46.camel@brian.bconsult.de>
In-Reply-To: <1268421039.1971.46.camel@brian.bconsult.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/12/2010 08:10 PM, Chicken Shack wrote:
> 1. Alevt 1.7.0 is not just another tool, but it is instead a
> self-contained videotext application consisting of three parts:
> a. alevt, b. alevt-date c. alevt-cap
>
> While the packed size of alevt is 78770 the complete size of the
> dvb-apps as a whole ranges around 350000.
>
> I am not against hosting this program at linuxtv.org, but if this
> decision is made the decision should be an intelligent one: alevt is a
> separate tree, and any other choice is simply a dumb one.
> Alevt-1.7.0 needs a lot of external dependencies, while the dvb-apps
> only need the libc6.
>

Seems we agree here, becoming a new upstream for alevt is good, merging
it into another package is not good :)

> 2. Xawtv-4.0 pre is not usable as a whole. Thus you cannot treat it as a
> whole. And that's exactly why you cannot discuss it as a whole!
>

Actually when I was talking about doing a tree to collect distro packages
and serve as a new upstream for xawtv I was talking about xawtv version
3.95, is that the same as which you call xawtv-4.0 pre ?



> The usable parts are:
>
> a. mtt: a slave videotext application which is running independently
> from the master application tuning the channels.
> Its packed size amounts to 107744.
>
> b. dvbrowse: a slave EPG application which is running independently from
> the master application tuning the channels.
> Packed Size: 101267.
>
> c. dvbradio: a fast and rather stable running application for watching
> DVB radio streams.
> Packed Size: 119957.
> Problem: dvbradio would need investigation to understand channel lists
> in vdr channels.conf format.
> As long as this is not the case, the insane slow homebrew scanner called
> alexplore is necessary to produce a channels list.
> Gerd implied some vdr modules into thew package, but they are
> ca. unfinished work
> cb. for debug purposes only
>
>
> The unusable parts are:
>
> a. xawtv itself, the main program.
> It never ran stable and it is unfinished work.
> Its graphical capabilities are pure rubbish compared to todays
> standards.
>

??

Its UI is not a brilliant piece of work but it is usable and certainly
is stable. Actually it still is my preffered app for tvcard testing / usage.

> b. Lots of aged tools like scantv or radio who just have survived
> somehow but weren't modified.
>

If these are really useless we could certainly drop them, as we could
drop say v4l-ctl once we've got rid of the last v4l1 drivers.

Regards,

Hans
