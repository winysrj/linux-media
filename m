Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZBQNaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 08:30:22 -0500
Date: Tue, 17 Feb 2009 10:29:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	Christian Dolzer <c.dolzer@digital-everywhere.com>,
	Andreas Monitzer <andy@monitzer.com>,
	Manu Abraham <manu@linuxtv.org>,
	Fabio De Lorenzo <delorenzo.fabio@gmail.com>,
	Robert Berger <robert.berger@reliableembeddedsystems.com>,
	Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>,
	Rambaldi <Rambaldi@xs4all.nl>
Subject: Re: [review patch 0/1] add firedtv driver for FireWire-attached DVB
 receivers
Message-ID: <20090217102951.21dab08c@pedra.chehab.org>
In-Reply-To: <tkrat.63c8bdca2465364b@s5r6.in-berlin.de>
References: <tkrat.265ed076d414bd49@s5r6.in-berlin.de>
	<tkrat.63c8bdca2465364b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009 20:33:17 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> firedtv is a driver for FireWire-attached DVB receivers from Digital
> Everywhere GmbH.  The devices are known as FireDTV (external boxes) and
> FloppyDTV (internal cards, also connected through FireWire).  The driver
> supports
>   - the DVB-C, DVB-S/S2, and DVB-T range of FireDTV and FloppyDTV
>     models,
>   - control and reception through Linux' common DVB userspace ABI,
>   - standard definition video reception (MPEG2-TS, to be decoded
>     by userspace client software),
>   - Common Interface for Conditional Access Modules,
>   - input from infrared remote control.
> 
> High definition support has yet to be added.  Also, firedtv still
> requires the ieee1394 kernel API but alternative support of the new
> firewire kernel API is in progress.
> 
> The driver, formerly known as firesat, was originally written by Andreas
> Monitzer.  Manu Abraham, Ben Backx, and Henrik Kurelid updated and
> extended the driver; I did trivial cleanups, refactoring and small
> fixes.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

The driver looks sane to my eyes. I found just one minor issue (see bellow).
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> +
> +		/*
> +		 * AV/C specs say that answers should be sent within 150 ms.
> +		 * Time out after 200 ms.
> +		 */
> +		if (wait_event_timeout(fdtv->avc_wait,
> +				       fdtv->avc_reply_received,
> +				       HZ / 5) != 0) {

Instead of using HZ, it would be better to use:
	msecs_to_jiffies(200)


Cheers,
Mauro
