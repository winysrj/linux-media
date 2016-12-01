Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57744
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751148AbcLAPSF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 10:18:05 -0500
Date: Thu, 1 Dec 2016 13:17:58 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gnomes@lxorguk.ukuu.org.uk, minyard@acm.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 29/39] Annotate hardware config module parameters in
 drivers/staging/media/
Message-ID: <20161201131758.348be20a@vento.lan>
In-Reply-To: <18435.1480604396@warthog.procyon.org.uk>
References: <20161201125420.5b397933@vento.lan>
        <148059537897.31612.9461043954611464597.stgit@warthog.procyon.org.uk>
        <148059561006.31612.6396069416948435055.stgit@warthog.procyon.org.uk>
        <18435.1480604396@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 01 Dec 2016 14:59:56 +0000
David Howells <dhowells@redhat.com> escreveu:

> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > drivers/staging/media/lirc/lirc_parallel.c:728:19: error: Expected ) in function declarator  
> 
> Did you apply patch 1 first?  That defines module_param_hw*.

No. Applying it at the media upstream tree can be risky if it ends
by being merged with some changes.

On what tree do you intend patch 1 to be merged?

> 
> David



Thanks,
Mauro
