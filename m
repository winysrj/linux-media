Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:38078 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbeEKPbQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 11:31:16 -0400
Message-ID: <1526052671.26291.58.camel@linux.intel.com>
Subject: Re: [PATCH 2/3] media: staging: atomisp: Fix an error handling path
 in 'lm3554_probe()'
From: Alan Cox <alan@linux.intel.com>
To: Julia Lawall <julia.lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        chen.chenchacha@foxmail.com, keescook@chromium.org,
        arvind.yadav.cs@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Fri, 11 May 2018 16:31:11 +0100
In-Reply-To: <alpine.DEB.2.20.1805111709390.20118@hadrien>
References: <cover.1526048313.git.christophe.jaillet@wanadoo.fr>
         <f762630a681c08d9903cf73243dd98416ae96a7c.1526048313.git.christophe.jaillet@wanadoo.fr>
         <alpine.DEB.2.20.1805111709390.20118@hadrien>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-11 at 17:09 +0200, Julia Lawall wrote:
> 
> On Fri, 11 May 2018, Christophe JAILLET wrote:
> 
> > The use of 'fail1' and 'fail2' is not correct. Reorder these calls
> > to
> > branch at the right place of the error handling path.
> 
> Maybe it would be good to improve the names at the same time?

Its scheduled for deletion - please don't bother.

Alan
