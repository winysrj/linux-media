Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1LVcUR-0000J0-Vv
	for linux-dvb@linuxtv.org; Sat, 07 Feb 2009 03:00:16 +0100
Date: Sat, 7 Feb 2009 02:57:44 +0100
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090207015744.GA19668@raven.wolf.lan>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Tuning problems with loss of TS packets
Reply-To: linux-media@vger.kernel.org
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

Hello,

sometimes, I experience non-deterministic problems with tuning on some
transponders with dvb-s.  For example, on astra-H-11954, I have about
50% chance to get a good tune.  If I get a bad tune, I still receive
TS packets from the chosen transponder, but about 10%..20% of the
packets are lost.  The (remaining) packets contain PAT/PMT/PES packets
from the chosen transponder, so it is pretty safe to assume that
actual tuning worked properly.

What I do is pretty much straight forward:

  1. open frontend/dmx/dvr devices
  2. send diseqc command to switch to desired input
  3. use FE_SET_FRONTEND ioctl to tune to desired transponder
  4. wait for FE_HAS_LOCK
  5. set dmx_pesfilter_params to:
         pid:      0x2000  /* yes, I want the whole transponder */
         input:    DMX_IN_FRONTEND
         output:   DMX_OUT_TS_TAP
         pes_type: DMX_PES_OTHER
         flags:    DMX_IMMEDIATE_START

With this sequence, I have about 50% chance to receive a proper TS
stream.  When the stream is not OK, I can see about 10%..20% loss
of TS packets.

I have checked signal quality, but there is no significant difference
from working to non-working:

   Status:1f sig:ac80 snr:d9e0 ber:00000000 unc:fffffffe FE_HAS_LOCK
   Status:1f sig:adbe snr:dac4 ber:00000000 unc:fffffffe FE_HAS_LOCK

So I have tried to narrow the problem, and I think I've come pretty
close (but still no cigar):

Once the sequence (which is listed above) is completed, I can easily
(but randomly, IOW: I have to try 1..3 times) switch from proper stream
to broken stream and vice-versa simply by repeating step 3 with _exactly_
the _same_ values.

To be precise: on an already set-up transponder, re-executing this
function:

  static void tune_frequency (int ifreq, int sr)
  {
      struct dvb_frontend_parameters tuneto;
  
      tuneto.frequency = ifreq*1000;
      tuneto.inversion = INVERSION_AUTO;
      tuneto.u.qpsk.symbol_rate = sr*1000;
      tuneto.u.qpsk.fec_inner = FEC_AUTO;
      
      if (ioctl(fefd, FE_SET_FRONTEND, &tuneto) == -1) {
          fatal ("FE_SET_FRONTEND failed: %s\n", strerror (errno));
      }
  }

with _exactly_ the same values for ifreq and sr, is able to toggle from
good TS stream to bad TS stream or vice-versa.  As long as I avoid to
call this function, the quality of the stream does _not_ change.

I have tried to use fixed values instead of *_AUTO for FEC and INVERSION,
but that did not help either.

Any ideas?


BTW:
 $ lspci -v
 [ ... ]
 03:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
         Subsystem: Technotrend Systemtechnik GmbH Technotrend-Budget/Hauppauge WinTV-NOVA-CI DVB card
         Flags: bus master, medium devsel, latency 32, IRQ 21
         Memory at fdcfe000 (32-bit, non-prefetchable) [size=512]
         Kernel driver in use: budget_ci dvb
         Kernel modules: snd-aw2, budget-ci
 $ uname -a
 Linux raven 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_64 x86_64 x86_64 GNU/Linux

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
