Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JWB3O-00078e-EY
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 14:50:06 +0100
Message-ID: <47CC0201.5010701@gmail.com>
Date: Mon, 03 Mar 2008 17:49:53 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Florian Lohoff <flo@rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>	<47CB2D95.6040602@gmail.com>	<20080302233653.GA3067@paradigm.rfc822.org>	<47CB44A8.5060103@gmail.com>	<20080303085249.GA6419@paradigm.rfc822.org>	<47CBDC63.9030207@gmail.com>	<20080303112610.GC6419@paradigm.rfc822.org>	<47CBE8FD.9030303@gmail.com>	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com>
In-Reply-To: <47CBFFFD.1020902@gmail.com>
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

Manu Abraham wrote:
> Florian Lohoff wrote:
>> On Mon, Mar 03, 2008 at 04:03:09PM +0400, Manu Abraham wrote:
>>>> - make SET_PARAMS the call to honor delivery in dvbfe_params and remove
>>>>  the setting of the delivery of GET_INFO
>>>>
>>>> I'd prefere the 2nd option because currently the usage and naming
>>>> is an incoherent mess which should better not get more adopters ..
>>> Your 2nd option won't work at all. It is completely broken when you have
>>> to query statistics, before a SET_PARAMS.
>> I have no problem with beeing able to query stats - I have a problem
> 
> You are wrong again. Please look at the code, how statistics related
> operations are retrieved.

Basically you seem to get the wrong end, (it's one whole line, no corners
to it) since you think that it all starts with a tune operation. No, a tune
operation is not the first operation that's to be done in many cases.

Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
