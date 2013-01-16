Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36376 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3APOdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 09:33:17 -0500
Date: Wed, 16 Jan 2013 17:33:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: devel@driverdev.osuosl.org, mchehab@redhat.com,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, rdunlap@xenotime.net, hans.verkuil@cisco.com,
	justinmattock@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: media: go7007: i2c GPIO initialization
 Reset i2c stuff for GO7007_BOARDID_ADLINK_MPG24 need reset GPIO always when
 encoder initialize
Message-ID: <20130116143321.GI4584@mwanda>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
 <1358341251-10087-3-git-send-email-volokh84@gmail.com>
 <20130116133608.GH4584@mwanda>
 <20130116140013.GB20944@VPir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116140013.GB20944@VPir>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 16, 2013 at 06:00:13PM +0400, Volokh Konstantin wrote:
> On Wed, Jan 16, 2013 at 04:36:08PM +0300, Dan Carpenter wrote:
> > You've added the writes for GO7007_BOARDID_ADLINK_MPG24 but removed
> > them for GO7007_BOARDID_XMEN and GO7007_BOARDID_XMEN_III.  Won't
> > that break those boards?
> >
> I don`t remove code for GO7007_BOARDID_XMEN and GO7007_BOARDID_XMEN_III.
> case there are auto reusing for XMen and XMen-III:

Ah.  Grand.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

