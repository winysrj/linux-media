Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:44255 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752746AbaGIS03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 14:26:29 -0400
Message-ID: <1404930382.932.143.camel@joe-AO725>
Subject: Re: [PATCH v1 4/5] parisc: use seq_hex_dump() to dump buffers
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 11:26:22 -0700
In-Reply-To: <1404919470-26668-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2014-07-09 at 18:24 +0300, Andy Shevchenko wrote:
> Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Doesn't this also change the output from
   1111111122222222333333334444444455555555666666667777777788888888
to
   11111111 22222222 33333333 44444444 55555555 66666666 77777777 88888888


