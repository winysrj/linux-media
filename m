Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53360
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751970AbdHZJgu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 05:36:50 -0400
Date: Sat, 26 Aug 2017 06:36:41 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        SeongJae Park <sj38.park@gmail.com>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: [PATCH v2 4/4] docs-rst: Allow Sphinx version 1.6
Message-ID: <20170826063641.6f2467f2@vento.lan>
In-Reply-To: <20170824132914.062d7a4c@lwn.net>
References: <cover.1503477995.git.mchehab@s-opensource.com>
        <0552b7adf6e023f33494987c3e908101d75250d2.1503477995.git.mchehab@s-opensource.com>
        <20170824132628.75cdf353@lwn.net>
        <20170824132914.062d7a4c@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 24 Aug 2017 13:29:14 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 24 Aug 2017 13:26:28 -0600
> Jonathan Corbet <corbet@lwn.net> wrote:
> 
> > > -	% To allow adjusting table sizes
> > > -	\\usepackage{adjustbox}
> > > -
> > >       '''
> > >  }    
> > 
> > So this change doesn't quite match the changelog...what's the story there?  
> 
> Indeed, with that patch applied, I get this:
> 
> ! LaTeX Error: Environment adjustbox undefined.
> 
> See the LaTeX manual or LaTeX Companion for explanation.
> Type  H <return>  for immediate help.
>  ...                                              
>                                                   
> l.4108 \begin{adjustbox}
>                         {width=\columnwidth}
> 
> ...so methinks something isn't quite right...

Sorry, yeah, I messed with this one. Just sent a new series of patches,
splitting it from the documentation changes.

This change (and the equivalent one at sphinx-pre-build script) is
actually a cleanup change. It can *only* be applied after the
patch that goes through the media tree.

What happens is that this patch:
	media: fix pdf build with Spinx 1.6

Stops using adjustbox, with is what causes build problem on Sphinx 1.6.

I suspect that now the PDF build will be a bit more reliable, as the
"..raw: latex" blocs now only adjust font sizes and table spacing,
when needed to output large tables, but Sphinx maintainers have been
creative on finding new ways to break backward compatibility on every
new version ;-) Still, hope is the last thing to die.

Thanks,
Mauro
