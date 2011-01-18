Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:44844 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752740Ab1ARJOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 04:14:33 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 07/16] ngene: CXD2099AR Common Interface driver
Date: Tue, 18 Jan 2011 10:13:48 +0100
Cc: linux-media@vger.kernel.org, Andreas Oberritter <obi@linuxtv.org>,
	Ralph Metzler <rjkm@metzlerbros.de>
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de> <201101101820.07907@orion.escape-edv.de> <4D346ED3.2030703@redhat.com>
In-Reply-To: <4D346ED3.2030703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101181013.49222@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 17 January 2011 17:31:15 Mauro Carvalho Chehab wrote:
> Em 10-01-2011 15:20, Oliver Endriss escreveu:
> > On Monday 10 January 2011 15:05:34 Andreas Oberritter wrote:
> >> On 01/10/2011 10:36 AM, Oliver Endriss wrote:
> >>> From: Ralph Metzler <rjkm@metzlerbros.de>
> >>>
> >>> Driver for the Common Interface Controller CXD2099AR.
> >>> Supports the CI of the cineS2 DVB-S2.
> >>>
> >>> For now, data is passed through '/dev/dvb/adapterX/sec0':
> >>> - Encrypted data must be written to 'sec0'.
> >>> - Decrypted data can be read from 'sec0'.
> >>> - Setup the CAM using device 'ca0'.
> >>
> >> Nack. In DVB API terms, "sec" stands for satellite equipment control,
> >> and if I remember correctly, sec0 already existed in the first versions
> >> of the API and that's why its leftovers can be abused by this driver.
> >>
> >> The interfaces for writing data are dvr0 and demux0. If they don't fit
> >> for decryption of recorded data, then they should be extended.
> >>
> >> For decryption of live data, no new user interface needs to be created.
> > 
> > There was an attempt to find a solution for the problem in thread
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html
> > 
> > As that discussion did not come to a final solution, and the driver is
> > still experimental, I left the original patch 'as is'.
> 
> Drivers that don't use the proper API should be moved to staging. Just making
> them as experimental is not good enough. As this is the only issue with
> this patch series, I'll be applying them and moving cxd2099 driver to staging
> while we don't have a proper fix for it.

Ok.

> +struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif

If staging drivers are disabled, compilation will fail with
"multiple definition of `cxd2099_attach'".

The helper function must be declared as 'static inline'.

Please apply this fix:

diff --git a/drivers/staging/cxd2099/cxd2099.h b/drivers/staging/cxd2099/cxd2099.h
index a313dc2..bed54ff 100644
--- a/drivers/staging/cxd2099/cxd2099.h
+++ b/drivers/staging/cxd2099/cxd2099.h
@@ -31,7 +31,7 @@
         (defined(CONFIG_DVB_CXD2099_MODULE) && defined(MODULE))
 struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c);
 #else
-struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c)
+static inline struct dvb_ca_en50221 *cxd2099_attach(u8 adr, void *priv, struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;


-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
