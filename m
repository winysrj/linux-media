Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:43708 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2LSIyo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 03:54:44 -0500
Message-ID: <50D180CD.3090307@schinagl.nl>
Date: Wed, 19 Dec 2012 09:54:37 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jonathan McCrohan <jmccrohan@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50D0FAE3.5000103@gmail.com>
In-Reply-To: <50D0FAE3.5000103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19-12-12 00:23, Jonathan McCrohan wrote:
> Hi Oliver,
>
> On 18/12/12 22:01, Oliver Schinagl wrote:
>> Unfortunatly, I have had zero replies.
> Apologies. I wasn't subscribed to linux-media. I am now.
>
>> So why bring it up again? On 2012/11/30 Jakub Kasprzycki provided us
>> with updated polish DVB-T frequencies for his region. This has yet to be
>> merged, almost 3 weeks later.
>>
>> While I know people are busy and merging frequency updates doesn't seem
>> critical, for people who somewhat depend on them, the sooner, the better.
> I can relate. I currently have two patch files that I am trying to get
> merged myself I have been contacting Manu and Christoph) directly
> because previous attempts at posting to linux-media were left unattended
> for a good period of time.
>
>> I'll quickly repeat why I think this approach would be quite reasonable.
>>
>> * dvb-apps binary changes don't result in unnecessary releases
>> * frequency updates don't result in unnecessary dvb-app releases
>> * Less strict requirements for commits (code reviews etc)
>> * Possibly easier entry for new submitters
>> * much easier to package (tag it once per month if an update was)
>> * Separate maintainer possible
>> * just seems more logical to have it separated ;)
>>
>> This obviously should find a nice home on linuxtv where it belongs!
> I like this approach, but I'm afraid that decoupling dvb-apps and scan
> files may result in distributions paying less attention to scan files.
> At the moment, they are forced to update the scan files when a new
> release of dvb-apps appears.
So if no code changes are needed/done, but scan files are updated, a new 
dvb-apps release needs to be made?

That also results in grief for packagers. Packages need to be made but 
more importantly tested against many combinations. While the changes 
(binary anyway) would be trivial/non-existant, it would result in 
annoyance for packagers and could even be ignored.

scanfiles could be packaged and released just as easily and since there 
are applications already out there, that do not even use or need 
dvb-apps, it makes sense to seperate them. TVheadend for example does 
not need dvb-apps in any form and i'm sure there's more.

So it goes both ways :p
>
>> If an issue is that none of the original maintainers are not looking
>> forward to do the job, I am willing to take maintenance on me for now.
> To be honest, I think the current system works okay. I think more people
> just need to be given hg commit access. This would solve the current delays.
>
> Jon
>

