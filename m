Return-path: <linux-media-owner@vger.kernel.org>
Received: from c.ponzo.net ([69.12.221.20]:54257 "EHLO c.ponzo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaFKTnZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 15:43:25 -0400
Message-ID: <5398B15C.9040409@ponzo.net>
Date: Wed, 11 Jun 2014 12:43:24 -0700
From: Scott Doty <scott@ponzo.net>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: hdpvr troubles
References: <538D2392.6030301@ponzo.net> <5398122F.3060402@xs4all.nl>
In-Reply-To: <5398122F.3060402@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/11/2014 01:24 AM, Hans Verkuil wrote:
> On 06/03/14 03:23, Scott Doty wrote:
>> Hello Mr. Hans and mailing list,
>>
>> In a nutshell, I'm having some hdpvr trouble:
>>
>> I'm using vlc to view the stream.  Kernel 3.9.11 works pretty well,
>> including giving me AC3 5.1 audio from the optical input to the
>> Hauppauge device.  The only problem I've run across is the device
>> hanging when I change channels, but I've learned to live with that. 
>> (Though naturally it would be nice to fix. :) )
>>
>> However, every kernel I've tried after 3.9.11 seems to have trouble with
>> the audio.  I get silence, and pulseaudio reports there is only stereo. 
>> I've taken a couple of of snapshots of pavucontrol so you can see what I
>> mean:
>>
>>    http://imgur.com/a/SIwc7
>>
>> I even tried a git bisect to try to narrow down where things went awry,
>> but ran out of time to pursue the question.  But as far as I can tell,
>> 3.9.11 is as far as I can go before my system won't use the device properly.
>>
>> I see the conversation in the archives from around the middle of May,
>> where Hans was working with Ryley and Keith, but I'm not sure if I
>> should apply that patch or not.  I would love to make this work,
>> including submitting a patch if someone could outline where the problem
>> might be.
>>
>> Thank you in advance for any help you can provide, and please let me
>> know if I can send any more information. :)
> You can certainly try this patch:
>
> https://patchwork.linuxtv.org/patch/23890/
>
> Nobody else reported audio problems other than the issue this patch tries
> to resolve. However, that problem most likely has been with hdpvr since
> the very beginning.
>
> There were some major changes made to the driver in 3.10, so that makes me
> suspect that something might have broken. Odd though that I didn't see any
> reports about that.
>
> Keith, Ryley, if you run v4l2-ctl -D, what is the version number that is
> reported?
>
> If it is >= 3.10, then can you test with vlc as well?

Just tried the patch with 3.14.5, and it didn't solve the problem.

I'm not sure what's different about my system than other folks', unless
they aren't using the optical input?

Indeed, it acts just like the driver isn't properly honoring
"default_audio_input=2".  (For S/PDIF).  Thinking that might be a clue,
I hooked up stereo through the RCA jacks.  With "default_audio_input=2",
I did hear some crackling sounds -- but nothing intelligible, and I'm
having a hard time reproducing that.  With "default_audio_input=0", I
get clear stereo sound from the RCA jacks.

 -Scott

