Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDTQVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 12:21:48 -0400
Date: Mon, 20 Apr 2009 13:21:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_10] Siano: smsdvb - add events mechanism
Message-ID: <20090420132141.399600a6@pedra.chehab.org>
In-Reply-To: <827426.7180.qm@web110807.mail.gq1.yahoo.com>
References: <827426.7180.qm@web110807.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 03:18:01 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1238742622 -10800
> # Node ID ec7ee486fb86d51bdb48e6a637a6ddd52e9e08c2
> # Parent  020ba7b31c963bd36d607848198e9e4258a6f80e
> [PATCH] [0904_10] Siano: smsdvb - add events mechanism
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> Add events mechanism that will notify the "cards" component
> (which represent the specific hardware target) for DVB related
> events.


This patch contains unrelated coding style fixes. Some of them seem to be
related to previous changesets not applied.

It is better to split coding style and real changes into separate patches. 

> +/* Events that may come from DVB v3 adapter */
> +static void sms_board_dvb3_event(struct smscore_device_t *coredev,
> +		enum SMS_DVB3_EVENTS event) {
> +	switch (event) {
> +	case DVB3_EVENT_INIT:
> +		sms_debug("DVB3_EVENT_INIT");
> +		/* sms_board_event(coredev, BOARD_EVENT_BIND); */
> +		break;
> +	case DVB3_EVENT_SLEEP:
> +		sms_debug("DVB3_EVENT_SLEEP");
> +		/* sms_board_event(coredev, BOARD_EVENT_POWER_SUSPEND); */
> +		break;
> +	case DVB3_EVENT_HOTPLUG:
> +		sms_debug("DVB3_EVENT_HOTPLUG");
> +		/* sms_board_event(coredev, BOARD_EVENT_POWER_INIT); */
> +		break;
> +	case DVB3_EVENT_FE_LOCK:
> +		sms_debug("DVB3_EVENT_FE_LOCK");
> +		/* sms_board_event(coredev, BOARD_EVENT_FE_LOCK); */
> +		break;
> +	case DVB3_EVENT_FE_UNLOCK:
> +		sms_debug("DVB3_EVENT_FE_UNLOCK");
> +		/* sms_board_event(coredev, BOARD_EVENT_FE_UNLOCK); */
> +		break;
> +	case DVB3_EVENT_UNC_OK:
> +		sms_debug("DVB3_EVENT_UNC_OK");
> +		/* sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_OK); */
> +		break;
> +	case DVB3_EVENT_UNC_ERR:
> +		sms_debug("DVB3_EVENT_UNC_ERR");
> +		/* sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_ERRORS); */
> +		break;
> +
> +	default:
> +		sms_err("Unknown dvb3 api event");
> +		break;
> +	}
> +}

This seems to be the core of this changeset. However, it just prints debug
messages, since the real call to the event notification mechanism is commented.


Cheers,
Mauro
