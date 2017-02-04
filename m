Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34800 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753745AbdBDJIT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2017 04:08:19 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so9818171wmi.1
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2017 01:08:19 -0800 (PST)
Subject: Re: Bug#854100: libdvbv5-0: fails to tune / scan
To: Marcel Heinz <quisquilia@gmx.de>, 854100@bugs.debian.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <148617570740.6827.6324247760769667383.reportbug@ixtlilton.netz.invalid>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <0db3f8d1-0461-5d82-a92d-ecc3cfcfec71@googlemail.com>
Date: Sat, 4 Feb 2017 10:08:16 +0100
MIME-Version: 1.0
In-Reply-To: <148617570740.6827.6324247760769667383.reportbug@ixtlilton.netz.invalid>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2/4/17 3:35 AM, Marcel Heinz wrote:
> After the upgrade from libdvbv5-0 1.10.1-1 to 1.12.2-2, any applications
> using libdvbv5-0 fail to work with my DVB-S card.
> 
> Output with old dvb-tools / libdvbv5-0 1.10.1-1:
> 
> |$ dvbv5-scan -l UNIVERSAL /usr/share/dvb/dvb-s/Astra-19.2e
> |Using LNBf UNIVERSAL
> |        Europe
> |        10800 to 11800 MHz and 11600 to 12700 MHz
> |	 Dual LO, IF = lowband 9750 MHz, highband 10600	MHz
> |ERROR    command BANDWIDTH_HZ (5) not found during retrieve
> |Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable (yet).
> |Scanning frequency #1 12551500
> |Lock   (0x1f) Signal= 85,55% C/N= 99,84% postBER= 0
> | [scan runs normally from then on]
> 
> Output with new dvb-tools / libdvbv5-0 1.12.2-2:
> 
> |$ dvbv5-scan -l UNIVERSAL /usr/share/dvb/dvb-s/Astra-19.2e
> |Using LNBf UNIVERSAL
> |        Europe
> |        10800 to 11800 MHz and 11600 to 12700 MHz
> |	 Dual LO, IF = lowband 9750 MHz, highband 10600	MHz
> |ERROR    command BANDWIDTH_HZ (5) not found during retrieve
> |Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable (yet).
> |Scanning frequency #1 12551500
> |ERROR    FE_SET_PROPERTY: Invalid argument
> |ERROR    dvb_fe_set_parms failed: Invalid argument
> 
> Similarily, kaffeine fails to tune to any channel, or to do a scan.
> Other applications not using libdvbv5-0 (mplayer, tvheadend) still
> work fine with the card.
> 
> DVB device is:
> 
> |$ dmesg | grep DVB
> | [    8.641450] DVB: registering new adapter (FlexCop Digital TV device)
> | [    8.662380] b2c2_flexcop_pci 0000:09:00.0: DVB: registering adapter 0 frontend 0 (Conexant CX24123/CX24109)...
> | [    8.662664] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S rev 2.8' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
> 
> -- System Information:
> Debian Release: 9.0
>   APT prefers testing
>   APT policy: (500, 'testing')
> Architecture: amd64 (x86_64)
> Foreign Architectures: i386
> 
> Kernel: Linux 4.9.0-1-amd64 (SMP w/4 CPU cores)
> Locale: LANG=de_DE.UTF-8, LC_CTYPE=de_DE.UTF-8 (charmap=UTF-8)
> Shell: /bin/sh linked to /bin/dash
> Init: systemd (via /run/systemd/system)

Mauro, do you have an idea why tuning broke?

Thanks,
Gregor
