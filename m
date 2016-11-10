Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45015
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752528AbcKJIHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 03:07:39 -0500
Date: Thu, 10 Nov 2016 06:07:17 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: VDR User <user.vdr@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
Message-ID: <20161110060717.221e8d88@vento.lan>
In-Reply-To: <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
        <20161108155520.224229d5@vento.lan>
        <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
        <20161109073331.204b53c4@vento.lan>
        <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
        <CAA7C2qi2tk9Out3Q4=uj-kJwhczfG1vK55a7EN4Wg_ibbn0HzA@mail.gmail.com>
        <20161109153521.232b0956@vento.lan>
        <CAA7C2qjojJD17Y+=+NpxnJns_0Uby4mARzsXAx_+3gjQ+NzmQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Nov 2016 17:03:52 -0800
VDR User <user.vdr@gmail.com> escreveu:

> >> (gdb) l *module_put+0x67
> >> 0xc10a4b87 is in module_put (kernel/module.c:1108).
> >> 1103            int ret;
> >> 1104
> >> 1105            if (module) {
> >> 1106                    preempt_disable();
> >> 1107                    ret = atomic_dec_if_positive(&module->refcnt);
> >> 1108                    WARN_ON(ret < 0);       /* Failed to put refcount */
> >> 1109                    trace_module_put(module, _RET_IP_);
> >> 1110                    preempt_enable();
> >> 1111            }
> >> 1112    }  
> >
> > OK, I guess we've made progress. Please try the enclosed patch.
> >
> > Regards,
> > Mauro
> >
> > [media] gp8psk: Fix DVB frontend attach
> >
> > it should be calling module_get() at attach, as otherwise
> > module_put() will crash.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> I think you forgot the patch. :)

commit 0c979a12309af49894bb1dc60e747c3cd53fa888
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Wed Nov 9 15:33:17 2016 -0200

    [media] gp8psk: Fix DVB frontend attach
    
    it should be calling module_get() at attach, as otherwise
    module_put() will crash.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index cede0d8b0f8a..24eb6c6c8e24 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -250,7 +250,7 @@ static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 static int gp8psk_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe_adap[0].fe = gp8psk_fe_attach(adap->dev);
+	adap->fe_adap[0].fe = dvb_attach(gp8psk_fe_attach, adap->dev);
 	return 0;
 }
