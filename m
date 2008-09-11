Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38804.mail.mud.yahoo.com ([209.191.125.95])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1Kdn4t-00019L-Js
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 16:23:25 +0200
Date: Thu, 11 Sep 2008 07:22:48 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: linux-dvb@linuxtv.org, Christophe Thommeret <hftom@free.fr>
In-Reply-To: <200809111535.19315.hftom@free.fr>
MIME-Version: 1.0
Message-ID: <740897.54819.qm@web38804.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] Multiple frontends on a single adapter support
Reply-To: urishk@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>




--- On Thu, 9/11/08, Christophe Thommeret <hftom@free.fr> wrote:

> From: Christophe Thommeret <hftom@free.fr>
> Subject: [linux-dvb] Multiple frontends on a single adapter support
> To: linux-dvb@linuxtv.org
> Date: Thursday, September 11, 2008, 4:35 PM
> Hi all,
> =

> ( Please don't mix this thread with the "DVB-S2 /
> Multiproto and future =

> modulation support" thread. )
> =

> Summary:
> =

> Some devices provide several tuners, even of different
> types.
> So called "Dual" or "Twin" tuners can
> be used at the same time.
> Some others (like HVR4000) can't be used at the same
> time.
> =

> My initial question was: How could an application know that
> 2 (or more) tuners =

> are exclusive (when one is used the other(s) is(are) not
> free.)
> =

> I suggested the following:
> Since actually all multiple tuners drivers expose several
> fontend0 in separate =

> adapters, maybe a solution for exclusive tuners could be to
> have :
> - adapter0/frontend0 -> S/S2 tuner
> - adapter0/frontend1 -> T tuner
> so, an application could assume that these tuners are
> exclusive.
> =

> Janne Grunau acked the idea and said that an experimental
> driver for HVR4000 =

> is already doing this.
> =

> This was confirmed by Steven Toth:
> "Correct, frontend1, demux1, dvr1 etc. All on the same
> adapter. The =

> driver and multi-frontend patches manage exclusive access
> to the single =

> internal resource."
> 	=

> Andreas Oberritter said:
> "This way is used on dual and quad tuner Dreambox
> models." (non exclusive =

> tuners).
> "How about dropping demux1 and dvr1 for this adapter
> (exclusive tuners), since =

> they don't create any benefit? IMHO the number of demux
> devices should always =

> equal the number of simultaneously usable transport stream
> inputs."
> =

> Uri Shkolnik said:
> "Some of the hardware devices which using our chipset
> have two tuners per =

> instance, and should expose 1-2 tuners with 0-2 demux (TS),
> since not all DTV =

> standard are TS based, and when they are (TS based), it
> depends when you are =

> using two given tuners together (diversity =A0mode, same
> content) or each one =

> is used separately (different frequency and modulation,
> different content, =

> etc.)."
> =

> =

> =

> So, here are my questions:
> =

> @Steven Toth:
> What do you think of Andreas' suggestion? Do you think
> it could be done that =

> way for HVR4000 (and 3000?) ?
> =

> @Uri Shkolnik:
> Do you mean that non-TS based standards don't make use
> of multiplexing at all?
> =


Take CMMB for example, some standard's options are that the content is RTP =
based, so the content path is via the IP stack, another CMMB mode is Mpeg4 =
frames. =

DAB (and DAB-IP) are other good examples.

By demux.h ( http://www.linuxtv.org/cgi-bin/viewcvs.cgi/dvb-kernel-v4/linux=
/include/linux/dvb/demux.h?view=3Dmarkup ) demux is "de-multiplexing of a t=
ransport stream (TS)", since those standards are not TS based, they can not=
 be "demuxed". If its an IP-based DTV standard, you just create a pipe from=
 the device into the IP stack and pass all content. If it a frames based st=
andards, you need other mechanism, anyway, you don't need a demux =


> =

> -- =

> Christophe Thommeret
> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
