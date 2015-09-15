Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4-c.eqx.gridhost.co.uk ([95.142.156.20]:36146 "EHLO
	mail4-b.eqx.gridhost.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754848AbbIOOvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 10:51:25 -0400
Received: from [209.85.212.169] (helo=mail-wi0-f169.google.com)
	by mail4.eqx.gridhost.co.uk with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <olli.salonen@iki.fi>)
	id 1ZbrS8-00069r-Fi
	for linux-media@vger.kernel.org; Tue, 15 Sep 2015 15:43:24 +0100
Received: by wiclk2 with SMTP id lk2so32249686wic.0
        for <linux-media@vger.kernel.org>; Tue, 15 Sep 2015 07:43:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F2ED67.3030306@vontaene.de>
References: <55F2ED67.3030306@vontaene.de>
Date: Tue, 15 Sep 2015 16:43:24 +0200
Message-ID: <CAAZRmGwuCawvR0sMhdHkMXdL1bNPCvL9T9Oe_vuKYQ2+SgT8+w@mail.gmail.com>
Subject: Re: Terratec H7 Rev. 4 is DVBSky
From: Olli Salonen <olli.salonen@iki.fi>
To: Erik Andresen <erik@vontaene.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Erik,

Your patch looks good to my eyes. I heard already earlier that the new
H7 is the same as the DVBSky receiver and your experience seems to
confirm that. Could you resend the patch again with a proper title and
a signed-off line to the mailing list?
https://www.kernel.org/doc/Documentation/SubmittingPatches is good
reading as well.

Cheers,
-olli


On 11 September 2015 at 17:04, Erik Andresen <erik@vontaene.de> wrote:
> Hi,
>
> I recently got a Terratec H7 in Revision 4 and turned out that it is not
> just a new revision, but a new product with USB ProductID 0x10a5.
> Previous revisions have been AZ6007, but this revision does not work
> with this driver [1].
>
> Output of lsusb (extended output attached):
> Bus 001 Device 011: ID 0ccd:10a5 TerraTec Electronic GmbH
>
> The revision 4 seems to a DVBSky variant, adding its Product ID to
> dvbsky.c with the attached patch enabled me to scan for channels and
> watch DVB-C and DVB-T.
>
> greetings,
> Erik
>
> [1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg70934.html
