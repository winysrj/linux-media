Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34209
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751436AbdBTKE4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 05:04:56 -0500
Date: Mon, 20 Feb 2017 06:52:53 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Marcel Heinz <quisquilia@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>
Subject: Re: Bug#854100: libdvbv5-0: fails to tune / scan
Message-ID: <20170220065253.25e0d44b@vento.lan>
In-Reply-To: <ac7c042a-e636-adf3-6f2e-a1e9d9f4525f@gmx.de>
References: <ac7c042a-e636-adf3-6f2e-a1e9d9f4525f@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Feb 2017 22:50:57 +0100
Marcel Heinz <quisquilia@gmx.de> escreveu:

> Hi,
> 
> Am 13. Februar 2017 schrieb Mauro Carvalho Chehab:
> 
> > Em Fri, 10 Feb 2017 22:02:01 +0100
> > Gregor Jasny <gjasny@xxxxxxxxxxxxxx> escreveu:
> >   
> >> Bug report against libdvbv5 is here:
> >> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=854100  
> > 
> > There was a bug at the logic that was checking if the frequency was
> > at the range of the local oscillators. This patch should be addressing
> > it:
> > 	https://git.linuxtv.org/v4l-utils.git/commit/?id=5380ad44de416a41b4972e8a9c147ce42b0e3ba0
> > 
> > With that, the logic now seems to be working fine:
> > 
> > $ ./utils/dvb/dvbv5-scan ~/Intelsat-34 --lnbf universal -vv
> > Using LNBf UNIVERSAL
> > 	Universal, Europe
> > 	10800 to 11800 MHz, LO: 9750 MHz
> > 	11600 to 12700 MHz, LO: 10600 MHz
> > ...
> > Seeking for LO for 12.17 MHz frequency
> > LO setting 0: 10.80 MHz to 11.80 MHz
> > LO setting 1: 11.60 MHz to 12.70 MHz
> > Multi-LO LNBf. using LO setting 1 at 10600.00 MHz
> > frequency: 12170.00 MHz, high_band: 1
> > L-Band frequency: 1570.00 MHz (offset = 10600.00 MHz)
> > 
> > I can't really test it here, as my satellite dish uses a different
> > type of LNBf, but, from the above logs, the bug should be fixed.
> > 
> > Marcel,
> > 
> > Could you please test? The patch is already upstream.
> > I added a debug patch after it, in order to help LNBf issues
> > (enabled by using "-vv" command line parameters).  
> 
> I can confirm that 1.12.3 solves the issue for me. Thanks for the fix.

Good!

Thanks for testing!

Regards,
Mauro
