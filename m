Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47467 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaD2V5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 17:57:21 -0400
Received: by mail-wg0-f50.google.com with SMTP id k14so841441wgh.21
        for <linux-media@vger.kernel.org>; Tue, 29 Apr 2014 14:57:20 -0700 (PDT)
Date: Tue, 29 Apr 2014 22:57:17 +0100
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: Oliver Schinagl <oliver@schinagl.nl>
Cc: linux-media@vger.kernel.org, 746404@bugs.debian.org,
	fredboboss <fredSPAM_IS_EVILboboss@free.fr>
Subject: Fwd: Bug#746404: dtv-scan-tables: /usr/share/dvb/dvb-t/fr-all file :
 invalid enum and no DVB-T services found
Message-ID: <20140429215717.GA9139@lambda.dereenigne.org>
References: <20140429175057.15801.6071.reportbug@pif>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429175057.15801.6071.reportbug@pif>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

Please find Debian bug report from fredboboss regarding
dtv-scan-tables below.

Thanks,
Jon

On Tue, 29 Apr 2014 19:50:57 +0200, fredboboss wrote:
> Package: dtv-scan-tables
> Version: 0+git20140326.cfc2975-1
> Severity: normal
>
> Dear Maintainer,
>
> Dear Debian Maintainer,
>
> when performing a DVB-T frequency scan with the /usr/bin/scan utility (dvb-apps package) and the /usr/share/dvb/dvb-t/fr-All frequency file (dtv-scan-tables packages) the following 2 problems occur :
>
> 1) file parsing error :
> ERROR: invalid enum value '8MHZ'
> ERROR: invalid enum value '8K'
>
> 2) in the end no DVB-T services are found with a Hauppauge NOVA-TD-500 DVB-T card.
>
> Those problems seem to come from the /usr/share/dvb/dvb-t/fr-All file.
>
> The following changes are proposed in this file :
>
> For 1) :
> - 8MHZ changed by 8MHz
> - 8K changed by 8k
>
> For 2) :
> - change FEC_HI parameter by AUTO
>
> Thus the 1st frequency line of the file would be changed like that :
> -T 474000000 8MHZ 2/3 NONE QAM64 8K 1/32 NONE #Channel UHF 21
> +T 474000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 21
>
> (Please refer to the end of the mail for the complete modified file).
>
> Thanks to those modifications I successfully performed a DVB-T scan with the NOVA TD-500 card.
>
> In case more information is needed don't hesitate to contact me.
>
> Best regards,
> Fred
>
> -- System Information:
> Debian Release: jessie/sid
>   APT prefers testing-updates
>   APT policy: (500, 'testing-updates'), (500, 'testing')
> Architecture: amd64 (x86_64)
>
> Kernel: Linux 3.13-1-amd64 (SMP w/4 CPU cores)
> Locale: LANG=C, LC_CTYPE=en_US.utf8 (charmap=UTF-8)
> Shell: /bin/sh linked to /bin/dash
>
> -- no debconf information
>
> Modified file :
> # France ALL (All channel 21 to 60)
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 474000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 21
> T 482000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 22
> T 490000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 23
> T 498000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 24
> T 506000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 25
> T 514000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 26
> T 522000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 27
> T 530000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 28
> T 538000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 29
> T 546000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 30
> T 554000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 31
> T 562000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 32
> T 570000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 33
> T 578000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 34
> T 586000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 35
> T 594000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 36
> T 602000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 37
> T 610000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 38
> T 618000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 39
> T 626000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 40
> T 634000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 41
> T 642000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 42
> T 650000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 43
> T 658000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 44
> T 666000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 45
> T 674000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 46
> T 682000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 47
> T 690000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 48
> T 698000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 49
> T 706000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 50
> T 714000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 51
> T 722000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 52
> T 730000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 53
> T 738000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 54
> T 746000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 55
> T 754000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 56
> T 762000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 57
> T 770000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 58
> T 778000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 59
> T 786000000 8MHz AUTO NONE QAM64 8k 1/32 NONE #Channel UHF 60
