Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JW9O6-0007RE-6W
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 13:03:22 +0100
Message-ID: <47CBE8FD.9030303@gmail.com>
Date: Mon, 03 Mar 2008 16:03:09 +0400
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
In-Reply-To: <20080303112610.GC6419@paradigm.rfc822.org>
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
> On Mon, Mar 03, 2008 at 03:09:23PM +0400, Manu Abraham wrote:
>>> As i already wrote - SET_PARAMS is _NOT_ enough. Please try yourself. 
>>> Unload/Load the module and simple issue a DVBFE_SET_PARAMS (NOT
>>> GET_INFO) and it doesnt tune/lock at least for STB0899 and it also
>>> complains in the dmesg with:
>>>
>>> 	stb0899_search: Unsupported delivery system 0
>>> 	stb0899_read_status: Unsupported delivery system 0
>>> 	stb0899_search: Unsupported delivery system 0
>>> 	stb0899_read_status: Unsupported delivery system 0
>>> 	stb0899_search: Unsupported delivery system 0
>>> 	stb0899_read_status: Unsupported delivery system 0
>>>
>>> although i set
>>>
>>> 	dvbfe_params.delivery=DVBFE_DELSYS_DVBS2;
>> Yep, it isn't supposed to work that way with simply issuing SET_PARAMS.
> 
> Okay - So either 
> 
> - remove the "delivery" in the dvbfe_params because it is unnecessary,
>   confusing and broken, and rename the GET_INFO call to SET_DELIVERY
>   or something which implies that its not a _GET_ call

As you can see, removing delivery is not an option, since GET_PARAMS 
operates
on the same data structure. Removal of which will require the application to
issue an additional ioctl call.

> or 
> 
> - make SET_PARAMS the call to honor delivery in dvbfe_params and remove
>   the setting of the delivery of GET_INFO
> 
> I'd prefere the 2nd option because currently the usage and naming
> is an incoherent mess which should better not get more adopters ..

Your 2nd option won't work at all. It is completely broken when you have
to query statistics, before a SET_PARAMS.

Additionally, this was quite discussed in a long discussion a while 
back. You
might like to read through those as well.

Maybe DVBFE_GET_INFO can probably be renamed to DVBFE_INFO if it really
itches so much.

HTH,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
