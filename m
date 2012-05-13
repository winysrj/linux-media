Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41663 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2EMRjg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 13:39:36 -0400
Message-ID: <4FAFF1D7.6070700@iki.fi>
Date: Sun, 13 May 2012 20:39:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: AF9035 experimental header changes
References: <4FAFD21D.9000801@schinagl.nl> <4FAFD888.8080801@iki.fi> <4FAFEED8.7080903@schinagl.nl>
In-Reply-To: <4FAFEED8.7080903@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.05.2012 20:26, Oliver Schinagl wrote:
> On 13-05-12 17:51, Antti Palosaari wrote:
>> On 13.05.2012 18:24, Oliver Schinagl wrote:
>>> Hi antti,
>>>
>>> I've just updated my local branch of your experimental branch and got
>>> some conflicts because you moved the header inclusions from the C file
>>> to the header file. Why is that? I thought it was really bad practice to
>>> have includes in header files.
>>>
>>> http://git.linuxtv.org/anttip/media_tree.git/commitdiff/7d28d8226cffd1ad6e555b36f6f9855d8bba8645
>>>
>>
>> Because "struct state" was inside af9013.h and I added "struct
>> af9033_config" to state. Due to that af9033_config visibility I was
>> forced to move af9013.h include to the af9015.h and moved all the
>> others too.
>>
> I see, I just learnedthat having includes in headers is just something
> really bad, possibly causing include loops etc etc. Its just something
> that's generally not needed and should be avoided. ideally anyway :)

But it is not actual header in the mind of the normal header. It is 
something like driver private include. Maybe better name could be 
af9035_priv.h as the demodulators files are named. But as all the other 
DVB USB drivers are named without priv I do not like to name that 
differently.

Include guards [1] are for avoiding include loops.

>> What is problem you has met?
> Well it's just movement of those headers caused merges to conflict and
> fail :)

Hmmm, may I ask what you are doing? Adding some new supported tuners or 
hacking dual mode?

That my repository is the only "official" one. As that is the official 
repo you should resolve merge conflicts with your own :)

>> DVB USB driver header file is something like private place for data
>> other than code as it is not included by any other driver.

[1] http://en.wikipedia.org/wiki/Include_guard

regards
Antti
-- 
http://palosaari.fi/
