Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.sscnet.ucla.edu ([128.97.229.230]:58964 "EHLO
	smtp0.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK2Cwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 21:52:53 -0500
Message-ID: <547934E1.3050609@cogweb.net>
Date: Fri, 28 Nov 2014 18:52:17 -0800
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ISDB caption support
References: <5478D31E.5000402@cogweb.net> <CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com>
In-Reply-To: <CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Devin,

Great, thanks.

I realize captions is an application-layer function, and intend to work 
with the CCExtractor team. Do any other applications already have ISDB 
caption support?

For DVB and ATSC there's quite a bit of code written by several people 
for teletext and captions -- has anything at all been done for ISDB 
captions?

It's used in nearly all of Central and South America, plus the 
Philippines and of course Japan -- you would have thought someone has 
started on the task?

We're looking for a good solution for capturing television in Brazil, 
when the signal is encrypted -- are there set-top boxes or tv capture 
cards that handle the decryption so that the decoded signal is passed on 
with the ISDB-Tb caption stream intact?

Our test system generates captions as an overlay and does not pass on 
the closed captions.

Cheers,
David


On 11/28/14, 6:40 PM, Devin Heitmueller wrote:
> Hi David,
>
> ISDB-T subtitles are done in a similar manner to DVB-T subtitles -
> there is a PID in the stream which contains the subtitle data, which
> needs to be decoded by the application (just as you would handle DVB-T
> subtitles or ATSC closed captions).  It's entirely an application
> level function, having nothing to do with the driver layer.
>
> In short, this has nothing to do with DVBv5, as that is all about how
> the tuner is controlled, not what gets done with the resulting MPEG
> stream.  You would need to talk to whoever is responsible for the
> application you are working with (whether that be VLC, mplayer,
> ccextractor, etc).
>
> Cheers,
>
> Devin
>
> On Fri, Nov 28, 2014 at 2:55 PM, David Liontooth <lionteeth@cogweb.net> wrote:
>> What is the status of ISDB-Tb / ISDB-T International / ISDB Japanese closed
>> captioning support?
>>
>> If anyone is working on this, please get in touch -- we're particularly
>> interested in getting Brazilian SBTVD working.
>>
>> I see Mauro has been working on DVBv5 support, but does this include
>> captioning?
>>
>> Cheers,
>> David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

