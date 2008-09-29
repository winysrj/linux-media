Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gordons.ginandtonic.no ([195.159.29.69])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anders@ginandtonic.no>) id 1KkFFv-0004jw-Jj
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 11:41:50 +0200
Message-ID: <48E0A2A3.6070109@ginandtonic.no>
Date: Mon, 29 Sep 2008 11:40:51 +0200
From: Anders Semb Hermansen <anders@ginandtonic.no>
MIME-Version: 1.0
To: Jens.Peder.Terjesen@devoteam.com
References: <OFF62A17F0.5BC6C425-ONC12574D3.003452D3-C12574D3.003452D6@devoteam.com>
In-Reply-To: <OFF62A17F0.5BC6C425-ONC12574D3.003452D3-C12574D3.003452D6@devoteam.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
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

Jens.Peder.Terjesen@devoteam.com wrote:
> I thought that the analogue and DVB-T on this card was quite separate
> parts?

I think so yes.

> The DVB-T broadcast has probably already begun. At least it has in my part
> of Norway where the official date is also November 11th.

I used w_scan yesterday and it returned results. I used scan to get a 
channels.conf which looks ok (don't have it here, I'm at work). But I 
could not manage to get it to play. I don't know if this is because of 
software not supporting frontend1 (DVB-T is on 
/dev/dvb/adapter0/frontend1), frontend0 is DVB-S or if it does not 
support the digital standard in norway yet. I tried to play using 
mplayer directly, and dvbstream with a pipe to mplayer (seems mplayer 
does not cope with different frontend).

Any suggestion on how to go forward from here is appreceated.


Anders

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
