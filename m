Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3869 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3KNOSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Nov 2013 09:18:13 -0500
Message-ID: <5284DB54.6080306@xs4all.nl>
Date: Thu, 14 Nov 2013 15:16:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Andy Walls <awalls@md.metrocast.net>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: SDR API libv4lconvert remove packet headers in-Kernel or userspace
References: <5284D863.1080306@iki.fi>
In-Reply-To: <5284D863.1080306@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/13 15:04, Antti Palosaari wrote:
> Hello
> Should I feed whole raw USB packet to libv4lconvert or rip headers
> off inside Kernel and feed only data? It is very trivial to remove
> headers in kernel and in a case of USB it does not even cost about
> nothing as you have to mem copy data out from URB in any case (if you
> do it on that phase).
> 
> Lets take a most complex case I have. There is not only raw data, but
> some meta-data to process samples. In that case those samples are
> bit-shifted according to control bits in order to increase nominal
> sample resolution from 10 to 12 bits (not sure if it is bit shift or
> some other algo, but shifting bits sounds reasonable and testing
> against RF-signal generator results looked correct as it is now
> implemented).
> 
> So do I feed that whole USB packet to userspace or do I have to
> remove headers + do bit bit shifting and forward only raw samples to
> userspace?

I would definitely remove headers and any garbage but pass the rest
to userspace as-is. There is quite a bit of conversion code in the
example you pointed to, more than I feel belongs in the kernel, so
moving that out to userspace makes sense IMHO.

Regards,

	Hans

>
> 
> That example could be found from:
> drivers/staging/media/msi3101/sdr-msi3101.c
> 
> Here is what on USB packet looks like:
> 
> +===============================================================
> |   00-1023 | USB packet type '384'
> +===============================================================
> |   00-  03 | sequence number of first sample in that USB packet
> +---------------------------------------------------------------
> |   04-  15 | garbage
> +---------------------------------------------------------------
> |   16- 175 | samples
> +---------------------------------------------------------------
> |  176- 179 | control bits for previous samples
> +---------------------------------------------------------------
> |  180- 339 | samples
> +---------------------------------------------------------------
> |  340- 343 | control bits for previous samples
> +---------------------------------------------------------------
> |  344- 503 | samples
> +---------------------------------------------------------------
> |  504- 507 | control bits for previous samples
> +---------------------------------------------------------------
> |  508- 667 | samples
> +---------------------------------------------------------------
> |  668- 671 | control bits for previous samples
> +---------------------------------------------------------------
> |  672- 831 | samples
> +---------------------------------------------------------------
> |  832- 835 | control bits for previous samples
> +---------------------------------------------------------------
> |  836- 995 | samples
> +---------------------------------------------------------------
> |  996- 999 | control bits for previous samples
> +---------------------------------------------------------------
> | 1000-1023 | garbage
> +---------------------------------------------------------------
> 
> 
> regards
> Antti
> 

