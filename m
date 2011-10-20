Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46722 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751341Ab1JTXoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 19:44:32 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [media] av7110: wrong limiter in av7110_start_feed()
Date: Fri, 21 Oct 2011 01:39:31 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Derek Kelly <user.vdr@gmail.com>,
	"Hans J. Koch" <hjk@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
	Ben Pfaff <blp@cs.stanford.edu>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20111018061209.GF27732@elgon.mountain>
In-Reply-To: <20111018061209.GF27732@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201110210139.33912@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 18 October 2011 08:12:09 Dan Carpenter wrote:
> Smatch complains that the wrong limiter is used here:
> drivers/media/dvb/ttpci/av7110.c +906 dvb_feed_start_pid(12)
> 	error: buffer overflow 'npids' 5 <= 19
> 
> Here is the problem code:
>    905          i = dvbdmxfeed->pes_type;
>    906          npids[i] = (pid[i]&0x8000) ? 0 : pid[i];
> 
> "npids" is a 5 element array declared on the stack.  If
> dvbdmxfeed->pes_type is more than 4 we probably put a (u16)0 past
> the end of the array.
> 
> If dvbdmxfeed->pes_type is over 4 the rest of the function doesn't
> do anything.  dvbdmxfeed->pes_type is capped at less than
> DMX_TS_PES_OTHER (20) in the caller function, but I changed it to
> less than or equal to DMX_TS_PES_PCR (4).
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
> index 3d20719..abf6b55 100644
> --- a/drivers/media/dvb/ttpci/av7110.c
> +++ b/drivers/media/dvb/ttpci/av7110.c
> @@ -991,7 +991,7 @@ static int av7110_start_feed(struct dvb_demux_feed *feed)
>  
>  	if (feed->type == DMX_TYPE_TS) {
>  		if ((feed->ts_type & TS_DECODER) &&
> -		    (feed->pes_type < DMX_TS_PES_OTHER)) {
> +		    (feed->pes_type <= DMX_TS_PES_PCR)) {
>  			switch (demux->dmx.frontend->source) {
>  			case DMX_MEMORY_FE:
>  				if (feed->ts_type & TS_DECODER)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Acked-by: Oliver Endriss <o.endriss@gmx.de>

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
