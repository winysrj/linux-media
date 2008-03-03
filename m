Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JWB97-0000Ae-5Q
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 14:56:01 +0100
Message-ID: <47CC0364.3010600@gmail.com>
Date: Mon, 03 Mar 2008 17:55:48 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Florian Lohoff <flo@rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>
	<47CB2D95.6040602@gmail.com>
	<20080302233653.GA3067@paradigm.rfc822.org>
	<47CB44A8.5060103@gmail.com>
	<20080303085249.GA6419@paradigm.rfc822.org>
	<47CBDC63.9030207@gmail.com>
	<20080303112610.GC6419@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com>
	<20080303134444.GA12328@paradigm.rfc822.org>
In-Reply-To: <20080303134444.GA12328@paradigm.rfc822.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
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

Florian Lohoff wrote:
> On Mon, Mar 03, 2008 at 05:41:17PM +0400, Manu Abraham wrote:
>> You are wrong again. Please look at the code, how statistics related
>> operations are retrieved.
> 
> When i issue a DVBFE_GET_INFO i dont get stats i get informations
> about the delivery system - a better name would be GET_CAPABILITY.
> In the demod (e.g. STB0899) its a simply memcpy of a predefined
> capabily struct - So why on earth does it set/change the in kernel
> delivery system ?!?!
> 
> You are still not answering the rational behind ignoring the delivery
> system in dvbfe_params/DVBFE_SET_PARAMS.

I already mentioned this in my previous email. Please read the previous 
mails
and or the old discussions.

 From my previous email:

Your 2nd option won't work at all. It is completely broken when you have
to query statistics, before a SET_PARAMS.

Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
