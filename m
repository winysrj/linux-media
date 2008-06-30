Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yoshi314@gmail.com>) id 1KDIcn-0002Du-5A
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 14:36:55 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1498881rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 05:36:48 -0700 (PDT)
Message-ID: <51029ae90806300536g734d5d24x84ed8cc84260266a@mail.gmail.com>
Date: Mon, 30 Jun 2008 14:36:48 +0200
From: "yoshi watanabe" <yoshi314@gmail.com>
To: "Simon Farnsworth" <simon.farnsworth@onelan.co.uk>
In-Reply-To: <4868B148.2030300@onelan.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
References: <51029ae90806300203p2d5fbf6bo7a28391b59553599@mail.gmail.com>
	<4868A644.5030806@onelan.co.uk>
	<51029ae90806300304s106305u36be341e80b69b2a@mail.gmail.com>
	<4868B148.2030300@onelan.co.uk>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] hvr-1300 analog audio question
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

sorry, seems that's the way gmail works by default. that was not intended.
i'll post results in 3-4 hours time when i'm home.

On Mon, Jun 30, 2008 at 12:11 PM, Simon Farnsworth
<simon.farnsworth@onelan.co.uk> wrote:
> Please don't drop the cc when replying - I'm passing on my own experiences
> with an unrelated card, in the hope that it helps you.
>
> Someone else on the list may look at this and have an "aha!" moment,
> answering your question for you.
>
> Note that the increased buffering is important for the SAA7134 - it seems to
> only be prepared to transfer audio data in blanking time, so if there's not
> enough buffering available, it just drops samples.
>
> yoshi watanabe wrote:
>>
>> i tried 32000 before when using arecord | aplay combo but the arecord
>> insisted on 48000 audio rate. will try again and report later, thanks.
>>
>> On Mon, Jun 30, 2008 at 11:24 AM, Simon Farnsworth
>> <simon.farnsworth@onelan.co.uk> wrote:
>>>
>>> yoshi watanabe wrote:
>>>>
>>>> hello.
>>>>
>>>> i'm using hauppauge hvr-1300 to receive video signal from playstation2
>>>> console, pal model. video is just fine, but i'm having strange audio
>>>> issues, but judging by some searching i did - that's pretty common
>>>> with this card , although people have varied experience with the card.
>>>>
>>> I've had similar issues with SAA7134 based cards, which were resolved by
>>>  changing audio parameters.
>>>
>>> If your problem is the same as mine was, try:
>>> arecord --format=S16 \
>>>       --rate=32000 \
>>>       --period-size=8192 \
>>>       --buffer-size=524288 | aplay
>>>
>>> This forces 32kHz sampling, and gives the card lots of buffer space to
>>> play
>>> with.
>>> --
>>> Simon Farnsworth
>>>
>>>
>>
>>
>>
>
>
> --
> Simon Farnsworth
> Software Engineer
>
> ONELAN Limited
> 1st Floor Andersen House
> Newtown Road
> Henley-on-Thames, OXON
> RG9 1HG
> United Kingdom
>
> Tel:    +44(0)1491 411400
> Fax:    +44(0)1491 579254
> Support:+44(0)1491 845282
>
> www.onelan.co.uk
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
