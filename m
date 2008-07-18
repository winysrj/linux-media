Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from proxima.lp0.eu ([85.158.45.36] ident=exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@fire.lp0.eu>) id 1KJoV8-0001TD-DG
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 13:51:55 +0200
Message-ID: <38354.simon.1216381906@5ec7c279.invalid>
In-Reply-To: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
References: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
Date: Fri, 18 Jul 2008 12:51:46 +0100
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Brian Marete" <bgmarete@gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] V4L: Link tuner before saa7134
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


On Fri, July 18, 2008 12:28, Brian Marete wrote:
> On Jul 14, 6:00 am, hermann pitton <hermann-pit...@arcor.de> wrote:
>>
>> #1 users can't set thetunertype anymore,
>>    but the few cases oftunerdetection from eeprom we have should
>>    work again for that price.
>
> Hello,
>
> Any patch yet for above issue? It seems to have made it into 2.6.26.
>
> I use saa7134 with everything, including the tuner modules, compiled
> as a module. My card is detected as a flyvideo2000. The default tuner
> for that card (#37) allows me to tune into TV but not to FM Radio. I
> can access both functions (TV and FM Radio) if I override with
> tuner=69, which is what I usually do. That override does not work on
> 2.6.26.
>
> Any suggestions?

Modify saa7134_board_init2 so that the manual tuner type setting isn't
ignored. The first thing it does is to overwrite the current value
(set earlier from module parameter) with the static values... even
before trying to autodetect it.

In saa7134-core.c saa7134_initdev:
 dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
+dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;

In saa7134-cards.c saa7134_board_init2:
-dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
-dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;

I think that will fix it.

>
> Thanks,
>
> --
> B. Gitonga Marete
> Tel: +254-722-151-590
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Simon Arlott

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
