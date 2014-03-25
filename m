Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37274 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaCYXxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 19:53:18 -0400
Date: Wed, 26 Mar 2014 00:53:14 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 00/10] media: rc: ImgTec IR decoder driver
Message-ID: <20140325235314.GB2515@hardeman.nu>
References: <1393630140-31765-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393630140-31765-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 28, 2014 at 11:28:50PM +0000, James Hogan wrote:
>Add a driver for the ImgTec Infrared decoder block. Two separate rc
>input devices are exposed depending on kernel configuration. One uses
>the hardware decoder which is set up with timings for a specific
>protocol and supports mask/value filtering and wake events. The other
>uses raw edge interrupts and the generic software protocol decoders to
>allow multiple protocols to be supported, including those not supported
>by the hardware decoder.

One thing I just noticed...your copyright headers throughout the driver
seems a bit...sparse? :)

