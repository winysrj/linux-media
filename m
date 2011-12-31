Return-path: <linux-media-owner@vger.kernel.org>
Received: from deacon.kewl.org ([212.161.35.253]:53703 "EHLO mail.kewl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab1LaSCJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 13:02:09 -0500
Message-ID: <6acb7f159883a6fb7201eee28fe224b4.squirrel@mail.kewl.org>
In-Reply-To: <20111231115416.GC16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
    <20111231115117.GB16802@elie.Belkin>
    <20111231115416.GC16802@elie.Belkin>
Date: Sat, 31 Dec 2011 17:37:42 -0000
Subject: Re: [PATCH 1/9] [media] DVB: dvb_net_init: return -errno on error
From: "Darron Broad" <darron@kewl.org>
To: "Jonathan Nieder" <jrnieder@gmail.com>
Cc: "David Fries" <david@fries.net>,
	"Istvan Varga" <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	"Darron Broad" <darron@kewl.org>,
	"Steven Toth" <stoth@kernellabs.com>,
	"Hans Petter Selasky" <hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Sat, December 31, 2011 11:54, Jonathan Nieder wrote:
> dvb_net_init unconditionally returns 0.  Callers such as
> videobuf_dvb_register_frontend examine dvbnet->dvbdev instead of the
> return value to tell whether the operation succeeded.  If it has been
> set to a valid pointer, success; if it was left equal to NULL,
> failure.

I noticed this when testing the MFE patch set a few years ago
now and as you have seen I tested for NULL elsewhere more as
a reminder than any thing else.

I made no changes either as you can also see since it was beyond
the scope of the MFE patches at the time. I do remember this
and it pops into my mind once in a while and now it can now be
cast aside forever, thanks.

> Alas, there is an edge case where that logic does not work as well:
> when network support has been compiled out (CONFIG_DVB_NET=n), we want
> dvb_net_init and related operations to behave as no-ops and always
> succeed, but there is no appropriate value to which to set dvb->dvbdev
> to indicate this.

I suspect this is the only case where the MFE patches do not
properly check every potential fault with attachment as I cannot
remember any other function being as the NET attachment which
may have actually been a void function when I last visited it
but that's a bit vague and the return 0 suggests not.

> Let dvb_net_init return a meaningful error code, as preparation for
> adapting callers to look at that instead.
>
> The only immediate impact of this patch should be to make the few
> callers that already check for an error code from dvb_net_init behave
> a little more sensibly when it fails.

Cheers, thanks for your efforts.
bye

> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
> ---
>  drivers/media/dvb/dvb-core/dvb_net.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-core/dvb_net.c
> b/drivers/media/dvb/dvb-core/dvb_net.c
> index 93d9869e0f15..8766ce8c354d 100644
> --- a/drivers/media/dvb/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb/dvb-core/dvb_net.c
> @@ -1510,9 +1510,7 @@ int dvb_net_init (struct dvb_adapter *adap, struct
> dvb_net *dvbnet,
>  	for (i=0; i<DVB_NET_DEVICES_MAX; i++)
>  		dvbnet->state[i] = 0;
>
> -	dvb_register_device (adap, &dvbnet->dvbdev, &dvbdev_net,
> +	return dvb_register_device(adap, &dvbnet->dvbdev, &dvbdev_net,
>  			     dvbnet, DVB_DEVICE_NET);
> -
> -	return 0;
>  }
>  EXPORT_SYMBOL(dvb_net_init);


-- 

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \

