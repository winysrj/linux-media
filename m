Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:38043 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751982AbbHHRGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Aug 2015 13:06:41 -0400
Message-ID: <1439053595.2322.60.camel@perches.com>
Subject: Re: [PATCH 1/1] Staging: media: davinci_vpfe: fix over 80
 characters coding style issue.
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Junsu Shin <jjunes0@gmail.com>, devel@driverdev.osuosl.org,
	boris.brezillon@free-electrons.com, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org, prabhakar.csengg@gmail.com,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, linux-media@vger.kernel.org
Date: Sat, 08 Aug 2015 10:06:35 -0700
In-Reply-To: <20150808154259.GD11851@kroah.com>
References: <1438916154-5840-1-git-send-email-jjunes0@gmail.com>
	 <20150807044505.GB3537@sudip-pc> <55C5A7C6.9080006@gmail.com>
	 <20150808101218.GA1301@sudip-pc> <20150808154259.GD11851@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2015-08-08 at 08:42 -0700, Greg KH wrote:
> Greg does not accept drivers/staging/media/* patches,

You could change
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 111a6b2..089c458 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9742,6 +9742,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
 L:	devel@driverdev.osuosl.org
 S:	Supported
 F:	drivers/staging/
+X:	drivers/staging/media/
 
 STAGING - COMEDI
 M:	Ian Abbott <abbotti@mev.co.uk>


