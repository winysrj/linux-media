Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3AJOF6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 09:05:58 -0500
Date: Thu, 10 Jan 2013 12:05:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Hamad Kadmany" <hkadmany@codeaurora.org>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [dvb] Question on dvb-core re-structure
Message-ID: <20130110120524.49c7e19e@redhat.com>
In-Reply-To: <000801cdef1f$70667580$51336080$@codeaurora.org>
References: <000801cdef1f$70667580$51336080$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Jan 2013 12:44:14 +0200
"Hamad Kadmany" <hkadmany@codeaurora.org> escreveu:

> Hi,
> 
> With the new structure of dvb-core (moved up one directory), previous
> DVB/ATSC adapters were moved to media/usb, media/pci and media/mmc.
> 
> For SoC that supports integrated DVB functionality, where should the
> adapter's code be located in the new structure? I don't see it fit any of
> the above three options.

It should be inside drivers/media/platform.

Regards,
Mauro
