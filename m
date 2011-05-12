Return-path: <mchehab@gaivota>
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:64488
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab1ELOX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 10:23:56 -0400
Message-ID: <4DCBEB52.5060808@iinet.net.au>
Date: Thu, 12 May 2011 22:14:42 +0800
From: Mike <michael.stock@iinet.net.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Bug in HVR1300. Found part of a patch, if reverted
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi there

in the latest kernel (and all those since when the patch was written) 
this patch is still required for the HVR-1300 to work, any chance of it 
getting incorporated?

thanks
Mike

 > Hi list,
 >
 > there seems to be a bug in cx88 (HVR1300) that is responsible for not
 > switching channels, and not being able to scan.
 > Complete description can be found on launchpad:
 >
 > https://bugs.launchpad.net/mythtv/+bug/439163 (starting from comment #16)
 >
 > Anyway, i digged it down to this patch:
 > http://www.mail-archive.com/linuxtv-commits@xxxxxxxxxxx/msg02195.html
 >
 > When reverting the following part of the patch it starts working again:
 >
 > snip----------
 >
 > diff -r 576096447a45 -r d2eedb425718
 > linux/drivers/media/video/cx88/cx88-dvb.c
 > - --- a/linux/drivers/media/video/cx88/cx88-dvb.c Thu Dec 18 07:28:18 
2008
 > - -0200
 > +++ b/linux/drivers/media/video/cx88/cx88-dvb.c Thu Dec 18 07:28:35 2008
 > - -0200
 > @@ -1135,40 +1135,44 @@ static int cx8802_dvb_advise_acquire(str
 > * on the bus. Take the bus from the cx23416 and enable the
 > * cx22702 demod
 > */
 > - - cx_set(MO_GP0_IO, 0x00000080); /* cx22702 out of reset and
 > enable */
 > + /* Toggle reset on cx22702 leaving i2c active */
 > + cx_set(MO_GP0_IO, 0x00000080);
 > + udelay(1000);
 > + cx_clear(MO_GP0_IO, 0x00000080);
 > + udelay(50);
 > + cx_set(MO_GP0_IO, 0x00000080);
 > + udelay(1000);
 > + /* enable the cx22702 pins */
 > cx_clear(MO_GP0_IO, 0x00000004);
 > udelay(1000);
 > break;
 > - ---------snip
 >
 > Regards
 >
 > Frank Sagurna

