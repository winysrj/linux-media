Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KyV37-0005WW-IM
	for linux-dvb@linuxtv.org; Fri, 07 Nov 2008 18:23:11 +0100
Received: by ey-out-2122.google.com with SMTP id 25so539536eya.17
	for <linux-dvb@linuxtv.org>; Fri, 07 Nov 2008 09:23:06 -0800 (PST)
Message-ID: <37219a840811070923o7aa7e91do1780dd20145c72c8@mail.gmail.com>
Date: Fri, 7 Nov 2008 12:23:05 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Paul Guzowski" <guzowskip@linuxmail.org>
In-Reply-To: <37219a840811070921se5be4adk72de45140002b804@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081107140513.4DCE87BD53@ws5-10.us4.outblaze.com>
	<37219a840811070921se5be4adk72de45140002b804@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Channel configuration files....
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

On Fri, Nov 7, 2008 at 12:21 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Paul -- please see my response below.
>
>> Paul in NW Florida
>>> ----- Original Message -----
>>> From: "Michael Krufky" <mkrufky@linuxtv.org>
>>> To: "Paul Guzowski" <guzowskip@linuxmail.org>
>>> Cc: linux-dvb@linuxtv.org
>>> Subject: Re: [linux-dvb] Channel configuration files....
>>> Date: Wed, 5 Nov 2008 11:41:27 -0500
>>>
>>>
>>> On Wed, Nov 5, 2008 at 6:58 AM, Paul Guzowski <guzowskip@linuxmail.org> wrote:
>>> > Greetings,
>>> >
>>> > Does anyone on this list have a sample channel.conf file for
>>> > Brighthouse Networks cable or can anyone give enough information
>>> > (frequencies, transponders, etc) so that I can try to build one?
>>> > Thanks in advance.
>>> >
>>> > Paul in NW Florida
>>>
>>> Paul,
>>>
>>> You can use "scan" from dvb-apps, using the scan file,
>>> "us-Cable-Standard-center-frequencies-QAM256" ...  If that doesn't
>>> work, you can try the other QAM256 cable scan files, located in the
>>> util/scan/atsc/ directory of dvb-apps.
>>>
>>> Alternatively, you can use the latest version of w_scan WITHOUT any
>>> scan file.  This should produce the best results.
>>>
>>> The latest version of w_scan with atsc / qam scanning support can be
>>> downloaded from here:
>>>
>>> http://wirbel.htpc-forum.de/w_scan/w_scan-20080815.tar.bz2
>>>
>>> You can scan cable using this command:
>>>
>>> w_scan -A2 -X > channels.conf
>>>
>>> Good luck.
>>>
>>> -Mike Krufky
>
>
> On Fri, Nov 7, 2008 at 9:05 AM, Paul Guzowski <guzowskip@linuxmail.org> wrote:
>> Greetings Mike,
>>
>> I tried your suggestion and didn't have any success.  I know there are cable signals coming over the line because two other TVs in the house (one analog and one HDTV-capable) can tune channels.  If I connect to the RF-out from the digital set-top box, I can use mplayer tuned to channel 3 to watch TV but I'd like to be able to tune from the cable directly. Not sure what to try next.  Here's the results of my test:
>>
>> paul@Kris-desktop:/media/Data/Computer/Downloads/Linux/Multimedia/w_scan-20080815$ w_scan -a0 -X > channels.conf
>> w_scan version 20080105
>> -_-_-_-_ Getting frontend capabilities-_-_-_-_
>> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
>> ERROR: Sorry - i couldn't get any working frequency/transponder
>>  Nothing to scan!!
>> dumping lists (0 services)
>> Done.
>> paul@Kris-desktop:/media/Data/Computer/Downloads/Linux/Multimedia/w_scan-20080815$
>>
>
>
> Paul,
>
> The policy of this mailing list, and almost all linux mailing lists,
> is to enter your replies BELOW the quoted text.  Do not top-post.
>
> Please notice above, that I instructed you to pass " -A2 -X " into the
> w_scan command line.  You passed " -a0 -X " ..  The -a? and -A? are
> two entirely different command line switches.  If you're trying to
> scan QAM, then you must pass -A2
>
> -Mike
>

Also,  do NOT use the rf out from the cablebox -- you wont get any
digital services that way.  You must use the cable feed coming in
directly from the wall / street.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
