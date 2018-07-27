Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36986 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730613AbeG0McF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 08:32:05 -0400
Date: Fri, 27 Jul 2018 14:10:34 +0300
From: Ivan Bornyakov <brnkv.i1@gmail.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: stv090x: fix if-else order
Message-ID: <20180727111034.f42dhlwijthxfp3n@localhost.localdomain>
References: <20180601161221.24807-1-brnkv.i1@gmail.com>
 <20180726162607.2de43b84@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180726162607.2de43b84@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 26, 2018 at 04:26:07PM -0300, Mauro Carvalho Chehab wrote:
> Em Fri,  1 Jun 2018 19:12:21 +0300
> Ivan Bornyakov <brnkv.i1@gmail.com> escreveu:
> 
> > There is this code:
> > 
> > 	if (v >= 0x20) {
> > 		...
> > 	} else if (v < 0x20) {
> > 		...
> > 	} else if (v > 0x30) {
> > 		/* this branch is impossible */
> > 	}
> > 
> > It would be sensibly for last branch to be on the top.
> 
> Have you tested it and check at the datasheets if dev_ver > 0x30 makes
> sense?
> 
> If not, I would prefer, instead, to remove the dead code, as this
> patch may cause regressions (adding a FIXME comment about this
> special case).
> 

Hi, Mauro!

Actually, I did not test it, because I did not have the hardware.
But, in the other places of the code, the same if cases are used.

Here are a couple examples:

  static int stv090x_dvbs_track_crl(struct stv090x_state *state)
  {
          if (state->internal->dev_ver >= 0x30) {
                  ...
	  } else {
	          ...
	  }

	  ...
  }

  static u32 stv090x_srate_srch_coarse(struct stv090x_state *state)
  {
	...

	if (state->internal->dev_ver >= 0x30) {
                ...
	} else if (state->internal->dev_ver >= 0x20) {
	        ...
	}

	...
  }
