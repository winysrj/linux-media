Return-path: <linux-media-owner@vger.kernel.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]:37539 "EHLO
	shogun.pilppa.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751853AbZALQSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 11:18:55 -0500
Date: Mon, 12 Jan 2009 18:18:46 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: Andy Walls <awalls@radix.net>
cc: Goga777 <goga777@bk.ru>, linux-dvb@linuxtv.org,
	linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [PATCH] cx88-dvb: Fix order of frontend allocations
 (Re: current v4l-dvb - cannot access /dev/dvb/: No such file or directory)
In-Reply-To: <1231719484.10277.4.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.64.0901121800470.672@shogun.pilppa.org>
References: <20090109154005.3295d447@bk.ru> <1231719484.10277.4.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463809533-1836640169-1231777126=:672"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463809533-1836640169-1231777126=:672
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

> I don't have the hardware to test with.  Please try this patch.

Hi

I tested the patch and it helped me to get the drivers back to normal 
state! My system has hvr-1300 and hvr-4000 and only 1 lnb without diseq.

I am using 2.6.27.7 kernel and I did two test runs.
- First I build the current drivers in http://linuxtv.org/hg/v4l-dvb/
   (revision http://linuxtv.org/hg/v4l-dvb/rev/036cad8c8b51)
   With this driver version linux failed to boot at all.
- Then I merged your patch by hand on top of this v4l-dvb version
   and I got the drivers back to normal version.
   With vdr-1.6.0 I was able to tune both the dvb-t channels from hvr-1300 
and dvb-s channels from hvr-4000. This vdr 1.6.0 uses old non 
S2API/backward compatibility layer of the drivers. I attach your patch 
just in case, as I did the merge by hand.

There is still some problem either within the S2API implementation itself 
for the HVR-4000 or in the way how VDR-1.7.1, 1.7.2 and 1.7.3 
uses S2API because I have not been able to use these newer VDR versions 
that use S2API for tuning to S/S2 channels. Technotrend TT S2 3200 users 
are however able to use these same VDR versions for tuning to S/S2 
channels.

DVB-T channels from hvr-1300 tunes ok with vdr-1.7.3.

I have tested this multiple different versions of D2API drivers both from 
the liplianis tree, stock drivers in 2.6.28 kernel and v4l-dvb tree.

Mika
>
> Signed-off-by: Andy Walls <awalls@radix.net>
>
> diff -r a28c39659c25 linux/drivers/media/video/cx88/cx88-dvb.c
> --- a/linux/drivers/media/video/cx88/cx88-dvb.c	Sat Jan 10 16:04:45 2009 -0500
> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Sun Jan 11 19:13:10 2009 -0500
> @@ -621,33 +621,40 @@ static struct stv0288_config tevii_tuner
> 	.set_ts_params = cx24116_set_ts_param,
> };
>
> +static int cx8802_alloc_frontends(struct cx8802_dev *dev)
> +{
> +	struct cx88_core *core = dev->core;
> +	struct videobuf_dvb_frontend *fe = NULL;
> +	int i;
> +
> +	mutex_init(&dev->frontends.lock);
> +	INIT_LIST_HEAD(&dev->frontends.felist);
> +
> +	if (!core->board.num_frontends)
> +		return -ENODEV;
> +
> +	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
> +			 core->board.num_frontends);
> +	for (i = 1; i <= core->board.num_frontends; i++) {
> +		fe = videobuf_dvb_alloc_frontend(&dev->frontends, i);
> +		if (!fe) {
> +			printk(KERN_ERR "%s() failed to alloc\n", __func__);
> +			videobuf_dvb_dealloc_frontends(&dev->frontends);
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
> static int dvb_register(struct cx8802_dev *dev)
> {
> 	struct cx88_core *core = dev->core;
> 	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
> 	int mfe_shared = 0; /* bus not shared by default */
> -	int i;
>
> 	if (0 != core->i2c_rc) {
> 		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
> 		goto frontend_detach;
> -	}
> -
> -	if (!core->board.num_frontends)
> -		return -EINVAL;
> -
> -	mutex_init(&dev->frontends.lock);
> -	INIT_LIST_HEAD(&dev->frontends.felist);
> -
> -	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
> -			 core->board.num_frontends);
> -	for (i = 1; i <= core->board.num_frontends; i++) {
> -		fe0 = videobuf_dvb_alloc_frontend(&dev->frontends, i);
> -		if (!fe0) {
> -			printk(KERN_ERR "%s() failed to alloc\n", __func__);
> -			videobuf_dvb_dealloc_frontends(&dev->frontends);
> -			goto frontend_detach;
> -		}
> 	}
>
> 	/* Get the first frontend */
> @@ -1253,6 +1260,8 @@ static int cx8802_dvb_probe(struct cx880
> 	struct cx88_core *core = drv->core;
> 	struct cx8802_dev *dev = drv->core->dvbdev;
> 	int err;
> +	struct videobuf_dvb_frontend *fe;
> +	int i;
>
> 	dprintk( 1, "%s\n", __func__);
> 	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
> @@ -1268,39 +1277,34 @@ static int cx8802_dvb_probe(struct cx880
> 	/* If vp3054 isn't enabled, a stub will just return 0 */
> 	err = vp3054_i2c_probe(dev);
> 	if (0 != err)
> -		goto fail_probe;
> +		goto fail_core;
>
> 	/* dvb stuff */
> 	printk(KERN_INFO "%s/2: cx2388x based DVB/ATSC card\n", core->name);
> 	dev->ts_gen_cntrl = 0x0c;
>
> +	err = cx8802_alloc_frontends(dev);
> +	if (err)
> +		goto fail_core;
> +
> 	err = -ENODEV;
> -	if (core->board.num_frontends) {
> -		struct videobuf_dvb_frontend *fe;
> -		int i;
> -
> -		for (i = 1; i <= core->board.num_frontends; i++) {
> -			fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
> -			if (fe == NULL) {
> -				printk(KERN_ERR "%s() failed to get frontend(%d)\n",
> +	for (i = 1; i <= core->board.num_frontends; i++) {
> +		fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
> +		if (fe == NULL) {
> +			printk(KERN_ERR "%s() failed to get frontend(%d)\n",
> 					__func__, i);
> -				goto fail_probe;
> -			}
> -			videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
> +			goto fail_probe;
> +		}
> +		videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
> 				    &dev->pci->dev, &dev->slock,
> 				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
> 				    V4L2_FIELD_TOP,
> 				    sizeof(struct cx88_buffer),
> 				    dev);
> -			/* init struct videobuf_dvb */
> -			fe->dvb.name = dev->core->name;
> -		}
> -	} else {
> -		/* no frontends allocated */
> -		printk(KERN_ERR "%s/2 .num_frontends should be non-zero\n",
> -			core->name);
> -		goto fail_core;
> +		/* init struct videobuf_dvb */
> +		fe->dvb.name = dev->core->name;
> 	}
> +
> 	err = dvb_register(dev);
> 	if (err)
> 		/* frontends/adapter de-allocated in dvb_register */
>
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
---1463809533-1836640169-1231777126=:672
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=andys_dvb_v4l_irq_fix.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0901121818460.672@shogun.pilppa.org>
Content-Description: cx88-dvb frontend allocation fix from Andy Walls
Content-Disposition: attachment; filename=andys_dvb_v4l_irq_fix.patch

ZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8v
Y3g4OC9jeDg4LWR2Yi5jIHY0bC1kdmItcGF0Y2hlZC9saW51eC9kcml2ZXJz
L21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1kdmIuYw0KLS0tIHY0bC1kdmIvbGlu
dXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgtZHZiLmMJMjAwOS0w
MS0xMiAxNzo1NToyMS4wMDAwMDAwMDAgKzAyMDANCisrKyB2NGwtZHZiLXBh
dGNoZWQvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgtZHZi
LmMJMjAwOS0wMS0xMiAxNzo1NTo0OS4wMDAwMDAwMDAgKzAyMDANCkBAIC02
MjEsMzUgKzYyMSw0MiBAQA0KIAkuc2V0X3RzX3BhcmFtcyA9IGN4MjQxMTZf
c2V0X3RzX3BhcmFtLA0KIH07DQogDQorc3RhdGljIGludCBjeDg4MDJfYWxs
b2NfZnJvbnRlbmRzKHN0cnVjdCBjeDg4MDJfZGV2ICpkZXYpDQorew0KKyAg
ICAgICBzdHJ1Y3QgY3g4OF9jb3JlICpjb3JlID0gZGV2LT5jb3JlOw0KKyAg
ICAgICBzdHJ1Y3QgdmlkZW9idWZfZHZiX2Zyb250ZW5kICpmZSA9IE5VTEw7
DQorICAgICAgIGludCBpOw0KKw0KKyAgICAgICBtdXRleF9pbml0KCZkZXYt
PmZyb250ZW5kcy5sb2NrKTsNCisgICAgICAgSU5JVF9MSVNUX0hFQUQoJmRl
di0+ZnJvbnRlbmRzLmZlbGlzdCk7DQorDQorICAgICAgIGlmICghY29yZS0+
Ym9hcmQubnVtX2Zyb250ZW5kcykNCisgICAgICAgICAgICAgICByZXR1cm4g
LUVOT0RFVjsNCisNCisgICAgICAgcHJpbnRrKEtFUk5fSU5GTyAiJXMoKSBh
bGxvY2F0aW5nICVkIGZyb250ZW5kKHMpXG4iLCBfX2Z1bmNfXywNCisgICAg
ICAgICAgICAgICAgICAgICAgICBjb3JlLT5ib2FyZC5udW1fZnJvbnRlbmRz
KTsNCisgICAgICAgZm9yIChpID0gMTsgaSA8PSBjb3JlLT5ib2FyZC5udW1f
ZnJvbnRlbmRzOyBpKyspIHsNCisgICAgICAgICAgICAgICBmZSA9IHZpZGVv
YnVmX2R2Yl9hbGxvY19mcm9udGVuZCgmZGV2LT5mcm9udGVuZHMsIGkpOw0K
KyAgICAgICAgICAgICAgIGlmICghZmUpIHsNCisgICAgICAgICAgICAgICAg
ICAgICAgIHByaW50ayhLRVJOX0VSUiAiJXMoKSBmYWlsZWQgdG8gYWxsb2Nc
biIsIF9fZnVuY19fKTsNCisgICAgICAgICAgICAgICAgICAgICAgIHZpZGVv
YnVmX2R2Yl9kZWFsbG9jX2Zyb250ZW5kcygmZGV2LT5mcm9udGVuZHMpOw0K
KyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQorICAg
ICAgICAgICAgICAgfQ0KKyAgICAgICB9DQorICAgICAgIHJldHVybiAwOw0K
K30NCisNCiBzdGF0aWMgaW50IGR2Yl9yZWdpc3RlcihzdHJ1Y3QgY3g4ODAy
X2RldiAqZGV2KQ0KIHsNCiAJc3RydWN0IGN4ODhfY29yZSAqY29yZSA9IGRl
di0+Y29yZTsNCiAJc3RydWN0IHZpZGVvYnVmX2R2Yl9mcm9udGVuZCAqZmUw
LCAqZmUxID0gTlVMTDsNCiAJaW50IG1mZV9zaGFyZWQgPSAwOyAvKiBidXMg
bm90IHNoYXJlZCBieSBkZWZhdWx0ICovDQotCWludCBpOw0KIA0KIAlpZiAo
MCAhPSBjb3JlLT5pMmNfcmMpIHsNCiAJCXByaW50ayhLRVJOX0VSUiAiJXMv
Mjogbm8gaTJjLWJ1cyBhdmFpbGFibGUsIGNhbm5vdCBhdHRhY2ggZHZiIGRy
aXZlcnNcbiIsIGNvcmUtPm5hbWUpOw0KIAkJZ290byBmcm9udGVuZF9kZXRh
Y2g7DQogCX0NCiANCi0JaWYgKCFjb3JlLT5ib2FyZC5udW1fZnJvbnRlbmRz
KQ0KLQkJcmV0dXJuIC1FSU5WQUw7DQotDQotCW11dGV4X2luaXQoJmRldi0+
ZnJvbnRlbmRzLmxvY2spOw0KLQlJTklUX0xJU1RfSEVBRCgmZGV2LT5mcm9u
dGVuZHMuZmVsaXN0KTsNCi0NCi0JcHJpbnRrKEtFUk5fSU5GTyAiJXMoKSBh
bGxvY2F0aW5nICVkIGZyb250ZW5kKHMpXG4iLCBfX2Z1bmNfXywNCi0JCQkg
Y29yZS0+Ym9hcmQubnVtX2Zyb250ZW5kcyk7DQotCWZvciAoaSA9IDE7IGkg
PD0gY29yZS0+Ym9hcmQubnVtX2Zyb250ZW5kczsgaSsrKSB7DQotCQlmZTAg
PSB2aWRlb2J1Zl9kdmJfYWxsb2NfZnJvbnRlbmQoJmRldi0+ZnJvbnRlbmRz
LCBpKTsNCi0JCWlmICghZmUwKSB7DQotCQkJcHJpbnRrKEtFUk5fRVJSICIl
cygpIGZhaWxlZCB0byBhbGxvY1xuIiwgX19mdW5jX18pOw0KLQkJCXZpZGVv
YnVmX2R2Yl9kZWFsbG9jX2Zyb250ZW5kcygmZGV2LT5mcm9udGVuZHMpOw0K
LQkJCWdvdG8gZnJvbnRlbmRfZGV0YWNoOw0KLQkJfQ0KLQl9DQotDQogCS8q
IEdldCB0aGUgZmlyc3QgZnJvbnRlbmQgKi8NCiAJZmUwID0gdmlkZW9idWZf
ZHZiX2dldF9mcm9udGVuZCgmZGV2LT5mcm9udGVuZHMsIDEpOw0KIAlpZiAo
IWZlMCkNCkBAIC0xMjUzLDYgKzEyNjAsOCBAQA0KIAlzdHJ1Y3QgY3g4OF9j
b3JlICpjb3JlID0gZHJ2LT5jb3JlOw0KIAlzdHJ1Y3QgY3g4ODAyX2RldiAq
ZGV2ID0gZHJ2LT5jb3JlLT5kdmJkZXY7DQogCWludCBlcnI7DQorCXN0cnVj
dCB2aWRlb2J1Zl9kdmJfZnJvbnRlbmQgKmZlOw0KKwlpbnQgaTsNCiANCiAJ
ZHByaW50ayggMSwgIiVzXG4iLCBfX2Z1bmNfXyk7DQogCWRwcmludGsoIDEs
ICIgLT5iZWluZyBwcm9iZWQgYnkgQ2FyZD0lZCBOYW1lPSVzLCBQQ0kgJTAy
eDolMDJ4XG4iLA0KQEAgLTEyNjgsMzkgKzEyNzcsMzQgQEANCiAJLyogSWYg
dnAzMDU0IGlzbid0IGVuYWJsZWQsIGEgc3R1YiB3aWxsIGp1c3QgcmV0dXJu
IDAgKi8NCiAJZXJyID0gdnAzMDU0X2kyY19wcm9iZShkZXYpOw0KIAlpZiAo
MCAhPSBlcnIpDQotCQlnb3RvIGZhaWxfcHJvYmU7DQorCQlnb3RvIGZhaWxf
Y29yZTsNCiANCiAJLyogZHZiIHN0dWZmICovDQogCXByaW50ayhLRVJOX0lO
Rk8gIiVzLzI6IGN4MjM4OHggYmFzZWQgRFZCL0FUU0MgY2FyZFxuIiwgY29y
ZS0+bmFtZSk7DQogCWRldi0+dHNfZ2VuX2NudHJsID0gMHgwYzsNCiANCisJ
ZXJyID0gY3g4ODAyX2FsbG9jX2Zyb250ZW5kcyhkZXYpOw0KKwlpZiAoZXJy
KQ0KKwkJZ290byBmYWlsX2NvcmU7DQorDQogCWVyciA9IC1FTk9ERVY7DQot
CWlmIChjb3JlLT5ib2FyZC5udW1fZnJvbnRlbmRzKSB7DQotCQlzdHJ1Y3Qg
dmlkZW9idWZfZHZiX2Zyb250ZW5kICpmZTsNCi0JCWludCBpOw0KLQ0KLQkJ
Zm9yIChpID0gMTsgaSA8PSBjb3JlLT5ib2FyZC5udW1fZnJvbnRlbmRzOyBp
KyspIHsNCi0JCQlmZSA9IHZpZGVvYnVmX2R2Yl9nZXRfZnJvbnRlbmQoJmNv
cmUtPmR2YmRldi0+ZnJvbnRlbmRzLCBpKTsNCi0JCQlpZiAoZmUgPT0gTlVM
TCkgew0KLQkJCQlwcmludGsoS0VSTl9FUlIgIiVzKCkgZmFpbGVkIHRvIGdl
dCBmcm9udGVuZCglZClcbiIsDQorCWZvciAoaSA9IDE7IGkgPD0gY29yZS0+
Ym9hcmQubnVtX2Zyb250ZW5kczsgaSsrKSB7DQorCQlmZSA9IHZpZGVvYnVm
X2R2Yl9nZXRfZnJvbnRlbmQoJmNvcmUtPmR2YmRldi0+ZnJvbnRlbmRzLCBp
KTsNCisJCWlmIChmZSA9PSBOVUxMKSB7DQorCQkJcHJpbnRrKEtFUk5fRVJS
ICIlcygpIGZhaWxlZCB0byBnZXQgZnJvbnRlbmQoJWQpXG4iLA0KIAkJCQkJ
X19mdW5jX18sIGkpOw0KLQkJCQlnb3RvIGZhaWxfcHJvYmU7DQotCQkJfQ0K
LQkJCXZpZGVvYnVmX3F1ZXVlX3NnX2luaXQoJmZlLT5kdmIuZHZicSwgJmR2
Yl9xb3BzLA0KKwkJCWdvdG8gZmFpbF9wcm9iZTsNCisJCX0NCisJCXZpZGVv
YnVmX3F1ZXVlX3NnX2luaXQoJmZlLT5kdmIuZHZicSwgJmR2Yl9xb3BzLA0K
IAkJCQkgICAgJmRldi0+cGNpLT5kZXYsICZkZXYtPnNsb2NrLA0KIAkJCQkg
ICAgVjRMMl9CVUZfVFlQRV9WSURFT19DQVBUVVJFLA0KIAkJCQkgICAgVjRM
Ml9GSUVMRF9UT1AsDQogCQkJCSAgICBzaXplb2Yoc3RydWN0IGN4ODhfYnVm
ZmVyKSwNCiAJCQkJICAgIGRldik7DQotCQkJLyogaW5pdCBzdHJ1Y3Qgdmlk
ZW9idWZfZHZiICovDQotCQkJZmUtPmR2Yi5uYW1lID0gZGV2LT5jb3JlLT5u
YW1lOw0KLQkJfQ0KLQl9IGVsc2Ugew0KLQkJLyogbm8gZnJvbnRlbmRzIGFs
bG9jYXRlZCAqLw0KLQkJcHJpbnRrKEtFUk5fRVJSICIlcy8yIC5udW1fZnJv
bnRlbmRzIHNob3VsZCBiZSBub24temVyb1xuIiwNCi0JCQljb3JlLT5uYW1l
KTsNCi0JCWdvdG8gZmFpbF9jb3JlOw0KKwkJLyogaW5pdCBzdHJ1Y3Qgdmlk
ZW9idWZfZHZiICovDQorCQlmZS0+ZHZiLm5hbWUgPSBkZXYtPmNvcmUtPm5h
bWU7DQogCX0NCisNCiAJZXJyID0gZHZiX3JlZ2lzdGVyKGRldik7DQogCWlm
IChlcnIpDQogCQkvKiBmcm9udGVuZHMvYWRhcHRlciBkZS1hbGxvY2F0ZWQg
aW4gZHZiX3JlZ2lzdGVyICovDQo=

---1463809533-1836640169-1231777126=:672--
