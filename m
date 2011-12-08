Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab1LHKM2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Dec 2011 05:12:28 -0500
Message-ID: <4EE08D88.2070806@redhat.com>
Date: Thu, 08 Dec 2011 08:12:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: HVR-930C DVB-T mode report
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com>
In-Reply-To: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08-12-2011 07:10, Eddi De Pieri wrote:
> I test again HVR930C without the patch for XC5000 that added
> regression to other tuners.
>
> Attached the results using scan (ubuntu)
>
> Actually HVR-930C seems one of the usb dvb-t tuner I own with best sensitivity.
>
> using w_scan:
>
> root@depieri1lnx:~# w_scan -f t  -c IT
>
> root@depieri1lnx:~# w_scan -f t  -c IT
> w_scan version 20110616 (compiled for DVB API 5.3)
> using settings for ITALY
> DVB aerial
> DVB-T Europe
> frontend_type DVB-T, channellist 4
> output format vdr-1.6
> output charset 'UTF-8', use -C<charset>  to override
> Info: using DVB adapter auto detection.
> 	/dev/dvb/adapter0/frontend0 ->  DVB-C "DRXK DVB-C": specified was
> DVB-T ->  SEARCH NEXT ONE.
> 	/dev/dvb/adapter0/frontend1 ->  DVB-T "DRXK DVB-T": good :-)
> Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend1)
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.4
> frontend 'DRXK DVB-T' supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> FREQ (47.12MHz ... 865.00MHz)
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> Scanning 7MHz frequencies...
> 177500: (time: 00:00)
> 184500: (time: 00:03)
>
> [...]
> 834000: (time: 02:46) (time: 02:48)
> 842000: (time: 02:50)
> 850000: (time: 02:52) (time: 02:55)
> 858000: (time: 02:56) (time: 02:58)
>
> ERROR: Sorry - i couldn't get any working frequency/transponder
>   Nothing to scan!!

With regards to Italy, w_scan does something different than scan. The auto-italy
table used by scan tries several channels with both 8MHz and 7MHz, while w_scan
only tries 7MHz for VHF. This might explain the issue, if you're still able to
scan/tune with scan and if you have a good antenna.
>
>
> Regards
>
> Eddi

