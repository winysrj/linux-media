Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Kihyq-0001Nz-HO
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 05:57:29 +0200
Message-ID: <48DB0C1E.6020605@gmail.com>
Date: Thu, 25 Sep 2008 07:57:18 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <4724.24.120.242.223.1222313000.squirrel@webmail.xs4all.nl>
In-Reply-To: <4724.24.120.242.223.1222313000.squirrel@webmail.xs4all.nl>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
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

Hans Verkuil wrote:

> Just work with Steve to convert the current devices in the multiproto tree
> to use this API. If there is anything missing kick Steve and he'll have to
> add whatever is needed. That's *his* responsibility and he accepted that
> during the discussions.

With the multiproto tree, you _don't_need_ to convert any devices to use
the new infrastructure, whereas with S2API you need to do that. This is
a major drawback. In the multiproto tree, all devices work just without
any conversion of any kind, also it is completely backward compatible.

The aspect of backward compatibility and drivers not getting converted
had been a major issue, when the original DVB-S2 discussions came up.
This had been a design goal for the multiproto tree.


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
