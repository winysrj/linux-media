Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:46769 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab0ASVVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 16:21:39 -0500
Message-ID: <4B562260.8030707@acm.org>
Date: Tue, 19 Jan 2010 13:21:36 -0800
From: Bob Cunningham <rcunning@acm.org>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com> <4B55A2AC.4020009@infradead.org>
In-Reply-To: <4B55A2AC.4020009@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2010 04:16 AM, Mauro Carvalho Chehab wrote:
> Devin Heitmueller wrote:
>> Hello Mauro,
>>
>> I find it somewhat unfortunate that this is labeled "ANNOUNCE" instead
>> of "RFC".  It shows how little you care about soliciting the opinions
>> of the other developers.  Rather than making a proposal for how the
>> process can be improved and soliciting feedback, you have chosen to
>> decide for all of us what the best approach is and how all of us will
>> develop in the future.
>
> The announcement by purpose doesn't contain any changes on the process,
> since it requires some discussions before we go there. It is just the
> first step, where -git tree support were created. It also announces
> that I personally won't keep maintaining -hg, delegating its task
> to Douglas.
>
>> The point I'm trying to make is that we need to be having a discussion
>> about what we are optimizing for, and what are the costs to other
>> developers.  This is why I'm perhaps a bit pissed to see an
>> "announcement" declaring how development will be done in the future as
>> opposed to a discussion of what we could be doing and what are the
>> trade-offs.
>
> I fully understand that supporting the development and tests with an
> out of tree building is important to everybody. So, the plans are
> to keep the out-of-tree building system maintained, and even
> improving it. I'd like to thank to Douglas for his help on making
> this happen.
>
> Cheers,
> Mauro.

I'm primarily a lurker on this list, generally content to wait for v4l driver updates until they appear in the Fedora 12 and Ubuntu 9.10 updates.

However, I also keep a v4l source tree around that I update and build whenever any significant changes occur that affect my HVR-950Q, so I can provide rapid feedback to the developers.  My process is to update my local tree, build the drivers. build the package, install the package, test it, then either revert immediately if there are problems (after posting to the list), or update again when the changes appear in the Fedora repositories.

Am I correct to believe my process will not be affected by the shift to git?  That is, will existing kernels will still have access to the current v4l code via hg?

I also hope to one day start working on an unsupported USB tuner I have laying around (should be simple, but after nearly a year I still haven't gotten to it).  Will I be permitted to do my development, and contribute changes, using hg and the current Fedora kernel?

Lurker testers and wannabe developers need to know!

-BobC
