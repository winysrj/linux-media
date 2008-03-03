Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JWBHH-0000nZ-9y
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 15:04:27 +0100
Message-ID: <47CC055C.5030705@gmail.com>
Date: Mon, 03 Mar 2008 18:04:12 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Florian Lohoff <flo@rfc822.org>
References: <47CB2D95.6040602@gmail.com>
	<20080302233653.GA3067@paradigm.rfc822.org>
	<47CB44A8.5060103@gmail.com>
	<20080303085249.GA6419@paradigm.rfc822.org>
	<47CBDC63.9030207@gmail.com>
	<20080303112610.GC6419@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com> <47CC0201.5010701@gmail.com>
	<20080303134823.GB12328@paradigm.rfc822.org>
In-Reply-To: <20080303134823.GB12328@paradigm.rfc822.org>
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
> On Mon, Mar 03, 2008 at 05:49:53PM +0400, Manu Abraham wrote:
>> Basically you seem to get the wrong end, (it's one whole line, no corners
>> to it) since you think that it all starts with a tune operation. No, a tune
>> operation is not the first operation that's to be done in many cases.
> 
> A tune operation might not be the first thing to do in a GUI based
> operation where the user gets presented with a little capability show
> and clickable channel lists etc ...


The more important part is to first check for a signal, before 
attempting a tune.
Lack of doing so, will result in a lot of frustration in many cases. 
Though it is
completely upto oneself whether to do it or not.

The whole point is: there are 2 or more paths, which need to be selected 
for any
operation.

HTH,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
