Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42265 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751492AbdDNUm6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 16:42:58 -0400
Message-ID: <1492202574.3693.1.camel@linux.intel.com>
Subject: Re: [PATCH] staging/media: make atomisp vlv2_plat_clock explicitly
 non-modular
From: Alan Cox <alan@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Fri, 14 Apr 2017 21:42:54 +0100
In-Reply-To: <20170414081242.GA5096@kroah.com>
References: <20170413015755.4533-1-paul.gortmaker@windriver.com>
         <20170414081242.GA5096@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm pretty sure we want this code to be built as a module, so maybe a
> Kconfig change would resolve the issue instead?
> 
> Alan, any thoughts?

It's a tiny chunk of platform helper code. It probably ultimately
belongs in arch/x86 somewhere or folded into the driver. At the moment
it won't build modular.

I'm fine with the change, it strips out more pointless code so helps
see what tiny bits of code in there are actually used for anything
real.

Alan
