Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:53588 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422821AbcFMNK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 09:10:59 -0400
From: Arnd Bergmann <arnd@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Henrik Austad <henrik@austad.us>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@vger.kernel.org,
	netdev@vger.kernel.org, henrk@austad.us
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
Date: Mon, 13 Jun 2016 15:12:24 +0200
Message-ID: <3650675.mUADb08Tiz@wuerfel>
In-Reply-To: <20160613114713.GA9544@localhost.localdomain>
References: <1465686096-22156-1-git-send-email-henrik@austad.us> <20160613114713.GA9544@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, June 13, 2016 1:47:13 PM CEST Richard Cochran wrote:
> * Kernel Space
> 
> 1. Providing frames with a future transmit time.  For normal sockets,
>    this can be in the CMESG data.  For mmap'ed buffers, we will need a
>    new format.  (I think Arnd is working on a new layout.)
> 

After some back and forth, I think the conclusion for now was that
the timestamps in the current v3 format are sufficient until 2106
as long as we treat them as 'unsigned', so we don't need the new
format for y2038, but if we get a new format, that should definitely
use 64-bit timestamps because that is the right thing to do.

	Arnd
