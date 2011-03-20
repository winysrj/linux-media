Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:45188 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751186Ab1CTV7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 17:59:08 -0400
References: <201103191940.20876.Jochen.Reinwand@gmx.de> <4D85005A.4080101@web.de> <201103202145.11493.Jochen.Reinwand@gmx.de>
In-Reply-To: <201103202145.11493.Jochen.Reinwand@gmx.de>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=utf-8
Message-Id: <F4C2A6DF-0F62-412F-8FD9-37CE4747D7F1@gmx.de>
Cc: =?utf-8?Q?Andr=C3=A9_Weidemann?= <Andre.Weidemann@web.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Harald Becherer <Harald.Becherer@gmx.de>
Subject: Re: Remote control TechnoTrend TT-connect S2-3650 CI
Date: Sun, 20 Mar 2011 22:59:00 +0100
To: Jochen Reinwand <Jochen.Reinwand@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



Am 20.03.2011 um 21:45 schrieb Jochen Reinwand <Jochen.Reinwand@gmx.de>:

> Hi André,
> 
> Thanks for the help! I already fixed the problem! By accident...
> 
> On Saturday 19 March 2011, André Weidemann wrote:
>> I don't think that this is a hardware problem. I think it is related to
>> the driver. When I added support for the S2-3650CI to Dominik Kuhlen's
>> code for the PC-TV452e, I used the RC-code function "pctv452e_rc_query"
>> for the S2-3650CI. I ran into this problem back then and thought that
>> setting .rc_interval to 500 would "fix" the problem good enough.
> 
> My first idea was simple: Set it to 1000. Better a slow remote control than  
> double key presses. But the double key press events remained.
> So I was planning to do some more debugging.
> But my next idea was: If I get double events anyway, I can also speed up the 
> remote by setting .rc_interval to 250. After setting it, everything was faster 
> and ...  the double events disappeared!!! Of course, I did some further tests 
> and found out that setting .rc_interval to 50 is also working perfectly! No 
> double key press events so far and the remote is reacting really quick.
> 
> I don't really understand why this is fixing the issue...
> Does it make sense to put this into the official repo? Or is it too dangerous? 
> It's possibly breaking things for others...
> 
> Regards
> Jochen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hi,

I just tried and indeed, it works for me as well;-)
Never switched so fast...
I tried 50 but it is almost too fast
Maybe 75 or 100...

By the way, are there any thoughts/plans to merge TT S2-3600 into kernel some time?
Would be a guinea pig and buy a card for CI testing.

Greetings
Harald