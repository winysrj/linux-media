Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53075 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1LaMic (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:38:32 -0500
Date: Sat, 31 Dec 2011 13:38:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: David Fries <david@fries.net>, Istvan Varga <istvan_v@mailbox.hu>,
	linux-media@vger.kernel.org, Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH 9/9] [media] firedtv: handle errors from dvb_net_init
Message-ID: <20111231133803.7d6bc3f5@stein>
In-Reply-To: <20111231121956.GK16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
	<20111231115117.GB16802@elie.Belkin>
	<20111231121956.GK16802@elie.Belkin>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dec 31 Jonathan Nieder wrote:
> It is not common for dvb_net_init to fail, but after the patch
> "dvb_net_init: return -errno on error" it can fail due to running out
> of memory.  Handle this.
> From an audit of dvb_net_init callers.
> 
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>

Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

[...]
> --- a/drivers/media/dvb/firewire/firedtv-dvb.c
> +++ b/drivers/media/dvb/firewire/firedtv-dvb.c
> @@ -203,7 +203,9 @@ int fdtv_dvb_register(struct firedtv *fdtv, const
> char *name) if (err)
>  		goto fail_rem_frontend;
>  
> -	dvb_net_init(&fdtv->adapter, &fdtv->dvbnet, &fdtv->demux.dmx);
> +	err = dvb_net_init(&fdtv->adapter, &fdtv->dvbnet,
> &fdtv->demux.dmx);
> +	if (err)
> +		goto fail_disconnect_frontend;
>  
>  	fdtv_frontend_init(fdtv, name);
>  	err = dvb_register_frontend(&fdtv->adapter, &fdtv->fe);
> @@ -218,6 +220,7 @@ int fdtv_dvb_register(struct firedtv *fdtv, const
> char *name) 
>  fail_net_release:
>  	dvb_net_release(&fdtv->dvbnet);
> +fail_disconnect_frontend:
>  	fdtv->demux.dmx.close(&fdtv->demux.dmx);
>  fail_rem_frontend:
>  	fdtv->demux.dmx.remove_frontend(&fdtv->demux.dmx,
> &fdtv->frontend);

-- 
Stefan Richter
-=====-==-== ==-- =====
http://arcgraph.de/sr/
