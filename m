Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KWXyB-0005T9-Id
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 16:50:32 +0200
Date: Fri, 22 Aug 2008 16:44:48 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080822144448.GF32022@raven.wolf.lan>
References: <20080821174512.GC32022@raven.wolf.lan>
	<52113.203.82.187.131.1219367267.squirrel@webmail.planb.net.au>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52113.203.82.187.131.1219367267.squirrel@webmail.planb.net.au>
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

On Fri, Aug 22, 2008 at 11:07:47AM +1000, Kevin Sheehan wrote:

> Barry was right on the money with the ts2ps suggestion below.  It's part
> of the libdvb package.  You don't have to use the dvb-mpegtools app, you
> can just use the lib in yours - no pipes, etc.

I know.  But I still consider ts2ps to be too heavy for my application.
It goes and parses all the PES contents, which eats much CPU.

But at least, ts2pes was very helpful in analyzing the differences in
the stream between what I created and what ts2pes created.  Finally, I
have found the problem:

I appears that PES_packet_length==0 is allowed in TS _only_.  While
unpacking, the long packet (I have seen up to 100 kbytes) extracted 
from the TS needs to be split up into smaller ones.  ps2pes splits
into pieces with PES_packet_length==0x7fa and prepends an empty PES
header (with only the length specification) to each of the new packets.

Finally, I can generate a PES stream with one video and multiple
audio streams which is played pretty fine by mplayer and vlc.

Now I need to add the PS pack header (ts2ps adds 14 bytes) and the
system header (ts2ps adds 18 bytes).  For this, I have two more
questions:

1. Is the system_header required at all?  Table 2-33 in iso-13818-1
   seems to make it optional.

2. For creating the PS pack header, the only missing information is
   the program_mux_rate.  How is this value calculated?  How accurate
   has this value to be?  If the stream bit rate changes (maybe because
   of changes in resolution), do I need to adopt this value and generate
   a MPEG_program_end_code and add a new pack header with the new
   value?  Or will the player stop when it detects MPEG_program_end_code?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
