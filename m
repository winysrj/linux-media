Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:42586 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbdK2JHf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 04:07:35 -0500
Received: by mail-wm0-f47.google.com with SMTP id l141so4639611wmg.1
        for <linux-media@vger.kernel.org>; Wed, 29 Nov 2017 01:07:34 -0800 (PST)
Date: Wed, 29 Nov 2017 10:07:27 +0100
From: "Riccardo S." <sirmy15@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2 0/4] fix some checkpatch style issues in atomisp driver
Message-ID: <20171129090727.GA58504@rschirone-mbp.local>
References: <20171127214413.10749-1-sirmy15@gmail.com>
 <20171128204004.9345-1-sirmy15@gmail.com>
 <20171129084024.5jhrj5poxzeq4gyj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129084024.5jhrj5poxzeq4gyj@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29, Sakari Ailus wrote:
> On Tue, Nov 28, 2017 at 09:40:00PM +0100, Riccardo Schirone wrote:
> > This patch series fixes some coding style issues in atomisp driver
> > reported by checkpatch, like: missing blank lines after declarations,
> > comments style, comparisons and indentation.
> > 
> > It is based on next-20171128.
> > 
> > Changes since v1:
> >  - Add commit message to first patch as reported by Jacopo Mondi
> >    <jacopo@jmondi.org>
> > 
> > Riccardo Schirone (4):
> >   staging: add missing blank line after declarations in atomisp-ov5693
> >   staging: improve comments usage in atomisp-ov5693
> >   staging: improves comparisons readability in atomisp-ov5693
> >   staging: fix indentation in atomisp-ov5693
> 
> Applied, thanks!
> 
> Please use staging: atomisp: prefix in the future.
> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

Sure! Thanks for the advice.


Riccardo Schirone
