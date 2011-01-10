Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:54412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754520Ab1AJR3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 12:29:44 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: =?utf-8?q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 03/16] ngene: Firmware 18 support
Date: Mon, 10 Jan 2011 18:12:04 +0100
Cc: linux-media@vger.kernel.org
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de> <1294652184-12843-4-git-send-email-o.endriss@gmx.de> <8762twyi31.fsf@nemi.mork.no>
In-Reply-To: <8762twyi31.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201101101812.05395@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 10 January 2011 15:00:18 Bjørn Mork wrote:
> Oliver Endriss <o.endriss@gmx.de> writes:
> 
> > +	case 18:
> > +		size = 0;
> > +		fw_name = "ngene_18.fw";
> > +		break;
> >  	}
> >  
> >  	if (request_firmware(&fw, fw_name, &dev->pci_dev->dev) < 0) {
> > @@ -1266,6 +1270,8 @@ static int ngene_load_firm(struct ngene *dev)
> >  			": Copy %s to your hotplug directory!\n", fw_name);
> >  		return -1;
> >  	}
> > +	if (size == 0)
> > +		size = fw->size;
> >  	if (size != fw->size) {
> >  		printk(KERN_ERR DEVICE_NAME
> >  			": Firmware %s has invalid size!", fw_name);
> 
> 
> Just a stupid question:  Why remove the size verification for version 18
> while keeping it for the other firmware revisions?

Good point. This was handy when the firmware was developed.
I will submit an additional patch which adds a size check for Fw18.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
