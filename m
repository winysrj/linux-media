Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48124 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbbHCI0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2015 04:26:09 -0400
Date: Mon, 3 Aug 2015 11:25:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pradheep Shrinivasan <pradheep.sh@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 1/2] staging:media:lirc Remove the extra braces in if
 statement of lirc_imon
Message-ID: <20150803082552.GT5180@mwanda>
References: <1438588592-3289-1-git-send-email-pradheep.sh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438588592-3289-1-git-send-email-pradheep.sh@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Normally, I wait overnight between writing a patch and sending it.
There is no rush and the delay helps me to be more careful.

The subject is still not perfect.  Do:

	git log --oneline drivers/staging/media/lirc/lirc_imon.c

On Mon, Aug 03, 2015 at 02:56:31AM -0500, Pradheep Shrinivasan wrote:
> From: pradheep <pradheep.sh@gmail.com>

This is still wrong.

regards,
dan carpenter

