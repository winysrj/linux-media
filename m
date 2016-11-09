Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40542
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753847AbcKIL1P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 06:27:15 -0500
Date: Wed, 9 Nov 2016 09:27:08 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
Message-ID: <20161109092708.786f55da@vento.lan>
In-Reply-To: <8737j0hpi0.fsf@intel.com>
References: <20161107075524.49d83697@vento.lan>
        <20161107170133.4jdeuqydthbbchaq@x>
        <A4091944-D727-45B5-AC24-FE3B2700298E@darmarit.de>
        <8737j0hpi0.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 09 Nov 2016 13:16:55 +0200
Jani Nikula <jani.nikula@linux.intel.com> escreveu:

> >> 1) copy (or symlink) all rst files to Documentation/output (or to the
> >>  build dir specified via O= directive) and generate the *.pdf there,
> >>  and produce those converted images via Makefile.;  
> 
> We're supposed to solve problems, not create new ones.

So, what's your proposal?

Thanks,
Mauro
