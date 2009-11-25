Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65084 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZKYQm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 11:42:56 -0500
Received: by bwz27 with SMTP id 27so7085290bwz.21
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 08:43:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83bcf6340911241736n45f7decaodf1f131b0119a8d6@mail.gmail.com>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
	 <1259106230.3069.16.camel@palomino.walls.org>
	 <83bcf6340911241736n45f7decaodf1f131b0119a8d6@mail.gmail.com>
Date: Wed, 25 Nov 2009 11:43:01 -0500
Message-ID: <34373e030911250843x1db6793fm16abfd4444ba09da@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Robert Longfield <robert.longfield@gmail.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hopefully tonight I will get a chance to isolate the machine and hook
the incoming cable directly to the mythbox. If it still happens I'll
try isolating the ground.
As far as the history of the machine. This only seemed to appear when
I installed the new Mythbuntu, in previous versions and in windows
(when the machine had windows installed on it) the card worked
perfectly.
I haven't tested the other inputs and I haven't noticed if it's a time
issue (how long the machine is running).

Thanks for the ideas thus far,
-Rob

On Tue, Nov 24, 2009 at 8:36 PM, Steven Toth <stoth@kernellabs.com> wrote:
> On Tue, Nov 24, 2009 at 6:43 PM, Andy Walls <awalls@radix.net> wrote:
>> On Tue, 2009-11-24 at 13:05 -0500, Robert Longfield wrote:
>>> I have a PVR-150 card running on mythbuntu 9 and it appears that my
>>> card is suffering a vertical (and possibly a horizontal) sync issue.
>>>
>>> The video jumps around, shifts from side to side, up and down and when
>>> it shifts the video wraps. I'm including a link to a screen shot
>>> showing the vertical sync problem
>>>
>>> http://imagebin.ca/view/6fS-14Yi.html
>>
>> It looks like you have strong singal reflections in your cable due to
>> impedance mismatches, a bad splitter, a bad cable or connector, etc.
>>
>> Please read:
>>
>> http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality
>>
>> and take steps to ensure you've got a good cabling plant in your home.
>
> Was it previously working well then went bad?
>
> Does the problem occur when using the svideo/composite inputs?
>
> Does the problem only occur after the unit has been running for sometime?
>
> If the problem repro's under windows call Hauppauge tech support.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
