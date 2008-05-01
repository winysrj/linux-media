Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JrMXl-0005Z4-LZ
	for linux-dvb@linuxtv.org; Thu, 01 May 2008 02:21:40 +0200
Message-ID: <48190CDB.3080307@linuxtv.org>
Date: Wed, 30 Apr 2008 20:20:43 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Eric Cronin <ecronin@gizmolabs.org>
References: <CAB8636B-64E8-40CB-9D6C-0F52E9CD2394@gizmolabs.org>
	<37219a840804301134q68a86301y2373329d2fef5a2f@mail.gmail.com>
	<37219a840804301136r71b240afi16dcf75b5442fe1b@mail.gmail.com>
	<B3017A65-6616-4FBF-BF82-30B3F69B6CAA@gizmolabs.org>
In-Reply-To: <B3017A65-6616-4FBF-BF82-30B3F69B6CAA@gizmolabs.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 failing to detect any QAM256 channels
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

Eric Cronin wrote:
>
> On Apr 30, 2008, at 2:36 PM, Michael Krufky wrote:
>
>>>
>>> Eric,
>>>
>>> When you use the scan command to scan for QAM channels, you must
>>> specify -a2, to signify that you are scanning digital cable.
>>>
>>> Try that -- does that work?
>>
>>
>> My bad -- I meant, "-A 2"  (capitol A, space, 2) 

scan -A 2 -vvv dvb-apps/util/scan/atsc/us-Cable-Standard-whatever >
channels.conf

Is THAT what you're doing to scan ?


It looks like what you were doing was scan a tuned frequency for pids. 
If you want to do THAT, then you must actually be tuned to the given
frequency.  you need to azap SOME_CHANNEL -r, and keep that running
before attempting to run 'scan -c' ...  I think you should try the scan
command that I mentioned above.

HTH,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
