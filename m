Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42054
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbcHSNm2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:42:28 -0400
Date: Fri, 19 Aug 2016 10:41:44 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kamil Debski <kamil@wypas.org>
Subject: Re: [PATCH 13/15] [media] cec-core: Convert it to ReST format
Message-ID: <20160819104144.4ae6c4df@vento.lan>
In-Reply-To: <20160819103750.300b4afe@vento.lan>
References: <cover.1471611003.git.mchehab@s-opensource.com>
        <b85163fc1723bdb240ce3136552ac1683999051c.1471611003.git.mchehab@s-opensource.com>
        <26805b9a-8e8d-2b22-0777-af2311fbfb9e@cisco.com>
        <20160819103750.300b4afe@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 19 Aug 2016 10:37:50 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Fri, 19 Aug 2016 15:24:16 +0200
> Hans Verkuil <hansverk@cisco.com> escreveu:
> 
> > On 08/19/2016 03:05 PM, Mauro Carvalho Chehab wrote:  
> > > There are some things there that aren't ok for ReST format.
> > >
> > > Fix them.
> > >
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>    
> > 
> > OK, so I posted a similar patch for this:
> > 
> > https://patchwork.linuxtv.org/patch/36376/
> > 
> > It's part of one of my pull requests, but I guess you can skip that patch.  
> 
> Sorry, I didn't notice. I'm actually waiting for Jon to merge the
> remaining patches for the Sphinx rst core before starting handling
> and merging our patches. I want to avoid having a separate branch for
> documentation this time.
> 
> IMHO, my approach is better than you for functions, as it declares
> functions and struct using the proper macros that are also used
> by kernel-doc script.
> 
> Yet, I didn't touch at MAINTAINERS nor I used ``constant`` or
> :c:type:/:c:func: for references of the functions/struct. 
> Would you care to rebase your patch on the top of mine doing such
> changes?

Hmm... actually we should do something else...

As those functions are declared (or should be declared) using the
kernel documentation macros, we should have references for them
already. So, we need to actually change the text there to point
to the references created by kernel-doc script.

like:

	https://linuxtv.org/downloads/v4l-dvb-apis-new/_sources/media/kapi/v4l2-dev.txt

Thanks,
Mauro
