Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55808 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750909AbdHJItA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 04:49:00 -0400
Date: Thu, 10 Aug 2017 11:48:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Harold Gomez <haroldgmz11@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subject: drivers:staging:media:atomisp:12c:ab1302.c fix
 CHECK
Message-ID: <20170810084857.ymxuyijhych6lcxa@valkosipuli.retiisi.org.uk>
References: <20170810082824.GA2289@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810082824.GA2289@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Harold,

On Thu, Aug 10, 2017 at 01:58:24PM +0530, Harold Gomez wrote:
> CHECK: Do not include the paragraph about writing to the Free Software
> Foundation's mailing address from the sample GPL notice.
> The FSF has changed addresses in the past, and may do so again.
> Linux already includes a copy of the GPL.

Applied, with the subject line changed to "staging: media: atomisp: ap1302:
Remove FSF postal address" and "CHECK: " removed. Please look e.g. git log
on the atomisp driver for subject examples in the future.

Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
