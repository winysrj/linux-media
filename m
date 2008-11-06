Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1KyBiz-0000G1-Cd
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 21:45:06 +0100
Message-ID: <4913572E.5000906@gmx.de>
Date: Thu, 06 Nov 2008 21:44:30 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Werner <HWerner4@gmx.de>
References: <20081106124730.16840@gmx.net> <49131C19.1080404@gmx.de>
	<20081106173737.16850@gmx.net>
In-Reply-To: <20081106173737.16850@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] wscan: improved frontend autodetection
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


> Your patch works fine for me. I would add one thing though: close the frontend if it
> is the wrong type. I have attached a new patch.
>
> Thanks,
> Hans
>   
Yes, i forgot close.
ok, i will apply that patch.

Winfried

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
