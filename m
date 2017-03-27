Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23615 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751124AbdC0PLi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 11:11:38 -0400
Message-ID: <1490627440.3612.5.camel@linux.intel.com>
Subject: Re: [PATCH] staging: media: atomisp: remove ifdef around HMM_BO_ION
From: Alan Cox <alan@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Date: Mon, 27 Mar 2017 16:10:40 +0100
In-Reply-To: <20170324134658.GA26415@kroah.com>
References: <20170324132127.3199892-1-arnd@arndb.de>
         <20170324134658.GA26415@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > 2 --
> >  1 file changed, 2 deletions(-)
> 
> Ugh, Alan, what's going on here, I thought you fixed this?

I sent you a patch that removed the arrays entirely and turned it into
a single string as well as removing the define. Not quite sure what
happened but I've resynched to -next and I'll send you it with the next
batch of patches.

Alan
