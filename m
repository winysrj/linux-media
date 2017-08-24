Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:47048 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752855AbdHXT3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 15:29:16 -0400
Date: Thu, 24 Aug 2017 13:29:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        SeongJae Park <sj38.park@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: [PATCH v2 4/4] docs-rst: Allow Sphinx version 1.6
Message-ID: <20170824132914.062d7a4c@lwn.net>
In-Reply-To: <20170824132628.75cdf353@lwn.net>
References: <cover.1503477995.git.mchehab@s-opensource.com>
        <0552b7adf6e023f33494987c3e908101d75250d2.1503477995.git.mchehab@s-opensource.com>
        <20170824132628.75cdf353@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 24 Aug 2017 13:26:28 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> > -	% To allow adjusting table sizes
> > -	\\usepackage{adjustbox}
> > -
> >       '''
> >  }  
> 
> So this change doesn't quite match the changelog...what's the story there?

Indeed, with that patch applied, I get this:

! LaTeX Error: Environment adjustbox undefined.

See the LaTeX manual or LaTeX Companion for explanation.
Type  H <return>  for immediate help.
 ...                                              
                                                  
l.4108 \begin{adjustbox}
                        {width=\columnwidth}

...so methinks something isn't quite right...

jon
