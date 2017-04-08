Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43388 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752577AbdDHPYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 11:24:05 -0400
Date: Sat, 8 Apr 2017 17:23:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gnomes@lxorguk.ukuu.org.uk, linux-security-module@vger.kernel.org,
        keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 28/38] Annotate hardware config module parameters in
 drivers/staging/media/
Message-ID: <20170408152353.GD7879@kroah.com>
References: <149141141298.29162.5612793122429261720.stgit@warthog.procyon.org.uk>
 <149141166119.29162.8331512785853788823.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149141166119.29162.8331512785853788823.stgit@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 05, 2017 at 06:01:01PM +0100, David Howells wrote:
> When the kernel is running in secure boot mode, we lock down the kernel to
> prevent userspace from modifying the running kernel image.  Whilst this
> includes prohibiting access to things like /dev/mem, it must also prevent
> access by means of configuring driver modules in such a way as to cause a
> device to access or modify the kernel image.
> 
> To this end, annotate module_param* statements that refer to hardware
> configuration and indicate for future reference what type of parameter they
> specify.  The parameter parser in the core sees this information and can
> skip such parameters with an error message if the kernel is locked down.
> The module initialisation then runs as normal, but just sees whatever the
> default values for those parameters is.
> 
> Note that we do still need to do the module initialisation because some
> drivers have viable defaults set in case parameters aren't specified and
> some drivers support automatic configuration (e.g. PNP or PCI) in addition
> to manually coded parameters.
> 
> This patch annotates drivers in drivers/staging/media/.
> 
> Suggested-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: linux-media@vger.kernel.org
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
