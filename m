Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6450 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932254AbdERQkk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 12:40:40 -0400
Message-ID: <1495125627.7848.69.camel@linux.intel.com>
Subject: Re: [PATCH 00/13] staging: media: atomisp queued up patches
From: Alan Cox <alan@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 18 May 2017 17:40:27 +0100
In-Reply-To: <20170518111010.756a13c2@vento.lan>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
         <20170518111010.756a13c2@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-05-18 at 11:10 -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 18 May 2017 15:50:09 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
> 
> > 
> > Hi Mauro,
> > 
> > Here's the set of accumulated atomisp staging patches that I had in
> > my
> > to-review mailbox.  After this, my queue is empty, the driver is
> > all
> > yours!
> 
> Thanks!
> 
> Alan, please let me know if you prefer if I don't apply any of
> such patches, otherwise I should be merging them tomorrow ;)

I will assume you've merged them and resync the internal patch queue I
have here to that. At the moment I'm still slowly trying to unthread
some of the fascinating layers of indirection without actually breaking
anything.

Alan
