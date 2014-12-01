Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46147 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaLACVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Nov 2014 21:21:36 -0500
Date: Sun, 30 Nov 2014 21:21:32 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Firmware Mailing List <linux-firmware@kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rainer Miethling <RMiethling@pctvsystems.com>
Subject: Re: [PATCH] linux-firmware: Add firmware files for Siano DTV devices
Message-ID: <20141201022132.GF2930@merlin.infradead.org>
References: <1415577499-30850-1-git-send-email-mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415577499-30850-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 09, 2014 at 09:58:19PM -0200, Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> Acked-by: Rainer Miethling <RMiethling@pctvsystems.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> ---
>  LICENCE.siano                 |  31 +++++++++++++++++++++++++++++++
>  WHENCE                        |  18 ++++++++++++++++++
>  cmmb_vega_12mhz.inp           | Bin 0 -> 62780 bytes
>  cmmb_venice_12mhz.inp         | Bin 0 -> 97016 bytes
>  dvb_nova_12mhz.inp            | Bin 0 -> 93516 bytes
>  dvb_nova_12mhz_b0.inp         | Bin 0 -> 101888 bytes
>  isdbt_nova_12mhz.inp          | Bin 0 -> 75876 bytes
>  isdbt_nova_12mhz_b0.inp       | Bin 0 -> 98384 bytes
>  isdbt_rio.inp                 | Bin 0 -> 85840 bytes
>  sms1xxx-hcw-55xxx-dvbt-02.fw  | Bin 0 -> 85656 bytes
>  sms1xxx-hcw-55xxx-isdbt-02.fw | Bin 0 -> 70472 bytes
>  sms1xxx-nova-a-dvbt-01.fw     | Bin 0 -> 85656 bytes
>  sms1xxx-nova-b-dvbt-01.fw     | Bin 0 -> 76364 bytes
>  sms1xxx-stellar-dvbt-01.fw    | Bin 0 -> 39900 bytes
>  tdmb_nova_12mhz.inp           | Bin 0 -> 40096 bytes
>  15 files changed, 49 insertions(+)

bleh, it would have been nice to have made a dvb/ namespace for some of
these to group them all...

in any event, i've applied this patch (After a slight fixup to WHENCE.)

regards, Kyle
