Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59830 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320AbcCCHcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 02:32:17 -0500
Subject: Re: tw686x driver
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
References: <56D6A50F.4060404@xs4all.nl> <m3povcnjfo.fsf@t19.piap.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D7E87B.1080505@xs4all.nl>
Date: Thu, 3 Mar 2016 08:32:11 +0100
MIME-Version: 1.0
In-Reply-To: <m3povcnjfo.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2016 07:51 AM, Krzysztof Hałasa wrote:
> Hi Hans,
> 
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> So lessons learned:
>>
>> Krzysztof, next time don't wait many months before posting a new version fixing
>> requested changes.
> 
> Actually, this is not how it happened.
> 
> On July 3, 2015 I posted the original driver:
> http://www.spinics.net/lists/linux-media/msg91474.html
> 
> Ezequiel reviewed the code on 6 Jul 2015:
> http://www.spinics.net/lists/linux-media/msg91516.html
> 
> On 27 Jul 2015, as you can easily find in your own mail archive, he
> informed me that he's working on the driver and that he's going to post
> updated patches himself. This was holidays time for me and I stated
> that I have to suspend my work till the end of August.
> 
> I asked him to add his changes on top of my code several times (and this
> is really easy with git). This never happened, and on 14 Aug 2015 he
> posted:
> 
>> Problem is I've re-written the driver, taking yours as a starting point
>> and reference.
> 
>> In other words, I don't have a proper git branch with a history, starting
>> from the patch you submitted. Instead, I would be submitting a new
>> patch for Hans and Mauro to review.
> 
> Maybe I got the meaning of this wrong, and he wasn't writing about
> rewriting the driver "from scratch". Yes, after receiving this mail
> I stopped my development, waiting for his driver to show up. That's
> where the "many months" are. Yes, Ezequiel waited for "many months" with
> his version - not me.
> 
> Only after he has posted "his" driver, I could find out what the
> "rewriting" meant.

Thank you for the clarification.

> Don't get me wrong, I was never opposed to him improving my driver.
> I only requested that his contributions are clearly shown, in a form
> of a patch or a patch set (or a git tree etc.), and so are my own.
> I really can't understand why his code can't be transparently applied
> over my original patch (or the updated one, which compiles and works
> fine with recent media tree).
> 
> Is it too much to ask?

When a driver is merged for the first time in the kernel it is always as
a single change, i.e. you don't include the development history as that
would pollute the kernel's history. Those earlier versions have never
been tested/reviewed to the same extent as the final version and adding
them could break git bisect. So as a general rule this isn't done.

> The lesson I learned is thus this instead:
> - don't publish code because it can be hijacked, twisted and you'll
> have to fight for even getting your authorship back. Forget about proper
> attribution and history.

Your code is attributed in the source code and your patches are all archived
in patchwork and on mailinglist archives.

And should you decide to make patches for the merged driver adding back the
lost functionality, then feel free to yell loudly at Ezequiel in the commit
log (within reason, of course :-) ). Heck, I might add some lines of my own
to that.

It is a quite unusual situation and the only way I could make it worse would
by not merging anything.

Regards,

	Hans
