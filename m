Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from dora.fastpath.it ([66.150.225.37])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marauder@tiscali.it>) id 1JM6Qq-0005sn-Ur
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 19:52:41 +0100
Date: Mon, 4 Feb 2008 19:21:48 +0100
From: David Santinoli <marauder@tiscali.it>
To: Christoph Pfister <christophpfister@gmail.com>
Message-ID: <20080204182148.GA27742@aidi.santinoli.com>
References: <20080202182112.GB5259@aidi.santinoli.com>
	<19a3b7a80802021030sd4e1e8awaf0f156bb57003ba@mail.gmail.com>
	<20080202201507.GA5566@aidi.santinoli.com>
	<19a3b7a80802021222m5bc38e90w22230a8256df7544@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19a3b7a80802021222m5bc38e90w22230a8256df7544@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Satelco EasyWatch + Cryptoworks
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, Feb 02, 2008 at 09:22:22PM +0100, Christoph Pfister wrote:
> > while gnutv reported this (and no stream was present at dvr0):
> 
> You can run "gnutv -out dvr" or "gnutv -out file <filename>".

These are the outcomes of my latest experiments with the various tuning
utilities.  All tests refer to the tuning of JSTV1 (Cryptoworks).

- gnutv, zap:
  Most of the time unable to lock in the encrypted channel.
  The status line keeps udating and displays data similar to these:

  status SC    | signal c080 | snr aa88 | ber 0000ff20 | unc 00000000 |

  In this situation, no stream is available on dvr0, or written to a
  file. 

  However, once in a while, launching these utilities results in
  correct locking of the channel.  In this case the status line gets
  displayed only once (no update), as in

  status SCVYL | signal c440 | snr d119 | ber 00000900 | unc 00000000 | FE_HAS_LOCK

  and is shortly followed by the "Received new PMT - sending to CAM..."
  message.  In this case, decryption is OK.

- szap:
  always succeeds in locking the channel (but of course, no decryption):

  status 1f | signal c586 | snr d0f5 | ber 00000000 | unc 00000000 | FE_HAS_LOCK


Does the snr play any role in the inability of zap/gnutv to tune che
channel in?  (To my unexperienced eye, all FE_HAS_LOCKs seem to occur
only when snr is above a certain threshold.)
Do the tuning mechanisms in gnutv/zap and szap differ somehow?

Thanks to anyone willing to shed some light on this.
 David

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
