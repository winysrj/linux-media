Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562Ab2ENS5u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 14:57:50 -0400
Message-ID: <4FB1559E.4050502@redhat.com>
Date: Mon, 14 May 2012 15:57:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH 02/10] DocBook: document new DTV Properties for ATSC-MH
 delivery system
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org> <1335845545-20879-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-2-git-send-email-mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-05-2012 01:12, Michael Krufky escreveu:
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

Where's the patch description? For sure a patch like that deserves to be
well described.

> ---
>  Documentation/DocBook/media/dvb/dvbproperty.xml |  178 +++++++++++++++++++++++
>  1 files changed, 178 insertions(+), 0 deletions(-)
> 


> +		</section>
> +		<section id="DTV-ATSCMH-FIC-ERR">
> +			<title><constant>DTV_ATSCMH_FIC_ERR</constant></title>
> +			<para>FIC error count.</para>
> +			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
> +		</section>
> +		<section id="DTV-ATSCMH-CRC-ERR">
> +			<title><constant>DTV_ATSCMH_CRC_ERR</constant></title>
> +			<para>CRC error count.</para>
> +			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
> +		</section>
> +		<section id="DTV-ATSCMH-RS-ERR">
> +			<title><constant>DTV_ATSCMH_RS_ERR</constant></title>
> +			<para>RS error count.</para>
> +			<para>Possible values: 0, 1, 2, 3, ..., 0xffff</para>
> +		</section>

The above for sure belongs to statistics API. It should be addressed together
with the other statistics API bits.

We shouldn't mix statistics with DVB frontent properties.

Btw, this is basically the same case as on ISDB-T: the layer that handles the channel
data (TPC, on ATSC M/H; TPS on DVB; TMCC on ISDB) provides statistics about
the frontend. However, the DVBv3 quality ioctl's are prepared to handle only
DVB parameters, and fails with more modern delivery systems.

We should apply a patch that will fix this one for all, like the one proposed by:
	http://patchwork.linuxtv.org/patch/9578/

Regards,
Mauro
