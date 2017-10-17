Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34726 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757847AbdJQHbP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 03:31:15 -0400
Date: Tue, 17 Oct 2017 10:31:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: alan@linux.intel.com, linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.15] Atomisp cleanups
Message-ID: <20171017073112.4vq4ar77twt6vu66@valkosipuli.retiisi.org.uk>
References: <20171013223355.pircr25cwyxg6mvl@valkosipuli.retiisi.org.uk>
 <20171016170735.15d8d8f6@vela.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171016170735.15d8d8f6@vela.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 16, 2017 at 05:07:35PM -0700, Mauro Carvalho Chehab wrote:
> Em Sat, 14 Oct 2017 01:33:55 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > Here's the usual set of atomisp cleanups.
> > 
> > Please pull.
> > 
> > 
> > The following changes since commit 8382e556b1a2f30c4bf866f021b33577a64f9ebf:
> > 
> >   Simplify major/minor non-dynamic logic (2017-10-11 15:32:11 -0400)
> > 
> > are available in the git repository at:
> > 
> >   ssh://linuxtv.org/git/sailus/media_tree.git atomisp
> > 
> > for you to fetch changes up to 9c55caa37197e80b14250ff5709ce49737ed812c:
> > 
> >   staging: atomisp: use ARRAY_SIZE (2017-10-14 00:55:45 +0300)
> > 
> > ----------------------------------------------------------------
> > Jérémy Lefaure (1):
> >       staging: atomisp: use ARRAY_SIZE
> > 
> > Muhammad Falak R Wani (1):
> >       staging/atomisp: make six local functions static to appease sparse
> > 
> > Sakari Ailus (3):
> >       staging: media: MAINTAINERS: Add entry for atomisp driver
> 
> I'd like to see Alan's SOB on this patch.

Hi Mauro,

I've checked with Alan and he's fine with the patch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
