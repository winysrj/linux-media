Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60868 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2AQI7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 03:59:10 -0500
Received: by wibhm6 with SMTP id hm6so1186437wib.19
        for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 00:59:09 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: V4L/DVB (12892): DVB-API: add support for ISDB-T and ISDB-Tsb (version 5.1)
Date: Tue, 17 Jan 2012 09:58:59 +0100
Cc: linux-media@vger.kernel.org
References: <20120113123757.GA21686@elgon.mountain>
In-Reply-To: <20120113123757.GA21686@elgon.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201170959.00233.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 January 2012 13:37:57 Dan Carpenter wrote:
> Hello Patrick Boettcher,
> 
> I know this patch is really old but I was hoping you still might be
> able to take a look at it.
> 
> The patch b6e760f30975: "V4L/DVB (12892): DVB-API: add support for
> ISDB-T and ISDB-Tsb (version 5.1)" from Aug 3, 2009, leads to the
> following warning:
> drivers/media/dvb/dvb-core/dvb_frontend.c:993:9: warning: Initializer
> entry defined twice
> drivers/media/dvb/dvb-core/dvb_frontend.c:1012:9:   also defined
> here

How does this thing has lived such a long time without being noticed by 
anyone? Very strange.

Of course this is wrong and it should be fixed by removing the second 
section. IOW, we should keep the section with the 1s. 

> drivers/media/dvb/dvb-core/dvb_frontend.c
> 
> +       _DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_SB_SUBCHANNEL_ID, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_SB_SEGMENT_IDX, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_SB_SEGMENT_COUNT, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERA_FEC, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERA_MODULATION, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERA_SEGMENT_COUNT, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERA_TIME_INTERLEAVING, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERB_FEC, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERB_MODULATION, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERB_SEGMENT_COUNT, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERB_TIME_INTERLEAVING, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERC_FEC, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERC_MODULATION, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERC_SEGMENT_COUNT, 1, 0),
> +       _DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 1, 0),

I prepared a patch for this in my repo. I will send a pull-request right 
away.

Thanks for pointing this out.

regards,
--
Patrick.
