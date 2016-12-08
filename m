Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60458 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932090AbcLHOsF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 09:48:05 -0500
Date: Thu, 8 Dec 2016 16:47:28 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Felipe Sanches <juca@members.fsf.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.11] Remove FSF postal address
Message-ID: <20161208144728.GH16630@valkosipuli.retiisi.org.uk>
References: <20161208080825.GB16630@valkosipuli.retiisi.org.uk>
 <CAK6XL6DaXaf=dxU20BpyVqW_UxaFOfTGtVO6MppvPuZxa9puMA@mail.gmail.com>
 <20161208110920.GG16630@valkosipuli.retiisi.org.uk>
 <20161208105947.3f4fa3aa@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161208105947.3f4fa3aa@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Dec 08, 2016 at 10:59:47AM -0200, Mauro Carvalho Chehab wrote:
> Hi Sakari,
> 
> Em Thu, 8 Dec 2016 13:09:20 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Felipe,
> > 
> > On Thu, Dec 08, 2016 at 08:51:20AM -0200, Felipe Sanches wrote:
> > > but why?  
> > 
> > Please see my reply here:
> > 
> > <URL:http://www.spinics.net/lists/linux-media/msg107204.html>
> 
> Please don't. If people wanted that, they would be sending a big
> massive change by the time FSF check was added to checkpatch.

Typically it's best to do such changes per-subsystem if there's an intent to
change more than a single driver at a time. Seldom others than those
working on a subsystem would do that.

> 
> This is the kind of patch that can rise conflicts with other
> patches, and don't really benefit the code.

Patches to the media tree are submitted against the media tree master
branch. There are few changes to the media tree that come outside of it,
especially comment sections in files, suggesting a conflict might not be
very likely.

For the record, I rebased this patch from two weeks ago without conflicts.
The patch also cleanly applies to linux-next.

> 
> Ok, if you're doing massive changes on some driver, be my
> guest and remove the FSF address from it. Otherwise, just live
> it as-is.

This is a cleanup. The patch removes 628 instances of the postal address of
which 578 are outdated: that's hardly useful information to keep in the
codebase. Cleaning up useless and outdated code does improve long-term
maintainability of the code, and, as in this case, is additionally supported
by the coding style practices.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
