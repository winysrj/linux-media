Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <martin.hurton@gmail.com>) id 1KXbAj-0000nL-27
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 14:27:49 +0200
Received: by gv-out-0910.google.com with SMTP id n29so270725gve.16
	for <linux-dvb@linuxtv.org>; Mon, 25 Aug 2008 05:27:45 -0700 (PDT)
Date: Mon, 25 Aug 2008 14:27:41 +0200
From: Martin Hurton <martin.hurton@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20080825122741.GB17421@optima.lan>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] TT S2-3200 + CI Extension
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

Hi List,

I have the TT-budget S2-3200 card with CI Extension and have problem
to get it work with my CAM module. I have tried different CI Extensions,
different CI cables, different CAM modules, and also different computers 
but still without any success. I am using multiproto driver.

Debugging the driver I have found the problem is in the following code:
(budget-ci.c).

507     ci_version = ttpci_budget_debiread(&budget_ci->budget, DEBICICTL, DEBIADDR_CIVERSION, 1, 1, 0);
508     if ((ci_version & 0xa0) != 0xa0) {
509             result = -ENODEV;
510             goto error;
511     }

it seems the driver expects the high nibble of ci_version to be 0xa but in my case,
the ci_version is always zero. And because of this, the CA is not supported.

Did anybody have this same problem? Or can somebody explains why this happens?
Any help will be greatly appreciated.

Regards,
/Martin


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
