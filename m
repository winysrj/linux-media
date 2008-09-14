Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1KezhG-0003Lk-S8
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 00:03:59 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id 9006FE6DD0
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 00:03:55 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id HBVG-o1NRaWb for <linux-dvb@linuxtv.org>;
	Mon, 15 Sep 2008 00:03:55 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id 1F11DE6DC9
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 00:03:55 +0200 (CEST)
Message-ID: <48CD8A4B.4090209@linuxtv.org>
Date: Mon, 15 Sep 2008 00:03:55 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <564277.58085.qm@web46102.mail.sp1.yahoo.com>	<48CD41BD.8040508@linuxtv.org>	<d9def9db0809141251r1edece84r96c8becd5a2d4ee3@mail.gmail.com>
	<48CD88CF.7060601@linuxtv.org>
In-Reply-To: <48CD88CF.7060601@linuxtv.org>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Steven Toth wrote:
> Markus Rechberger wrote:
>> Great move Steven! Can we move the TDA10048 code over, maybe adding
>> a note that it's dual licensed would be nice?
> 
> In principle yes.
> 
> I'd like to see an example of dual license just to make sure it has no 
> nasty side effects.
> 
> Can you point me at one of your dual-license drivers so I can review the 
> wording?

AFAIK the biggest problem with dual licensing is that you cannot merge
patches from Linus' tree, because they are not dual licensed (unless, of
course, you'll get the permission from the contributors).

Regards,
Andreas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
