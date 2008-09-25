Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KioCb-0007sl-8w
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 12:36:06 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Sep 2008 12:35:56 +0200
References: <573008.36358.qm@web52908.mail.re2.yahoo.com>
	<alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
	<01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
In-Reply-To: <01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809251235.56358.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] [PATCH] Add remote control support to Nova-TD
	(52009)
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

On Thursday 25 September 2008 11:56:02 Torgeir Veimo wrote:
> On 25 Sep 2008, at 19:53, Patrick Boettcher wrote:
> >> This patch is against the 2.6.26.5 kernel, and adds remote control
> >> support for the Hauppauge WinTV Nova-TD (Diversity) model. (That's
> >> the 52009 version.) It also adds the key-codes for the credit-card
> >> style remote control that comes with this particular adapter.
> >
> > Committed and ask to be pulled, thanks.
>
> Am curious, would it be possible to augment these drivers to provide
> the raw IR codes on a raw hid device, eg. /dev/hidraw0 etc, so that
> other RC5 remotes than the ones that actually are sold with the card
> can be used with the card?


There will be soon either LIRC in kernel, or another solution to send IR 
codes through the input layer from Jon Smirl.

We should convert all custom remote code once one of the above is 
merged.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
