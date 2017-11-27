Return-path: <linux-media-owner@vger.kernel.org>
Received: from kadath.azazel.net ([81.187.231.250]:53136 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752142AbdK0WCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 17:02:37 -0500
Date: Mon, 27 Nov 2017 22:02:31 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 3/3] media: staging: atomisp: fixed some checkpatch
 integer type warnings.
Message-ID: <20171127220231.3f3lopmqv34zlqzn@azazel.net>
References: <20171127122125.GB8561@kroah.com>
 <20171127124450.28799-1-jeremy@azazel.net>
 <20171127124450.28799-4-jeremy@azazel.net>
 <20171127190938.73c6b15a@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127190938.73c6b15a@alans-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-11-27, at 19:09:38 +0000, Alan Cox wrote:
> On Mon, 27 Nov 2017 12:44:50 +0000 Jeremy Sowden wrote:
> > Changed the types of some arrays from int16_t to s16
>
> Which are the same type, except int16_t is the standard form.
>
> No point.

Righto, so this would be one of those cases in which I should have
exercised judgment: checkpatch suggested preferring the kernel's own
types, but it wasn't a reason to change existing code.

Thanks for the feedback.

J.
