Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:47822 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1DJMKN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 08:10:13 -0400
Message-ID: <4DA19E20.6040400@linuxtv.org>
Date: Sun, 10 Apr 2011 14:10:08 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Speed up DVB TS stream delivery from DMA buffer into
 dvb-core's buffer
References: <4D9F2C83.6070401@kolumbus.fi>
In-Reply-To: <4D9F2C83.6070401@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/08/2011 05:40 PM, Marko Ristola wrote:
> Avoid unnecessary DVB TS 188 sized packet copying from DMA buffer into stack.
> Backtrack one 188 sized packet just after some garbage bytes when possible.
> This obsoletes patch https://patchwork.kernel.org/patch/118147/
> 
> Signed-off-by: Marko Ristola marko.ristola@kolumbus.fi

Did you intentionally send a version that doesn't use likely()? Anyway,
those optimizations can still be done in an incremental patch.

Acked-by: Andreas Oberritter <obi@linuxtv.org>

> diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
> index 4a88a3e..faa3671 100644
> --- a/drivers/media/dvb/dvb-core/dvb_demux.c
> +++ b/drivers/media/dvb/dvb-core/dvb_demux.c
> @@ -478,97 +478,94 @@ void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
>  
>  EXPORT_SYMBOL(dvb_dmx_swfilter_packets);
>  
> -void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
> +static inline int find_next_packet(const u8 *buf, int pos, size_t count,
> +				   const int pktsize)
>  {
> -	int p = 0, i, j;
> +	int start = pos, lost;
>  
> -	spin_lock(&demux->lock);
> -
> -	if (demux->tsbufp) {
> -		i = demux->tsbufp;
> -		j = 188 - i;
> -		if (count < j) {
> -			memcpy(&demux->tsbuf[i], buf, count);
> -			demux->tsbufp += count;
> -			goto bailout;
> -		}
> -		memcpy(&demux->tsbuf[i], buf, j);
> -		if (demux->tsbuf[0] == 0x47)
> -			dvb_dmx_swfilter_packet(demux, demux->tsbuf);
> -		demux->tsbufp = 0;
> -		p += j;
> +	while (pos < count) {
> +		if (buf[pos] == 0x47 ||
> +		    (pktsize == 204 && buf[pos] == 0xB8))
> +			break;
> +		pos++;
>  	}
>  
> -	while (p < count) {
> -		if (buf[p] == 0x47) {
> -			if (count - p >= 188) {
> -				dvb_dmx_swfilter_packet(demux, &buf[p]);
> -				p += 188;
> -			} else {
> -				i = count - p;
> -				memcpy(demux->tsbuf, &buf[p], i);
> -				demux->tsbufp = i;
> -				goto bailout;
> -			}
> -		} else
> -			p++;
> +	lost = pos - start;
> +	if (lost) {
> +		/* This garbage is part of a valid packet? */
> +		int backtrack = pos - pktsize;
> +		if (backtrack >= 0 && (buf[backtrack] == 0x47 ||
> +		    (pktsize == 204 && buf[backtrack] == 0xB8)))
> +			return backtrack;
>  	}
>  
> -bailout:
> -	spin_unlock(&demux->lock);
> +	return pos;
>  }
>  
> -EXPORT_SYMBOL(dvb_dmx_swfilter);
> -
> -void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf, size_t count)
> +/* Filter all pktsize= 188 or 204 sized packets and skip garbage. */
> +static inline void _dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf,
> +		size_t count, const int pktsize)
>  {
>  	int p = 0, i, j;
> -	u8 tmppack[188];
> +	const u8 *q;
>  
>  	spin_lock(&demux->lock);
>  
> -	if (demux->tsbufp) {
> +	if (demux->tsbufp) { /* tsbuf[0] is now 0x47. */
>  		i = demux->tsbufp;
> -		j = 204 - i;
> +		j = pktsize - i;
>  		if (count < j) {
>  			memcpy(&demux->tsbuf[i], buf, count);
>  			demux->tsbufp += count;
>  			goto bailout;
>  		}
>  		memcpy(&demux->tsbuf[i], buf, j);
> -		if ((demux->tsbuf[0] == 0x47) || (demux->tsbuf[0] == 0xB8)) {
> -			memcpy(tmppack, demux->tsbuf, 188);
> -			if (tmppack[0] == 0xB8)
> -				tmppack[0] = 0x47;
> -			dvb_dmx_swfilter_packet(demux, tmppack);
> -		}
> +		if (demux->tsbuf[0] == 0x47) /* double check */
> +			dvb_dmx_swfilter_packet(demux, demux->tsbuf);
>  		demux->tsbufp = 0;
>  		p += j;
>  	}
>  
> -	while (p < count) {
> -		if ((buf[p] == 0x47) || (buf[p] == 0xB8)) {
> -			if (count - p >= 204) {
> -				memcpy(tmppack, &buf[p], 188);
> -				if (tmppack[0] == 0xB8)
> -					tmppack[0] = 0x47;
> -				dvb_dmx_swfilter_packet(demux, tmppack);
> -				p += 204;
> -			} else {
> -				i = count - p;
> -				memcpy(demux->tsbuf, &buf[p], i);
> -				demux->tsbufp = i;
> -				goto bailout;
> -			}
> -		} else {
> -			p++;
> +	while (1) {
> +		p = find_next_packet(buf, p, count, pktsize);
> +		if (p >= count)
> +			break;
> +		if (count - p < pktsize)
> +			break;
> +
> +		q = &buf[p];
> +
> +		if (pktsize == 204 && (*q == 0xB8)) {
> +			memcpy(demux->tsbuf, q, 188);
> +			demux->tsbuf[0] = 0x47;
> +			q = demux->tsbuf;
>  		}
> +		dvb_dmx_swfilter_packet(demux, q);
> +		p += pktsize;
> +	}
> +
> +	i = count - p;
> +	if (i) {
> +		memcpy(demux->tsbuf, &buf[p], i);
> +		demux->tsbufp = i;
> +		if (pktsize == 204 && demux->tsbuf[0] == 0xB8)
> +			demux->tsbuf[0] = 0x47;
>  	}
>  
>  bailout:
>  	spin_unlock(&demux->lock);
>  }
>  
> +void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
> +{
> +	_dvb_dmx_swfilter(demux, buf, count, 188);
> +}
> +EXPORT_SYMBOL(dvb_dmx_swfilter);
> +
> +void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf, size_t count)
> +{
> +	_dvb_dmx_swfilter(demux, buf, count, 204);
> +}
>  EXPORT_SYMBOL(dvb_dmx_swfilter_204);
>  
>  static struct dvb_demux_filter *dvb_dmx_filter_alloc(struct dvb_demux *demux)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

