Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mill-tc-gw.mill.co.uk ([89.202.128.34] helo=smtp-3.mill.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nick@recoil.org>) id 1KWYow-0000QZ-6z
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 17:45:04 +0200
Message-Id: <F4917AA8-6EA3-40A7-855B-AEB774B26C58@recoil.org>
From: Nick Ludlam <nick@recoil.org>
To: Josef Wolf <jw@raven.inka.de>
In-Reply-To: <20080822144448.GF32022@raven.wolf.lan>
Mime-Version: 1.0 (Apple Message framework v926)
Date: Fri, 22 Aug 2008 16:44:56 +0100
References: <20080821174512.GC32022@raven.wolf.lan>
	<52113.203.82.187.131.1219367267.squirrel@webmail.planb.net.au>
	<20080822144448.GF32022@raven.wolf.lan>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

On 22 Aug 2008, at 15:44, Josef Wolf wrote:

> On Fri, Aug 22, 2008 at 11:07:47AM +1000, Kevin Sheehan wrote:
>
>> Barry was right on the money with the ts2ps suggestion below.  It's  
>> part
>> of the libdvb package.  You don't have to use the dvb-mpegtools  
>> app, you
>> can just use the lib in yours - no pipes, etc.
>
> I know.  But I still consider ts2ps to be too heavy for my  
> application.
> It goes and parses all the PES contents, which eats much CPU.


I might be slightly out in terms of your requirements, but I've had  
success using
the 'replex' tool ( http://www.metzlerbros.org/dvb/ ) to do on-the-fly  
stream
conversions of a recorded TS into a PS with a specified video and  
audio PID.

The command I wrapped in a popen call from a script was:

	/opt/local/bin/replex -o /dev/stdout -i TS -v %s -a %s -t MPEG2 /dev/ 
stdin

Where the two %s's were replaced with the desired audio PID and video  
PID.
Then I wrote to, and read from the pipes accordingly.

The only issue I had with this was that it was prone to breaking  
unless the
TS stream had little or no corruption. The CPU usage for replex was
considerably lower than using mencoder or ffmpeg, although I don't know
how difficult it would be to get replex to insert multiple audio  
streams into
the resulting PS.

Nick

--
Nick Ludlam
nick@recoil.org





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
