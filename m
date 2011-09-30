Return-path: <linux-media-owner@vger.kernel.org>
Received: from ingra.acsalaska.net ([209.112.173.251]:49770 "EHLO
	ingra.acsalaska.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1I3IUz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 04:20:55 -0400
Received: from localhost2.local (66-230-86-166-rb1.fai.dsl.dynamic.acsalaska.net [66.230.86.166])
	by ingra.acsalaska.net (8.14.4/8.14.4) with ESMTP id p8U86Dpi039629
	for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 00:06:13 -0800 (AKDT)
	(envelope-from rogerx.oss@gmail.com)
Date: Fri, 30 Sep 2011 00:06:09 -0800
From: Roger <rogerx.oss@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvbscan output Channel Number into final stdout?
Message-ID: <20110930080609.GD2284@localhost2.local>
References: <20110929224418.GD2824@localhost2.local>
 <4e856d27.92d1e30a.6587.13f8@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e856d27.92d1e30a.6587.13f8@mx.google.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Fri, Sep 30, 2011 at 08:17:53AM +0100, tvboxspy wrote:
>On Thu, 2011-09-29 at 14:44 -0800, Roger wrote:
>> Can we get dvbscan to output the Channel Number into the final stdout somehow?
>> 
>> A likely format would be something such as the following.
>> 
>> Current output:
>> 
>> KATN-DT:497028615:8VSB:49:52:3
>> KWFA-DT:497028615:8VSB:65:68:4
>> ...
>> 
>> 
>> Suggested output:
>> 2.1:497028615:8VSB:49:52:3
>> 2.2:497028615:8VSB:65:68:4
>> ...
>> 
>> The reason for this, the local ATSC broadcast over the air channels are not
>> assigning unique channel names.  However, channel numbers seem to be consistent
>> between the published TV Guide/TV Listings and are unique!  This seems to be
>> the norm for the past several years now.
>> 
>Trouble is, internationally channel numbering is regional, and has
>variations in many countries.
>
>Not to show the channel name would confuse users, but to show both with
>the number first in a string might be an idea.

True.  However we're talking an additional option to output, the already
gotten, channel numbers instead of channel names into the final output.

We're not talking standard here.  We are talking an additional option to make
it easier for scripting and updating the channel.conf file.  Channel names here
have changed many times over the past year.  Channel names are also duplicated
instead of being assigned a unique name.  However, channel numbers have stayed
somewhat more stable, noting only one or two changes over the past year.  And,
channel numbers have always been more commonly referred to when changing the
channel on the TV. (ie. Hey, lets watch channel 11 news!  We usually don't
hear, "Hey, lets watch NBC news.")


(On the flip to chew the fat here, from a local perspective, most things are
done by channel number and not channel name.  It all depends on your point of
view! ;-)


Anyways, since I know the information (channel num) is already already gotten
and ditched, I'm thinking it won't be too much more code to assign it a
variable and print instead of channel name.

Another idea, I might have been able to code my script to map to regular
channel numbers.  However, updating the channel.conf using dvbscan will then
break things, causing me to finger through manually to figure out which channel
name is which number.

Maybe I should output my full channel.conf here, as it might help show the
problem better:

[0001]:213028615:8VSB:65:68:1
KATN-DT:497028615:8VSB:49:52:3
KWFA-DT:497028615:8VSB:65:68:4
KJNP-DT:509028615:8VSB:49:52:3
KFXF-DTC:177028615:8VSB:49:52:3
K13XD-DC:177028615:8VSB:65:68:4
KUAC-DTC:189028615:8VSB:49:52:3
KUAC-DTC:189028615:8VSB:65:68:4
KUAC-DT:189028615:8VSB:81:84:5
KUAC-DT:189028616:8VSB:97:100:6
KTVF DT:545028615:8VSB:65:68:4
KTVF DT:545028615:8VSB:49:52:3
K13XD-D:521028615:8VSB:49:52:3
KFXF-DT:521028615:8VSB:65:68:4


Can you tell me which KUAC-DTC is the man channel for my area?  24.1 is the
channel number.  Of the four, there's no real way of telling unless you
memorize the frequency data?


-- 
Roger
http://rogerx.freeshell.org/
