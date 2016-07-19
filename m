Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41525 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbcGSXBg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 19:01:36 -0400
Date: Tue, 19 Jul 2016 17:01:33 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160719170133.416c94d8@lwn.net>
In-Reply-To: <20160717100154.64823d99@recife.lan>
References: <20160717100154.64823d99@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 17 Jul 2016 10:01:54 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> 2) For functions, kernel-doc is now an all or nothing. If not all
> functions are declared, it outputs this warning:
> 
> 	./include/media/media-devnode.h:1: warning: no structured comments
> 
> And give up. No functions are exported, nor it points where it bailed.
> So, we need to manually look into all exported symbols to identify
> what's missing

So could you describe this one in a bit more detail?  An example of a
file with the problem and associated kernel-doc directive would be most
helpful here.  This sounds like something we definitely want to fix.

Thanks,

jon
