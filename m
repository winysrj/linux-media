Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:32880
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751697AbdI0UlP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 16:41:15 -0400
Date: Wed, 27 Sep 2017 17:41:05 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] scripts: kernel-doc: get rid of unused output
 formats
Message-ID: <20170927174105.42d2e0ff@recife.lan>
In-Reply-To: <87vak46wdw.fsf@intel.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
        <de8b9f4b394ca349889bfdc467ae33e0ce7939b1.1506448061.git.mchehab@s-opensource.com>
        <87vak46wdw.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Sep 2017 17:36:59 +0300
Jani Nikula <jani.nikula@linux.intel.com> escreveu:

> On Tue, 26 Sep 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > Since there isn't any docbook code anymore upstream,
> > we can get rid of several output formats:
> >
> > - docbook/xml, html, html5 and list formats were used by
> >   the old build system;
> > - As ReST is text, there's not much sense on outputting
> >   on a different text format.
> >
> > After this patch, only man and rst output formats are
> > supported.  
> 
> FWIW,
> 
> Acked-by: Jani Nikula <jani.nikula@intel.com>

Thanks!

> Please do keep at least two output formats going forward. Otherwise the
> mechanisms of having more than one output format will bitrot and get
> conflated into the one output format.

Yeah, if we leave just one output format, some extra cleanup would be
needed.

Anyway, as we currently doesn't have other ways to generate manpages,
we should be keeping both ReST and man for now.

Thanks,
Mauro
