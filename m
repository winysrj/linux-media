Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51759 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbeBWR7a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 12:59:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] media: ttpci/ttusb: add extra parameter to filter callbacks
Date: Fri, 23 Feb 2018 19:52:48 +0200
Message-ID: <2237441.eTbS4787IK@avalon>
In-Reply-To: <06bf50688ac75f5ee7af2cd2a9ae0d292f3002b9.1519404222.git.mchehab@s-opensource.com>
References: <06bf50688ac75f5ee7af2cd2a9ae0d292f3002b9.1519404222.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday, 23 February 2018 18:43:48 EET Mauro Carvalho Chehab wrote:
> The filter callbaks now have an optional extra argument,
> meant to allow reporting statistics to userspace via mmap.
> 
> Set those to NULL, in order to avoid those build errors:
>   + drivers/media/pci/ttpci/av7110.c: error: too few arguments to function
> 'dvbdmxfilter->feed->cb.sec':  => 325:10 +
> drivers/media/pci/ttpci/av7110.c: error: too few arguments to function
> 'dvbdmxfilter->feed->cb.ts':  => 332:11 +
> drivers/media/pci/ttpci/av7110_av.c: error: too few arguments to function
> 'feed->cb.ts':  => 817:3
> 

I think this misses a Fixes: line. Apart from that it looks good to me.

With the Fixes: line,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/pci/ttpci/av7110.c        |  5 +++--
>  drivers/media/pci/ttpci/av7110_av.c     |  6 +++---
>  drivers/media/usb/ttusb-dec/ttusb_dec.c | 10 +++++-----
>  3 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/pci/ttpci/av7110.c
> b/drivers/media/pci/ttpci/av7110.c index dc8e577b2f74..d6816effb878 100644
> --- a/drivers/media/pci/ttpci/av7110.c
> +++ b/drivers/media/pci/ttpci/av7110.c
> @@ -324,14 +324,15 @@ static int DvbDmxFilterCallback(u8 *buffer1, size_t
> buffer1_len, }
>  		return dvbdmxfilter->feed->cb.sec(buffer1, buffer1_len,
>  						  buffer2, buffer2_len,
> -						  &dvbdmxfilter->filter);
> +						  &dvbdmxfilter->filter, NULL);
>  	case DMX_TYPE_TS:
>  		if (!(dvbdmxfilter->feed->ts_type & TS_PACKET))
>  			return 0;
>  		if (dvbdmxfilter->feed->ts_type & TS_PAYLOAD_ONLY)
>  			return dvbdmxfilter->feed->cb.ts(buffer1, buffer1_len,
>  							 buffer2, buffer2_len,
> -							 &dvbdmxfilter->feed->feed.ts);
> +							 &dvbdmxfilter->feed->feed.ts,
> +							 NULL);
>  		else
>  			av7110_p2t_write(buffer1, buffer1_len,
>  					 dvbdmxfilter->feed->pid,
> diff --git a/drivers/media/pci/ttpci/av7110_av.c
> b/drivers/media/pci/ttpci/av7110_av.c index 4daba76ec240..ef1bc17cdc4d
> 100644
> --- a/drivers/media/pci/ttpci/av7110_av.c
> +++ b/drivers/media/pci/ttpci/av7110_av.c
> @@ -99,7 +99,7 @@ int av7110_record_cb(struct dvb_filter_pes2ts *p2t, u8
> *buf, size_t len) buf[4] = buf[5] = 0;
>  	if (dvbdmxfeed->ts_type & TS_PAYLOAD_ONLY)
>  		return dvbdmxfeed->cb.ts(buf, len, NULL, 0,
> -					 &dvbdmxfeed->feed.ts);
> +					 &dvbdmxfeed->feed.ts, NULL);
>  	else
>  		return dvb_filter_pes2ts(p2t, buf, len, 1);
>  }
> @@ -109,7 +109,7 @@ static int dvb_filter_pes2ts_cb(void *priv, unsigned
> char *data) struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *)
> priv;
> 
>  	dvbdmxfeed->cb.ts(data, 188, NULL, 0,
> -			  &dvbdmxfeed->feed.ts);
> +			  &dvbdmxfeed->feed.ts, NULL);
>  	return 0;
>  }
> 
> @@ -814,7 +814,7 @@ static void p_to_t(u8 const *buf, long int length, u16
> pid, u8 *counter, memcpy(obuf + l, buf + c, TS_SIZE - l);
>  			c = length;
>  		}
> -		feed->cb.ts(obuf, 188, NULL, 0, &feed->feed.ts);
> +		feed->cb.ts(obuf, 188, NULL, 0, &feed->feed.ts, NULL);
>  		pes_start = 0;
>  	}
>  }
> diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c
> b/drivers/media/usb/ttusb-dec/ttusb_dec.c index a8900f5571f7..44ca66cb9b8f
> 100644
> --- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
> +++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> @@ -428,7 +428,7 @@ static int ttusb_dec_audio_pes2ts_cb(void *priv,
> unsigned char *data) struct ttusb_dec *dec = priv;
> 
>  	dec->audio_filter->feed->cb.ts(data, 188, NULL, 0,
> -				       &dec->audio_filter->feed->feed.ts);
> +				       &dec->audio_filter->feed->feed.ts, NULL);
> 
>  	return 0;
>  }
> @@ -438,7 +438,7 @@ static int ttusb_dec_video_pes2ts_cb(void *priv,
> unsigned char *data) struct ttusb_dec *dec = priv;
> 
>  	dec->video_filter->feed->cb.ts(data, 188, NULL, 0,
> -				       &dec->video_filter->feed->feed.ts);
> +				       &dec->video_filter->feed->feed.ts, NULL);
> 
>  	return 0;
>  }
> @@ -490,7 +490,7 @@ static void ttusb_dec_process_pva(struct ttusb_dec *dec,
> u8 *pva, int length)
> 
>  		if (output_pva) {
>  			dec->video_filter->feed->cb.ts(pva, length, NULL, 0,
> -				&dec->video_filter->feed->feed.ts);
> +				&dec->video_filter->feed->feed.ts, NULL);
>  			return;
>  		}
> 
> @@ -551,7 +551,7 @@ static void ttusb_dec_process_pva(struct ttusb_dec *dec,
> u8 *pva, int length) case 0x02:		/* MainAudioStream */
>  		if (output_pva) {
>  			dec->audio_filter->feed->cb.ts(pva, length, NULL, 0,
> -				&dec->audio_filter->feed->feed.ts);
> +				&dec->audio_filter->feed->feed.ts, NULL);
>  			return;
>  		}
> 
> @@ -589,7 +589,7 @@ static void ttusb_dec_process_filter(struct ttusb_dec
> *dec, u8 *packet,
> 
>  	if (filter)
>  		filter->feed->cb.sec(&packet[2], length - 2, NULL, 0,
> -				     &filter->filter);
> +				     &filter->filter, NULL);
>  }
> 
>  static void ttusb_dec_process_packet(struct ttusb_dec *dec)


-- 
Regards,

Laurent Pinchart
