Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:38949 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab2AMMiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 07:38:03 -0500
Date: Fri, 13 Jan 2012 15:37:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: pboettcher@dibcom.fr
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (12892): DVB-API: add support for ISDB-T and ISDB-Tsb
 (version 5.1)
Message-ID: <20120113123757.GA21686@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Patrick Boettcher,

I know this patch is really old but I was hoping you still might be
able to take a look at it.

The patch b6e760f30975: "V4L/DVB (12892): DVB-API: add support for 
ISDB-T and ISDB-Tsb (version 5.1)" from Aug 3, 2009, leads to the 
following warning:
drivers/media/dvb/dvb-core/dvb_frontend.c:993:9: warning: Initializer entry defined twice
drivers/media/dvb/dvb-core/dvb_frontend.c:1012:9:   also defined here

The following two sections are basically cut and paste except that the
ones in the first section were changed to zeros.  The second set of
initializers over writes the first, so probably we could just remove
the first section?

drivers/media/dvb/dvb-core/dvb_frontend.c

+       _DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 1, 0),
+       _DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 1, 0),
+       _DTV_CMD(DTV_ISDBT_SB_SUBCHANNEL_ID, 1, 0),
+       _DTV_CMD(DTV_ISDBT_SB_SEGMENT_IDX, 1, 0),
+       _DTV_CMD(DTV_ISDBT_SB_SEGMENT_COUNT, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_FEC, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_MODULATION, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_SEGMENT_COUNT, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_TIME_INTERLEAVING, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_FEC, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_MODULATION, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_SEGMENT_COUNT, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_TIME_INTERLEAVING, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_FEC, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_MODULATION, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_SEGMENT_COUNT, 1, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 1, 0),
+
+       _DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 0, 0),
+       _DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 0, 0),
+       _DTV_CMD(DTV_ISDBT_SB_SUBCHANNEL_ID, 0, 0),
+       _DTV_CMD(DTV_ISDBT_SB_SEGMENT_IDX, 0, 0),
+       _DTV_CMD(DTV_ISDBT_SB_SEGMENT_COUNT, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_FEC, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_MODULATION, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_SEGMENT_COUNT, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERA_TIME_INTERLEAVING, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_FEC, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_MODULATION, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_SEGMENT_COUNT, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERB_TIME_INTERLEAVING, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_FEC, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_MODULATION, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_SEGMENT_COUNT, 0, 0),
+       _DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 0, 0),

regards,
dan carpenter

