Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp115.rog.mail.re2.yahoo.com ([68.142.225.231]:30306 "HELO
	smtp115.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755335AbZBSAwq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 19:52:46 -0500
Message-ID: <499CAD5B.9010106@rogers.com>
Date: Wed, 18 Feb 2009 19:52:43 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Tobias Klauser <tklauser@distanz.ch>, mchehab@infradead.org,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	kernel-janitors@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] V4L: Storage class should be before const qualifier
References: <20090209210649.GA7378@xenon.distanz.ch> <alpine.LNX.1.10.0902161353150.18110@jikos.suse.cz> <4999AAB6.4090904@rogers.com> <alpine.LNX.1.10.0902170313310.18110@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0902170313310.18110@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jiri Kosina wrote:
> On Mon, 16 Feb 2009, CityK wrote:
>
>   
>>>> .... [inline patch] ....
>>>>         
>>> This doesn't seem to be picked by anyone for current -next/-mmotm, I have
>>> applied it to trivial tree. Thanks,
>>>       
>> Will this create any complication? As it is indeed queued in our
>> patchwork: http://patchwork.kernel.org/project/linux-media/list/
>>     
>
> Hmm, patchwork ... did this land in any actual code tree? It has been 
> submitted by Tobias on 9th Feb and I was not able to find it in any tree 
> today, so I applied to to trivial tree (to which the patch has been 
> originally CCed).
>
> If you guys actually have queued in some tree, please let me know and I 
> will drop it.

I'll defer to Mauro for the absolutes, but it looks like it got applied
to V4L-DVB mainline Hg yesterday and is in Mauro's Linux-next git.
