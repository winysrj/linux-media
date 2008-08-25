Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KXhSS-000581-U8
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 21:10:33 +0200
Date: Mon, 25 Aug 2008 21:02:41 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080825190241.GH32022@raven.wolf.lan>
References: <20080821174512.GC32022@raven.wolf.lan>
	<52113.203.82.187.131.1219367267.squirrel@webmail.planb.net.au>
	<20080822144448.GF32022@raven.wolf.lan>
	<F4917AA8-6EA3-40A7-855B-AEB774B26C58@recoil.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F4917AA8-6EA3-40A7-855B-AEB774B26C58@recoil.org>
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

On Fri, Aug 22, 2008 at 04:44:56PM +0100, Nick Ludlam wrote:
> On 22 Aug 2008, at 15:44, Josef Wolf wrote:
>>On Fri, Aug 22, 2008 at 11:07:47AM +1000, Kevin Sheehan wrote:
>>
>>>Barry was right on the money with the ts2ps suggestion below.  It's  
>>>part of the libdvb package.  You don't have to use the dvb-mpegtools  
>>>app, you can just use the lib in yours - no pipes, etc.

I have now changed my application to create exactly what ts2ps creates.
Now I notice that neither mplayer nor vlc play the stream created by
ts2ps.

Vlc gives tons of error messages like this:

  [00000365] main video output warning: vout warning: early picture skipped (47722279483)
  [00000359] main audio output warning: received buffer in the future (47722179597)

no audio and black video :-(

If I remove the PS pack header and the PS system header (stream-id 0xba
and 0xbb) then both play the stream, but no STB plays it :-(

Next, I tried:

> The command I wrapped in a popen call from a script was:
> 
> 	/opt/local/bin/replex -o /dev/stdout -i TS -v %s -a %s -t MPEG2 
> 	/dev/ stdin

With this command, I get hopping video with VLC.

It seems to be a mess.  None of the programs seem to produce proper
streams.  Only mencoder seems to generate a proper stream.  But AFAICS,
mencoder completely decodes the stream and re-encodes it again, eating
up all the CPU.

Any more ideas how to do the conversion?

BTW: Can anybody recommend a good book on the topic?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
