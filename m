Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2AHM5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jan 2012 07:57:51 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q08Cvpq7032505
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 8 Jan 2012 07:57:51 -0500
Received: from [10.3.231.107] (vpn-231-107.phx2.redhat.com [10.3.231.107])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q08Cvmot010126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 8 Jan 2012 07:57:50 -0500
Message-ID: <4F0992CB.6020702@redhat.com>
Date: Sun, 08 Jan 2012 10:57:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: dvbv5-tools update - was: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com> <4F08F6EB.2030508@redhat.com>
In-Reply-To: <4F08F6EB.2030508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-01-2012 23:52, Mauro Carvalho Chehab wrote:
> I decided to add support for DVB-S, even without signal for testing.
> This probably means that it likely will not work ;) Well, seriously,
> we need testers for it.
> 
> The current code should be doing the same that szap does, and should
> work with both dvbv5-zap and dvbv5-scan. The DISEqC code there is very
> simple, and there's no support for dishpro/bandstacking yet. It is
> probably not hard to add support for it.
> 
> There are still a few things missing there. For example, the current
> code will only use DISEqC satellite #0, as there's no code to change
> the satellite number yet.
> 
> Anyway, testing and patches are welcome!

I decided to rewrite the DISEqC code on it, in order to fix some
bugs, and make the code clearer.

The updates are at the tree:
	http://git.linuxtv.org/v4l-utils.git

Basically, additional parameters for satellite delivery systems
are now added to the zap and scan tools:

        - l <lnbf>
selects the LNBf type. Using an invalid value like "help" shows
what's currently supported.

        - S <sat_number>
Selects satellite number, between 0 to 3. If not specified,
disables DISEqC. This actually changes the DISEqC "option" 
and "position" parameter. According with the specs, for 
position B, tone should be off, and tone burst should
be miniA. 

        -W <extra time in ms>
The DISEqC logic will wait for 15 ms. If this parameter is         
specified, it will add  the extra time to the 15ms delay.

For LNBf devices that use bandstacking (e. g. they use different
LO frequrencies for V and H polarization), the code will     
always use 13 Volts and will disable tone/tone burst.

Currently, C-Band multi and DishPro bandstacking LNBf's are
supported.

The code should now work with the following LNBfs:

UNIVERSAL
        Europe
        10800 to 11800 MHz and 11600 to 12700 MHz
        Dual LO, IF = lowband 9750 MHz, highband 10600 MHz

DBS
        Expressvu, North America
        12200 to 12700 MHz
        Single LO, IF = 11250 MHz

STANDARD
        Standard
        10945 to 11450 MHz
        Single LO, IF = 10000 MHz

ENHANCED
        Astra
        10700 to 11700 MHz
        Single LO, IF = 9750 MHz

C-BAND
        Big Dish - Monopoint LNBf
        3700 to 4200 MHz
        Single LO, IF = 5150 MHz

C-MULT
        Big Dish - Multipoint LNBf
        3700 to 4200 MHz
        Dual LO, Bandstacking, LO POL_R 5150 MHZ, LO POL_L 5750 MHz

DISHPRO
        DishPro LNBf
        12200 to 12700 MHz
        Dual LO, Bandstacking, LO POL_R 11250 MHZ, LO POL_L 14350 MHz

Tests are needed!

Regards,
Mauro
