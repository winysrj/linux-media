Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56373 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752107AbdCCOLw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 09:11:52 -0500
Message-ID: <1488541813.2196.52.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: implement encoder stop command
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Date: Fri, 03 Mar 2017 12:50:13 +0100
In-Reply-To: <CAH-u=83Jib=vFPXQTsfojssrR3h8eXzm_1imufZ9NKJ=0DPdgw@mail.gmail.com>
References: <20170302095144.32090-1-p.zabel@pengutronix.de>
         <CAH-u=83Jib=vFPXQTsfojssrR3h8eXzm_1imufZ9NKJ=0DPdgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-03-02 at 17:30 +0100, Jean-Michel Hautbois wrote:
> <snip>
> 
> > +       /* If there is no buffer in flight, wake up */
> > +       if (ctx->qsequence == ctx->osequence) {
> 
> Not sure about this one, I would have done something like :
> if (!(ctx->fh.m2m_ctx->job_flags)) {

This field is documented as "used internally", though.

regards
Philipp
