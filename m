Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbZDTPCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 11:02:51 -0400
Date: Mon, 20 Apr 2009 12:02:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_7] Siano: smsdvb - modify license header and
 included file list.
Message-ID: <20090420120244.0661741a@pedra.chehab.org>
In-Reply-To: <399946.98112.qm@web110811.mail.gq1.yahoo.com>
References: <399946.98112.qm@web110811.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 01:37:23 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1238695774 -10800
> # Node ID 7b5d5a3a7b8e80359e770041ca4c8cf407d893d6
> # Parent  4a0b207a424af7f05d8eb417a698a82a61dd086f
> [PATCH] [0904_7] Siano: smsdvb - modify license header
> and included file list.
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> smsdvb.c (client for DVB-API v3) - modify license header
> and included file list. Removing white spaces.
> There are no implementation changes.

Please split it into different patches:
	license changes;
	whitespacing and CodingStyle cleanups;
	compat patch;
	init_completion patch.

> 
> 
> Priority: normal
> 
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> 
> +
> +#ifndef DVB_DEFINE_MOD_OPT_ADAPTER_NR
> +#define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
> +		static short adapter_nr[] = \
> +		{[0 ... (8 - 1)] = -1 }; \
> +		module_param_array(adapter_nr, short, NULL, 0444); \
> +		MODULE_PARM_DESC(adapter_nr, "DVB adapter numbers")
> +#define SMS_DVB_OLD_DVB_REGISTER_ADAPTER
> +#endif
>  

Why do you need to add such test? If this is due to compat issues, please add
it into a separate patch, and patch also v4l/scripts/gentree.pl to discard
those changes when submitting it upstream.

> +	/*
> +	 if (client->fe_status & FE_HAS_LOCK)
> +	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_LOCK);
> +	 else
> +	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_FE_UNLOCK);
> +	 if (client->sms_stat_dvb.ReceptionData.ErrorTSPackets == 0)
> +	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_OK);
> +	 else
> +	 sms_board_dvb3_event(client->coredev, DVB3_EVENT_UNC_ERR);
> +	 */

The indentation of the above code is completely wrong. Also, it is much better to comment experimental codes like the above with:

#if 0
	/* Some reason why the code is commented */

	(the code)
#endif

> -		.caps = FE_CAN_INVERSION_AUTO |
> -			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> -			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> -			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
> -			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> -			FE_CAN_GUARD_INTERVAL_AUTO |
> -			FE_CAN_RECOVER |
> -			FE_CAN_HIERARCHY_AUTO,
> +		 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> +		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> +		 FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
> +		 FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> +		 FE_CAN_GUARD_INTERVAL_AUTO |
> +		 FE_CAN_RECOVER | FE_CAN_HIERARCHY_AUTO,

I suspect that you run some tool like indent to "fix" indentation. It should be
noticed that sometimes indent produces very bad results. 

In the above, the previous way is correct.

> @@ -541,7 +563,6 @@ static int smsdvb_hotplug(struct smscore
>  	client->coredev = coredev;
>  
>  	init_completion(&client->tune_done);
> -	init_completion(&client->stat_done);
>  
>  	kmutex_lock(&g_smsdvb_clientslock);

The above is unrelated to the other changes. Please break it into a separate
changeset, providing an explanation: why do we need to remove it.

Cheers,
Mauro
