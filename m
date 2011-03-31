Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:35407 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758573Ab1CaRPV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 13:15:21 -0400
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Thu, 31 Mar 2011 19:15:16 +0200
From: handygewinnspiel@gmx.de
In-Reply-To: <4D945B39.8050708@redhat.com>
Message-ID: <20110331171516.250770@gmx.net>
MIME-Version: 1.0
References: <4D909B59.9040809@redhat.com> <20110328172045.64750@gmx.net>
 <4D90D78F.7050308@redhat.com> <20110329201152.282620@gmx.net>
 <4D92697C.3030209@redhat.com> <4D945B39.8050708@redhat.com>
Subject: Re: [w_scan PATCH] Add Brazil support on w_scan
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Em 29-03-2011 20:21, Mauro Carvalho Chehab escreveu:
> > Em 29-03-2011 17:11, handygewinnspiel@gmx.de escreveu:
> >> So I changed it now to scan any srate for 6MHz networks, but skip over
> those which are unsupported by bandwidth limitation.
> ...
> > Anyway, I'll test the today's version and reply if I detect any troubles
> on it.
> 
> Test results:
> 
> 	$ ./w_scan -c BR -fc 
> Took about 30 mins for scan. As the board I'm using doesn't support
> QAM_AUTO
> for DVB-C, it seek only QAM_64

This is unexpected && should be fixed to fit to w_scan's default behaviour: first QAM_64, then QAM_256.

Can you pls re-check with the following change in countries.c line 500ff

/*
 * start/stop values for dvbc qam loop
 * 0 == QAM_64, 1 == QAM_256, 2 == QAM_128
 */
int dvbc_qam_max(int channel, int channellist) {
switch(channellist) {
       case DVBC_FI:    return 2; //QAM128
+      case DVBC_BR:
       case DVBC_FR:
       case DVBC_QAM:   return 1; //QAM256
       default:         return 0; //no qam loop
       }
}

    
int dvbc_qam_min(int channel, int channellist) {
switch(channellist) {
       case DVBC_FI:
+      case DVBC_BR:
       case DVBC_FR:
       case DVBC_QAM:   return 0; //QAM64
       default:         return 0; //no qam loop
       }
}

I don't think that adding QAM_128 makes sense. Later, if i have more reports from 6MHz network users, i will reduce the number of symbol rates.
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
