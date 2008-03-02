Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVwuI-0008IX-In
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:43:46 +0100
Message-ID: <47CB2D95.6040602@gmail.com>
Date: Mon, 03 Mar 2008 02:43:33 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Florian Lohoff <flo@rfc822.org>
References: <20080301161419.GB12800@paradigm.rfc822.org>
In-Reply-To: <20080301161419.GB12800@paradigm.rfc822.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVBFE_SET_PARAMS / delsys from fe_info ioctl ?
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

Florian Lohoff wrote:
> Hi,
> i was wondering why i have a problem in my application that i need to
> run scan once after loading the module, otherwise my DVBFE_SET_PARAMS
> fails - I couldnt explain it until i looked into the kernel code - In
> the dvb_frontend.c i see this code:
> 
> 1738         case DVBFE_SET_PARAMS: {
> 1739                 struct dvb_frontend_tune_settings fetunesettings;
> 1740                 enum dvbfe_delsys delsys = fepriv->fe_info.delivery;
> ...
> 1783                 } else {
> 1784                         /* default values */
> 1785                         switch (fepriv->fe_info.delivery) {
> ...
> 1817                         default:
> 1818                                 up(&fepriv->sem);
> 1819                                 return -EINVAL;
> 1820                         }
> 
> Should the code use fepriv->feparam.delivery instead of
> fepriv->fe_info.delivery to sense the right delivery system ?

Which demodulator driver are you using to test your application ?

Though a bug, but that won't make any difference to what you are looking at,
since the delay and others are used in the case of swzigzag, which 
doesn't exist
at least for the existing demods using the track() callback at all.

This would be a fix for any demod drivers using the set_params() callback.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
