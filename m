Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K8gIS-0003oY-7p
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 20:52:49 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 17 Jun 2008 20:51:50 +0200
References: <1212585271.32385.41.camel@pascal>
	<1212590233.15236.11.camel@rommel.snap.tv>
	<1212657011.32385.53.camel@pascal>
In-Reply-To: <1212657011.32385.53.camel@pascal>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806172051.50308@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
Reply-To: linux-dvb@linuxtv.org
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

Sigmund Augdal wrote:
> On Wed, 2008-06-04 at 16:37 +0200, Sigmund Augdal wrote:
> > ons, 04.06.2008 kl. 16.58 +0300, skrev Antti Palosaari:
> > > Sigmund Augdal wrote:
> > > > The following experimental patch adds support for the technotrend budget
> > > > C-1501 dvb-c card. The parameters used to configure the tda10023 demod
> > > > chip are largely determined experimentally, but works quite for me in my
> > > > initial tests.
> > > 
> > > You finally found correct values :) I see that it uses same clock 
> > > settings than Anysee. Also deltaf could be correct because I remember 
> > > from my tests that it cannot set wrong otherwise it will not work at 
> > > all. How did you find defltaf?
> > I guessed the clock settings based on how the same tuner is used by a
> > different demod. The deltaf value was found by trial and error (helped
> > by some scripting). deltaf values slightly off will also work, but
> > tuning will be very slow. I also think the deltaf value will depend on
> > the bandwidth of the transponder tuned. All transponders I've tested
> > with are 8MHz, but I think other values are possible, and these will
> > most likely not work. I submitted the patch anyway in the hope that some
> > broader testing might help uncover any remaining problems.
> > > 
> > > Your patch has at least coding style issues, please run make checkpatch 
> > > fix errors and resend patch.
> > I was trying to follow the guidelines, but I guess I wasn't doing that
> > good enough. Will try to clean that up and resend soon.
> Here is a new version. This one passes checkpatch without warnings. I
> removed the read_pwm function, as it always uses the fallback path for
> my card (and frankly I have no idea wether it is actually relevant at
> all for this kind of card). Furthermore the tda10023 driver doesn't seem
> to use this value for anything.

Patch applied with minor modifications:
- error handling: detach frontend if tda827x_attach fails
- use lower case characters for hex constants
- make the code more readable (better ignore 'line length warnings'
  if the resulting code would look too bad)

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
