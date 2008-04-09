Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Wed, 09 Apr 2008 12:30:13 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <Pine.LNX.4.64.0804091813540.31992@kheldar.romunt.nl>
To: linux-dvb@linuxtv.org
Message-id: <47FCEF15.80109@linuxtv.org>
MIME-version: 1.0
References: <200803292240.25719.janne-dvb@grunau.be>
	<47FCDB9A.5040807@gmail.com>
	<37219a840804090900q50ac4faakc66a5f8d4bd88c3b@mail.gmail.com>
	<Pine.LNX.4.64.0804091813540.31992@kheldar.romunt.nl>
Cc: Michael Krufky <mkrufky@linuxtv.org>, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
 dvb adapter numbers, second try
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


>> The arguments against applying this change are "fix udev instead" and
>> "we'll have to remove this in kernel 2.7" ... Well, rather than to
>> have everybody wait around for a "fix" that requires programming
>> skills in order to use, I say we merge this now, so that people can
>> use their systems properly TODAY.  If we have to remove this in the
>> future as a result of some other kernel-wide requirements, then we
>> will cross that bridge when we come to it.
>>
>> I see absolutely no harm in implementing this feature now.
>>
>> -Mike
>>
> 
> +1
> 
> For MythTv setups this is very much needed... for the reasons Mike very 
> clearly stated.

Either someone steps up and writes a bullet proof udev configuration 
mechanism for v4l/dvb, or the patches gets merged.

Given that nobody has done the former, I suggest we do the latter.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
