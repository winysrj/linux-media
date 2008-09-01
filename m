Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KaFw0-0001FY-MY
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 22:23:38 +0200
Message-ID: <48BC4F36.8020209@gmail.com>
Date: Tue, 02 Sep 2008 00:23:18 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Hans Werner <HWerner4@gmx.de>
References: <48B9360D.7030303@gmail.com> <20080901183312.271660@gmx.net>
In-Reply-To: <20080901183312.271660@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Merge multiproto tree
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

Hans Werner wrote:
> that pull request does not include the following code, does it?
> 
> stb0899
> stb6100
> mantis

The above mentioned requires the API change and the relevant callbacks
to exist, without which it wouldn't even compile. So it makes sense to
merge the API changes initially prior to anything else.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
