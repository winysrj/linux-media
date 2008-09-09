Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n68.bullet.mail.sp1.yahoo.com ([98.136.44.44])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KcrLK-0000zS-Pr
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 02:44:33 +0200
Date: Mon, 8 Sep 2008 17:43:55 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Georg Acher <acher@in.tum.de>
In-Reply-To: <20080908195603.GE10714@braindead1.acher>
MIME-Version: 1.0
Message-ID: <47258.95113.qm@web46106.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: free_beer_for_all@yahoo.com
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

--- On Mon, 9/8/08, Georg Acher <acher@in.tum.de> wrote:

> > Or is DAB/T-DMB too different from DVB and related technologies,
> 
> DAB itself is totally different to DVB, as it has no transport stream
> equivalent. The different subchannels have different frame/packet lengths,

First, many herzlichen dank for your reply.  Now I'm going to
ask a question about something that I've just read about in
the last minutes...

Would this be somewhat comparable to the Generic Stream (GS)
of DVB-S2, particularly the Continuous mode, as opposed to the
packetised mode?


If there is to be added DVB-S2/GS ability to the relevant API,
which I suspect will be eventually necessary, as the Transport
Stream mode is a compatibility mode with DVB-S, then I am
wondering if that is reasonably close to how whatever DAB
hardware would deliver the modulated multiplex data on its
interface.

Of course, I really do not know what I'm talking about, yet.


> depending on their bitrate allocation and FEC. Also the service information
> (FIGs) has no similarity to DVB.

I would have to ask either someone familiar with the hardware
which I have, or someone who has viewed its datastream, but
if I understand what I've read so far, I should expect to need
to write a demultiplexer in userspace in order to get the
interesting data from the (1,5Mbit/sec-ish) multiplex datastream.

Anything more than that would require extending whatever API.



> closer inspection
> also shows some differences in the allowed video and audio
> codecs and how SI are handled.

If I understand correctly, the difference between DAB and DAB+
has nothing to do with the modulation -- unlike the newly-
being-tested DVB-T2, so my hardware from an API perspective
won't be magically obsoleted -- only the software player needs
AAC audio decoding ability.

Whereas, all my DVB-T devices (and DVB-C) will be obsolete in
the event that the nearby countries of interest decide to
introduce DVB-T2 -- which is not likely soon, but could happen
with the introduction of terrestrial HDTV, should those countries
actually do so, following the UK.


thanks,
barry bouwsma
P.S.:  sorry if I've posted personal mail back to the list;
using a webmail+text-browser means I don't pay attention to
things that a Real Mail Client would make clear


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
