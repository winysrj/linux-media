Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <dheitmueller@kernellabs.com>) id 1QSTm4-0007zP-Pn
	for linux-dvb@linuxtv.org; Fri, 03 Jun 2011 14:46:49 +0200
Received: from mail-ew0-f54.google.com ([209.85.215.54])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1QSTm4-0001O9-BD; Fri, 03 Jun 2011 14:46:48 +0200
Received: by ewy1 with SMTP id 1so913654ewy.41
	for <linux-dvb@linuxtv.org>; Fri, 03 Jun 2011 05:46:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE8D5AC.7060002@mailbox.hu>
References: <4D764337.6050109@email.cz> <20110531124843.377a2a80@glory.local>
	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
	<20110531174323.0f0c45c0@glory.local>
	<BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
	<4DE8D5AC.7060002@mailbox.hu>
Date: Fri, 3 Jun 2011 08:46:46 -0400
Message-ID: <BANLkTi=c+OQvh9Mj4njF4dJtSQdR=cAMaA@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
Cc: linux-dvb@linuxtv.org, thunder.m@email.cz,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [linux-dvb] XC4000: added card_type
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

On Fri, Jun 3, 2011 at 8:38 AM, istvan_v@mailbox.hu <istvan_v@mailbox.hu> wrote:
> This patch adds support for selecting a card type in struct
> xc4000_config, to allow for implementing some card specific code
> in the driver.
>
> Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

Hi Istan,

I understand what you're trying to do here, but this is not a good
approach.  We do not want to be littering tuner drivers with
card-specific if() statements.  Also, this is inconsistent with the
way all other tuner drivers work.

The approach you are attempting may seem easier at first, but it gets
very difficult to manage over time as the number of boards that use
the driver increases.

You should have the bridge driver be setting up the cfg structure and
passing it to the xc4000 driver, just like the xc5000 and xc3028 do.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
