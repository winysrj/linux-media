Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:55206 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756559AbcHaJLv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 05:11:51 -0400
Message-ID: <1472634705.3085.6.camel@pengutronix.de>
Subject: Re: [PATCH] [media] dw2102: Add support for Terratec Cinergy S2 USB
 BOX
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Benjamin Larsson <benjamin@southpole.se>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        linux-media <linux-media@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Christian Zippel <namerp@gmail.com>
Date: Wed, 31 Aug 2016 11:11:45 +0200
In-Reply-To: <5798D479.9080603@southpole.se>
References: <1451935971-31402-1-git-send-email-p.zabel@pengutronix.de>
         <CAAZRmGz5vS8vMBEQeMo6BS0XijoCj655jha5vCsiy2P8TcgSoQ@mail.gmail.com>
         <20160716134707.6cf426ea@recife.lan>
         <CAAZRmGyo7wRjENT_o8ezdjrBb2xU-zxmRKWakC6H4zVNm+YDeA@mail.gmail.com>
         <20160718085911.7bbbd38c@recife.lan> <5798D479.9080603@southpole.se>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 27.07.2016, 17:34 +0200 schrieb Benjamin Larsson:
> On 07/18/2016 01:59 PM, Mauro Carvalho Chehab wrote:
> >It would be
> > nice if both Philipp and Benjamin test such patch, for us to be sure
> > that it would work for both.
> >
> > Regards,
> > Mauro
> 
> I added it to the dvbsky driver so I guess that Philipp has to do the 
> testing.

I have tested the dvbsky driver on v4.8-rc3 last weekend, and can
confirm that it works with the hardware in question.

regards
Philipp

