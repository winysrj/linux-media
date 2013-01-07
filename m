Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm129.target-host.de ([188.72.225.129]:58348 "EHLO
	ffm129.target-host.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3AGMM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 07:12:29 -0500
Date: Mon, 7 Jan 2013 13:04:20 +0100
From: Nikolaus Schulz <schulz@macnetix.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	<linux-media@vger.kernel.org>, <kbuild@01.org>,
	<kernel-janitors@vger.kernel.org>
Subject: Re: [patch] [media] dvb: unlock on error in
 dvb_ca_en50221_io_do_ioctl()
Message-ID: <20130107120420.GA7875@pcewns01.macnetix.de>
References: <50e3bfe0.IJT/Tw4ZVUbERlpE%fengguang.wu@intel.com>
 <20130104185602.GB2038@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130104185602.GB2038@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 04, 2013 at 09:56:02PM +0300, Dan Carpenter wrote:
> We recently pushed the locking down into this function, but there was
> an error path where the unlock was missed.

Ugh, indeed. Thanks for catching this!

Nikolaus.
