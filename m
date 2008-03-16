Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [212.57.247.218] (helo=glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1JauWM-0007C9-Ht
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 16:11:34 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Sun, 16 Mar 2008 15:11:01 -0000
Message-ID: <A33C77E06C9E924F8E6D796CA3D635D102397C@w2k3sbs.glcdomain.local>
From: "Michael Curtis" <michael.curtis@glcweb.co.uk>
To: <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVB-S DVB-S2 and CI cards working on Linux
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

Thank you for ypor reply Dominic

The errors below are shown in dmesg on reboot in order to automatically
load all the required modules, that is no attempt to tune the card to
any station

Oddly, when I compiled and installed the modules manually, this message
did not appear

Rgds Mike

> >
> > I have had a TT3200 DVB-S2/CI card for more than a year and I have
still
> > not got this to work using the Multiproto drivers on Linux, in fact
it
> > seem that I am going backwards with this card with the latest errors
> > appearing in dmesg:
> >
> > stb0899_search: Unsupported delivery system
> There has been an api update. make sure you're tuning application does
a
> 
> dvbfe_delsys delsys = DVBFE_DELSYS_DVBS;
> ioctl(front, DVBFE_SET_DELSYS, &delsys);
> 
> before other tuning ioctls.
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
