Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.7.61.12] (helo=killala.koala.ie)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@koala.ie>) id 1JeWlU-0000fZ-8x
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 15:38:10 +0100
Received: from [127.0.0.1] (killala.koala.ie [195.7.61.12])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id m2QEc3xe009699
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 14:38:03 GMT
Message-ID: <47EA5FB7.2000901@koala.ie>
Date: Wed, 26 Mar 2008 14:37:43 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: DVB ML <linux-dvb@linuxtv.org>
References: <c8b4dbe10803241504t68d96ec9m8a4edb7b34c1d6ef@mail.gmail.com>
In-Reply-To: <c8b4dbe10803241504t68d96ec9m8a4edb7b34c1d6ef@mail.gmail.com>
Subject: Re: [linux-dvb] DVB-T support for original (A1C0) HVR-900
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

Aidan Thornton wrote:
> I've been attempting to get something that can cleanly support DVB-T
> on the original HVR-900, based on up-to-date v4l-dvb and Markus'
> em2880-dvb (that is to say, something that could hopefully be cleaned
> up to a mergable state and won't be too hard to keep updated if it
> doesn't get merged). The current (somewhat messy, still incomplete)
> tree is at http://www.makomk.com/hg/v4l-dvb-em28xx/ - em2880-dvb.c is
> particularly bad. I don't have access to DVB-T signals at the moment,
> but as far as I can tell, it works. Anyone want to test it? General
> comments? (Other hardware will be added if I have the time,
> information, and someone willing to test it.)
>   

it build and installs fine for me on 2.6.24
it doesn't work with my device (a terratec cinergy xs hybrid device)
i will have a look at the weekend at the code (real life intrudes)

thank you for this.

regards
--
simon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
