Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KWYR3-0007CL-MB
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 17:20:22 +0200
Date: Fri, 22 Aug 2008 17:16:02 +0200
From: Josef Wolf <jw@raven.inka.de>
To: Kevin Sheehan <linux-dvb@ephedrine.net>, linux-dvb@linuxtv.org
Message-ID: <20080822151602.GG32022@raven.wolf.lan>
References: <52113.203.82.187.131.1219367267.squirrel@webmail.planb.net.au>
	<271833.9641.qm@web46109.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <271833.9641.qm@web46109.mail.sp1.yahoo.com>
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

On Thu, Aug 21, 2008 at 10:15:37PM -0700, barry bouwsma wrote:
> --- On Fri, 8/22/08, Kevin Sheehan <linux-dvb@ephedrine.net> wrote:
> 
> > Barry was right on the money with the ts2ps suggestion below.  It's part
> > of the libdvb package.  You don't have to use the dvb-mpegtools app, you
> > can just use the lib in yours - no pipes, etc.
> 
> My understanding of a PS stream (redundant, yeah) was based on how
> ts2ps created one, with just two PIDs (0xe0 and 0xc0), which I then
> assumed was the norm.
> 
> But in the case of ZDF from the original post, as well as ARD, BR,
> Sat1, and so on, Josef wants to make the multiple available audio
> streams from the TS (primary mp2 audio, second narrative audio/
> second lang, plus AC3) within the PS for the client to select.
> 
> I'd imagine a bit of hacking is needed to ts2ps to allow one to add
> more than a single audio PID to the PS, but it should be possible.
> 
> But, if there's a need for, say, the DVB subtitles from ZDF, or the
> teletext (for teletext subtitles, amongst others), or any other
> auxiliary data within the stream, if I understand right, one would
> need to stick to writing a partial transport stream, which then
> could be filtered to PS as needed.

In addition to audio, video, program_stream_map, private_stream-X
and program_stream_directory, Table 2-19 in iso-13818-1 defines 9
more stream types:

 - ECM_stream
 - EMM_stream
 - 13818-6_DSMCC_stream
 - ISO/IEC_13522_stream
 - ITU-T Reac. H.222.1 type A
 - ITU-T Reac. H.222.1 type B
 - ITU-T Reac. H.222.1 type C
 - ITU-T Reac. H.222.1 type D
 - ITU-T Reac. H.222.1 type E

I have not looked into the details, but I guess teletext and subtitles
might be included in this list.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
