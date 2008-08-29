Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oscarmax3@gmail.com>) id 1KZ9aR-0002v8-UJ
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 21:24:58 +0200
Received: by ey-out-2122.google.com with SMTP id 25so322688eya.17
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 12:24:43 -0700 (PDT)
Message-ID: <48B84D78.3050609@gmail.com>
Date: Fri, 29 Aug 2008 21:26:48 +0200
From: Carl Oscar Ejwertz <oscarmax3@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] VP3030 DVB-T disabled in Manu Mantis tree Why?
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

Im curious about the reason the VP3030 card is disabled in the Manu 
Mantis tree.
in mantis_dvb.c

it's commented out.. and I wonder what the reason.. is the VP3030 card 
crap and never will work or?
#if 0
    case MANTIS_VP_3030_DVB_T:    // VP-3030
        dprintk(verbose, MANTIS_ERROR, 1, "Probing for 10353 (DVB-T)");
        mantis->fe = zl10353_attach(&mantis_vp3030_config, 
&mantis->adapter);
        if (mantis->fe) {
            if (dvb_pll_attach(mantis->fe,
                       0x60,
                       &mantis->adapter,
                       &dvb_pll_env57h1xd5) < 0) {

                return -EIO;
            }
            dprintk(verbose, MANTIS_ERROR, 1,
                "Mantis DVB-T Zarlink 10353 frontend attach success");
        }
        break;
#endif

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
