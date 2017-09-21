Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53739 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdIUQ7E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 12:59:04 -0400
Date: Thu, 21 Sep 2017 17:59:02 +0100
From: Sean Young <sean@mess.org>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Mans Rullgard <mans@mansr.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v3 2/2] media: rc: Add driver for tango HW IR decoder
Message-ID: <20170921165901.tq4cy375bthxyin5@gofer.mess.org>
References: <0e433f1b-ec16-5fce-ab21-085f69e266ce@free.fr>
 <4fe2e398-ba7d-3670-f29b-fe3c5e079b39@free.fr>
 <20170921155712.bqxipuxdaf6feeg5@gofer.mess.org>
 <75a3ee58-f515-925f-0f13-ea96ddcbe4e2@sigmadesigns.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75a3ee58-f515-925f-0f13-ea96ddcbe4e2@sigmadesigns.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 21, 2017 at 06:20:28PM +0200, Marc Gonzalez wrote:
> On 21/09/2017 17:57, Sean Young wrote:
> 
> > On Thu, Sep 21, 2017 at 04:49:53PM +0200, Marc Gonzalez wrote:
> > 
> >> The tango HW IR decoder supports NEC, RC-5, RC-6 protocols.
> >>
> >> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> > 
> > Missing signed-off-by.
> 
> I am aware of that. Hopefully, at some point, Mans will add his.
> I have no control over this, unless I rewrite the driver from
> scratch.
> 
> > Your patch still gives numerous checkpatch warnings, please run it
> > preferaby with --strict.
> 
> Some checkpatch warnings are silly, such as unconditionally mandating
> 4 lines for a Kconfig help message. Do you consider it mandatory to
> address all warnings, whatever they are?

Yes, they're mandatory.

The Kconfig could state what the module name is, which is helpful.

See:

https://www.kernel.org/doc/html/v4.12/process/submitting-patches.html

https://www.kernel.org/doc/html/v4.12/process/coding-style.html


Sean
