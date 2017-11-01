Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42727 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdKANZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 09:25:46 -0400
Date: Wed, 1 Nov 2017 11:25:41 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [RFC] media: camss-vfe: always initialize reg at
 vfe_set_xbar_cfg()
Message-ID: <20171101112541.2069bbbc@vento.lan>
In-Reply-To: <baa710bc-375b-e306-674c-e6ecc6b1d0f5@linaro.org>
References: <20e982c47af6eafe58274fa299ec587b2fb91d32.1509538566.git.mchehab@s-opensource.com>
        <a3b51962-1316-c7cf-1182-5a5d7f0ed719@linaro.org>
        <20171101110314.482206b6@vento.lan>
        <baa710bc-375b-e306-674c-e6ecc6b1d0f5@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 1 Nov 2017 15:09:36 +0200
Todor Tomov <todor.tomov@linaro.org> escreveu:

> On  1.11.2017 15:03, Mauro Carvalho Chehab wrote:
> > Hi Todor,
> > 
> > Em Wed, 1 Nov 2017 14:38:02 +0200
> > Todor Tomov <todor.tomov@linaro.org> escreveu:
> >   
> >> Hi Mauro,
> >>
> >> Thank you for pointing to this.
> >>
> >> On  1.11.2017 14:16, Mauro Carvalho Chehab wrote:  
> >>> if output->wm_num is bigger than 1, the value for reg is    
> >> If output->wn_num equals 2, we handle all cases (i == 0, i == 1) and set reg properly.
> >> If output->wn_num is bigger than 2, then reg will not be initialized. However this is something that "cannot happen" and because of this the case is not handled.
> >>
> >> So I think that there is nothing wrong really but we have to do something to remove the warning. I agree with your patch, it is technically not a right value for reg but any cases in which wm_num is bigger than 2 are not supported anyway and should not happen.  
> > 
> > Thanks for your promptly answer. Well, if i is always at the [0..1] range,
> > then I guess the enclosed patch is actually better.  
> 
> I don't think that there is a lot of difference practically. If this one fixes the warning too, then it is fine for me. Thank you for working on this.

Yes, it fixes the warning. I guess the main advantage of version 2 is
that, if it would ever be possible to have more than 2 outputs, it
should be clearer that the logic at break need changes.

So, if ok for you, I'll stick with version 2. It would be great if
you could give your ack on that.

Regards,
Mauro
