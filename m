Return-path: <mchehab@pedra>
Received: from nm15-vm1.bullet.mail.sp2.yahoo.com ([98.139.91.209]:39490 "HELO
	nm15-vm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751935Ab1EXFDm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 01:03:42 -0400
Message-ID: <534527.68662.qm@web112007.mail.gq1.yahoo.com>
Date: Mon, 23 May 2011 22:03:41 -0700 (PDT)
From: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 23/05/11 18:54, javier Martin wrote:
> On 23 May 2011 05:01, Chris Rodley <carlighting@yahoo.co.nz> wrote:
>> Error when using media-ctl as below with v2 mt9p031 driver from Javier and latest media-ctl version.
>> Is there a patch I missed to add different formats - or maybe my command is wrong?
> Please, try the following:
>
> ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP
> CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>
> Thanks.

Thanks Javier! That worked.

The command below used to work but no output to stdout any more:
./yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100 -F `./media-ctl -e "OMAP3 ISP CCDC output"` | nc 10.1.1.99 3000

I have played around with this but have been unable to get a result. Something to do with the media-ctl part of the command?

Thanks again!
Chris
