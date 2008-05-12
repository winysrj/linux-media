Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JvX3Y-00028n-Lx
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 14:23:06 +0200
Date: Mon, 12 May 2008 14:22:20 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Rogan Dawes <lists@dawes.za.net>
In-Reply-To: <48282843.6010906@dawes.za.net>
Message-ID: <Pine.LNX.4.64.0805121418530.11078@pub3.ifh.de>
References: <48281E7A.8010006@dawes.za.net>
	<Pine.LNX.4.64.0805121254410.11078@pub3.ifh.de>
	<48282843.6010906@dawes.za.net>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T South Africa
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

Hi,

I'm now 100% sure that this is a DVB-H transport stream.

the appearing/disappearing TS-PIDs in the dvbtraffic are indicating that 
timeslicing is active.

The dvbsnoop clearly says that there are only MPE-sections which is 
another indicator for that.

I will commit my two little, proof-of-concept-like, tools soon and tell 
you where to find and how to try it.

Patrick.


On Mon, 12 May 2008, Rogan Dawes wrote:

> Patrick Boettcher wrote:
>>  Hi Rogan,
>>
>>  your dvbtraffic output raises a question: What happens when you run it for
>>  several seconds ?
>>
>>  Are the PIDs always the same? Especially the one with the higher bitrate?
>>
>>  I'm asking because if that is the case, it could be that this is a DVB-H
>>  transmission.
>>
>>  I have some tools (which I did not commit yet) which "scan", in a very
>>  basic way, for DVB-H services, maybe this could help you.
>>
>>  Before that you can try to use dvbsnoop on PID 0x00 and 0x10 to see
>>  whether it signals a INT-section.
>>
>>  I could also be a pure radio transmission, but in that case scan should
>>  detect those channels.
>>
>>  Patrick.
>
> Hi Patrick,
>
> Actually, I think you may well be right. Our cell networks are trialling (or 
> even deploying) DVB-H, and the content is provided by MultiChoice. 
> Unfortunately (for me) that content is almost definitely encrypted.
>
> I guess I might have to retry w_scan to see if it picks up any other 
> frequencies that might have the real DVB-T signals on them. And maybe improve 
> my antennae - I am currently using a Technisat DigiFlex TT2, which is just 
> sitting on my desk.
>
> I am attaching the results of "dvbsnoop -s pidscan", as well as a longer 
> capture of dvbtraffic (using "dvbtraffic | tee dvbtraffic.txt", then Ctrl-C 
> after 6-7 seconds).
>
> Thanks for your help.
>
> Regards,
>
> Rogan
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
