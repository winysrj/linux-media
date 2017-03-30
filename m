Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46272
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932541AbdC3LHS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 07:07:18 -0400
Date: Thu, 30 Mar 2017 07:58:32 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 01/22] tmplcvt: make the tool more robust
Message-ID: <20170330075832.671624e0@vento.lan>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 07:45:35 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Currently, the script just assumes to be called at
> Documentation/sphinx/. Change it to work on any directory,
> and make it abort if something gets wrong.
> 
> Also, be sure that both parameters are specified.
> 
> That should avoid troubles like this:
> 
> $ Documentation/sphinx/tmplcvt Documentation/DocBook/writing_usb_driver.tmpl
> sed: couldn't open file convert_template.sed: No such file or directory
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Forgot to mention. The entire USB book, after this patch series,
generated with Sphinx 1.4.9, can be seen, in HTML, at:

	http://www.infradead.org/~mchehab/kernel_docs/driver-api/usb/index.html

Thanks,
Mauro
