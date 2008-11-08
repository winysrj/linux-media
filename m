Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-1.orange.nl ([193.252.22.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1KyrCp-0006Ul-UN
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 18:02:40 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf6004.online.nl (SMTP Server) with ESMTP id 4E6DC1C00086
	for <linux-dvb@linuxtv.org>; Sat,  8 Nov 2008 18:02:06 +0100 (CET)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134])
	by mwinf6004.online.nl (SMTP Server) with ESMTP id 176D01C00085
	for <linux-dvb@linuxtv.org>; Sat,  8 Nov 2008 18:02:02 +0100 (CET)
Message-ID: <4915C608.9000709@verbraak.org>
Date: Sat, 08 Nov 2008 18:02:00 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to find which command generates error in
	FE_SET_PROPERTY
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

I'm trying to modify one of my applications to use the new S2API. With 
this application I control my dvb-t and dvb-s/s2 receivers.

I'm using szap-s2 as an example but I run into a problem that the ioctl 
FE_SET_PROPERTY always returns -1 and variable errno is set to 14.

My question is. How do I determine which of the commands in the command 
queue given to FE_SET_PROPERTY is producing this error. I did not try 
yet to devide my command queue up into one command queue per command.

Regards,

Michel.

Part of source code for dvb-s/s2:

#ifdef S2API
int TDVBDevice::SetProperty(struct dtv_property *cmdseq)
{
  int err;

  err = ioctl(vfrontendfd, FE_SET_PROPERTY, cmdseq);

  if (err < 0)
  {
    syslog(LOG_ERR, "ioctl FE_SET_PROPERTY failed (errno=%d, 
%d).",errno, err);
    return -1;
  }

  syslog(LOG_INFO, "ioctl FE_SET_PROPERTY ok.");
  return 0;
}
#else
int TDVBDevice::SetFrontend(struct dvb_frontend_parameters *frontend)
{
  if (ioctl(vfrontendfd, FE_SET_FRONTEND, frontend) < 0)
  {
    syslog(LOG_ERR, "ioctl FE_SET_FRONTEND failed (errno=%d).",errno);
    return -1;
  }

  return 0;
}
#endif

//calling part
#ifdef S2API
    struct dtv_property p[DTV_IOCTL_MAX_MSGS];

    p[0].cmd = DTV_CLEAR;
    p[1].cmd = DTV_DELIVERY_SYSTEM; p[1].u.data = atoi(channel->Item(2));
    p[2].cmd = DTV_FREQUENCY;       p[2].u.data = (__u32)(ifreq * 1000);
    p[3].cmd = DTV_MODULATION;      p[3].u.data = QPSK;
    p[4].cmd = DTV_SYMBOL_RATE;     p[4].u.data = (__u32)(sr * 1000);
    p[5].cmd = DTV_INNER_FEC;       p[5].u.data = FEC_AUTO;
    p[6].cmd = DTV_INVERSION;       p[6].u.data = INVERSION_AUTO;
       //     { .cmd = DTV_ROLLOFF,           .u.data = rolloff },
    p[7].cmd = DTV_PILOT;           p[7].u.data = PILOT_AUTO;
    p[8].cmd = DTV_TUNE;

    struct dtv_properties cmdseq;

    cmdseq.num = 9;
    cmdseq.props = p;

#else 
    frontend.frequency = (unsigned int)(ifreq * 1000);
    frontend.inversion = INVERSION_AUTO;
    frontend.u.qpsk.symbol_rate = (unsigned int)(sr * 1000);
    frontend.u.qpsk.fec_inner = FEC_AUTO;
#endif

#ifdef S2API
      if (SetProperty(&p[0]) == 0)
#else
      if (SetFrontend(&frontend) == 0)
#endif



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
