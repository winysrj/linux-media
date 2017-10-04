Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50949 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751195AbdJDVSR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:18:17 -0400
Date: Wed, 4 Oct 2017 22:18:15 +0100
From: Sean Young <sean@mess.org>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Mans Rullgard <mans@mansr.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v6 2/2] media: rc: Add driver for tango HW IR decoder
Message-ID: <20171004211815.qnu6yy24ow3dmjmz@gofer.mess.org>
References: <308711ef-0ba8-d533-26fd-51e5b8f32cc8@free.fr>
 <e3d91250-e6bd-bb8c-5497-689c351ac55f@free.fr>
 <yw1xzi9ieuqe.fsf@mansr.com>
 <893874ee-a6e0-e4be-5b4f-a49e60197e92@free.fr>
 <yw1xr2uuenhv.fsf@mansr.com>
 <0690fbbb-a13f-63af-bc43-b1f9d4771bc4@free.fr>
 <3dc97914-048f-e932-c05d-211b5111eb84@sigmadesigns.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dc97914-048f-e932-c05d-211b5111eb84@sigmadesigns.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 04, 2017 at 06:00:47PM +0200, Marc Gonzalez wrote:
> On 26/09/2017 10:51, Marc Gonzalez wrote:
> 
> > From: Mans Rullgard <mans@mansr.com>
> > 
> > The tango HW IR decoder supports NEC, RC-5, RC-6 protocols.
> > 
> > Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> > ---
> > Changes between v5 and v6
> > * Move "register fields" macros to top of file
> > * Restore IRQ pending writes
> > ---
> >  drivers/media/rc/Kconfig    |  10 ++
> >  drivers/media/rc/Makefile   |   1 +
> >  drivers/media/rc/tango-ir.c | 279 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 290 insertions(+)
> >  create mode 100644 drivers/media/rc/tango-ir.c
> 
> Hello Sean,
> 
> Are there issues remaining before this series can be accepted upstream?
> 
> Are you waiting for the DT folks to review the DT binding?

I am waiting for that review. 

> Can I submit a keymap patch on top of the series?

Of course. Or you could post v7 with a keymap.

Thanks
Sean
