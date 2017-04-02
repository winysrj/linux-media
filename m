Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:50242 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdDBVcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Apr 2017 17:32:33 -0400
Date: Sun, 2 Apr 2017 15:32:31 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 01/22] tmplcvt: make the tool more robust
Message-ID: <20170402153231.4eccfedf@lwn.net>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Mar 2017 07:45:35 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

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

What's the status of this patch set?  I saw that Jani had one comment
that, I think, hasn't been addressed?

Thanks,

jon
