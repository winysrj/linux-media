Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1K2QTC-0002cU-3r
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 14:46:04 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 31 May 2008 14:45:04 +0200
References: <482560EB.2000306@gmail.com>
	<200805310146.30798@orion.escape-edv.de>
	<4840FBED.3050902@gmail.com>
In-Reply-To: <4840FBED.3050902@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805311445.04487@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021 and
	stv0297
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

e9hack wrote:
> Oliver Endriss schrieb:
> > Hi,
> > 
> > I just wanted to commit this changeset when I spotted this:
> > 
> > e9hack wrote:
> >> @@ -266,6 +268,10 @@ static int tda10021_set_parameters (stru
> >>  
> >>         tda10021_setup_reg0 (state, reg0x00[qam], p->inversion);
> >>  
> >> +       /* reset uncorrected block counter */
> >> +       state->last_lock = 0;
> >> +       state->ucblocks = 0;
> > 
> > Note that UCB must count the number of uncorrected blocls during the
> > lifetime of the driver. So it must not be reset during tuning.
> 
> I've add this reset for two reasons:
> 
> 1) My second card uses a stv0297. The UCB value is always reset during the tuning, because 
> the stv0297 is completely reinitialized. This occurs, if the frequency is changed or if 
> the frontend lost the lock. I've add the reset to see the same behavior within the 
> femon-plugin for both cards.

Then the stv0297 must also be fixed. This can be achieved by adding a
software counter to the state struct.

> 2) Above 650MHz, the signal strength of my cable is very low. It isn't usable. I get high 
> BER and UCB values. The card with the tda10021 is a budget one. It is used for epg 
> scanning in the background. It isn't possible to compare the UCB values of both cards, if 
> the cards are tuned to the same frequency/channel and if the tda10021 was previous tuned 
> to a frequency with a low signal.

The API is clear: The UNC counter starts when the driver is loaded and
counts up until the driver is unloaded.

Sorry, I will not replace one faulty implementation by another faulty
implementation.

A counter starting at channel switch can be implemented by using the
cStatus class of VDR. cStatus::ChannelSwitch() will notify a plugin
whenever a channel switch happens, so it is very easy to capture the
UNC value at channel switch (UNCsw).

Finally, the plugin may display the value (UNC - UNCsw), and you have
the desired behaviour without breaking the API.

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
