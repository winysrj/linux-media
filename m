Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay4.mail.uk.clara.net ([80.168.70.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon.farnsworth@onelan.co.uk>) id 1KDGM3-0004sn-K5
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 12:11:28 +0200
Message-ID: <4868B148.2030300@onelan.co.uk>
Date: Mon, 30 Jun 2008 11:11:20 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
MIME-Version: 1.0
To: yoshi watanabe <yoshi314@gmail.com>
References: <51029ae90806300203p2d5fbf6bo7a28391b59553599@mail.gmail.com>	
	<4868A644.5030806@onelan.co.uk>
	<51029ae90806300304s106305u36be341e80b69b2a@mail.gmail.com>
In-Reply-To: <51029ae90806300304s106305u36be341e80b69b2a@mail.gmail.com>
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

Please don't drop the cc when replying - I'm passing on my own 
experiences with an unrelated card, in the hope that it helps you.

Someone else on the list may look at this and have an "aha!" moment, 
answering your question for you.

Note that the increased buffering is important for the SAA7134 - it 
seems to only be prepared to transfer audio data in blanking time, so if 
there's not enough buffering available, it just drops samples.

yoshi watanabe wrote:
> i tried 32000 before when using arecord | aplay combo but the arecord
> insisted on 48000 audio rate. will try again and report later, thanks.
> 
> On Mon, Jun 30, 2008 at 11:24 AM, Simon Farnsworth
> <simon.farnsworth@onelan.co.uk> wrote:
>> yoshi watanabe wrote:
>>> hello.
>>>
>>> i'm using hauppauge hvr-1300 to receive video signal from playstation2
>>> console, pal model. video is just fine, but i'm having strange audio
>>> issues, but judging by some searching i did - that's pretty common
>>> with this card , although people have varied experience with the card.
>>>
>> I've had similar issues with SAA7134 based cards, which were resolved by
>>  changing audio parameters.
>>
>> If your problem is the same as mine was, try:
>> arecord --format=S16 \
>>        --rate=32000 \
>>        --period-size=8192 \
>>        --buffer-size=524288 | aplay
>>
>> This forces 32kHz sampling, and gives the card lots of buffer space to play
>> with.
>> --
>> Simon Farnsworth
>>
>>
> 
> 
> 


-- 
Simon Farnsworth
Software Engineer

ONELAN Limited
1st Floor Andersen House
Newtown Road
Henley-on-Thames, OXON
RG9 1HG
United Kingdom

Tel:    +44(0)1491 411400
Fax:    +44(0)1491 579254
Support:+44(0)1491 845282

www.onelan.co.uk


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
