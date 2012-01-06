Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36911 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970Ab2AFSkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:40:32 -0500
Received: by ghbg21 with SMTP id g21so829364ghb.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:40:31 -0800 (PST)
Date: Fri, 6 Jan 2012 12:40:26 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: [PATCH] [media] dm1105: release dvbnet on frontend attachment failure
Message-ID: <20120106184026.GH15740@elie.hsd1.il.comcast.net>
References: <E1RjBAD-0006UI-HU@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1RjBAD-0006UI-HU@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch "dm1105: handle errors from dvb_net_init" moved the
initialization of dvbnet to before frontend attachment but forgot
to adjust the error handling when frontend attachment fails.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Mauro Carvalho Chehab wrote:

> Subject: [media] dm1105: handle errors from dvb_net_init
[...]
> --- a/drivers/media/dvb/dm1105/dm1105.c
> +++ b/drivers/media/dvb/dm1105/dm1105.c
> @@ -1115,11 +1115,14 @@ static int __devinit dm1105_probe(struct pci_dev *pdev,
>  	if (ret < 0)
>  		goto err_remove_mem_frontend;
>  
> +	ret = dvb_net_init(dvb_adapter, &dev->dvbnet, dmx);
> +	if (ret < 0)
> +		goto err_disconnect_frontend;
> +
>  	ret = frontend_init(dev);
>  	if (ret < 0)
>  		goto err_disconnect_frontend;
>  
> -	dvb_net_init(dvb_adapter, &dev->dvbnet, dmx);

This looks bogus --- my fault, sorry.  Here's a fixup on top.

If create_singlethread_workqueue or a later step fails, I suspect this
still might not clean up as much as it should.  E.g., I expected to find
something like

	if (dev->fe->ops.release)
		dev->fe->ops.release(dev->fe);

somewhere in the cleanup code.

 drivers/media/dvb/dm1105/dm1105.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index 70e040b999e7..a609b3a9b146 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -1121,7 +1121,7 @@ static int __devinit dm1105_probe(struct pci_dev *pdev,
 
 	ret = frontend_init(dev);
 	if (ret < 0)
-		goto err_disconnect_frontend;
+		goto err_dvb_net;
 
 	dm1105_ir_init(dev);
 
-- 
1.7.8.2

