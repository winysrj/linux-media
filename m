Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JWBbF-00042v-G7
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 15:25:09 +0100
Message-ID: <47CC0A32.1040807@gmail.com>
Date: Mon, 03 Mar 2008 18:24:50 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Florian Lohoff <flo@rfc822.org>
References: <47CBDC63.9030207@gmail.com>
	<20080303112610.GC6419@paradigm.rfc822.org>
	<47CBE8FD.9030303@gmail.com>
	<20080303132157.GA9749@paradigm.rfc822.org>
	<47CBFFFD.1020902@gmail.com> <47CC0201.5010701@gmail.com>
	<20080303134823.GB12328@paradigm.rfc822.org>
	<47CC055C.5030705@gmail.com>
	<20080303140316.GD12328@paradigm.rfc822.org>
	<47CC0896.3050308@gmail.com>
	<20080303141358.GF12328@paradigm.rfc822.org>
In-Reply-To: <20080303141358.GF12328@paradigm.rfc822.org>
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
> On Mon, Mar 03, 2008 at 06:17:58PM +0400, Manu Abraham wrote:
>>> You mean tune and then check if there is a SIGNAL and possibly a LOCK? I
>>> do that yes ... But first comes the tune - On an uninitialized state of
>>> a demod/tuner i would not expect to see any signal.
>> How do you expect to look for a signal level when using a rotor, for a 
>> real life example ?
> 
> In case of a rotor i expect the diseq commands to go out - tune the
> frontend for the right modulation and frequency and then monitor the
> signal level while turning the dish.
> 
> This needs tuning - right ?

No, this is fed from the AGC1 path1 integrator and the AGC1 path2 
integrator.

Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
