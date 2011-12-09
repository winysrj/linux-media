Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1LILqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 06:46:21 -0500
Message-ID: <4EE1F507.2000705@redhat.com>
Date: Fri, 09 Dec 2011 09:46:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: HVR-930C DVB-T mode report
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com> <4EE08D88.2070806@redhat.com> <4EE0C312.90401@gmail.com> <4EE0D264.4090306@redhat.com> <4EE114E6.9040307@redhat.com> <CAKdnbx7mQL+D7Qas38gYR-E3nCoRVGgW-kk_cAE-kV=DYkhEYg@mail.gmail.com> <CAKdnbx6-448+3=8ONrcd0pGhbJ1P4vKZPse-RYHGnhkpHfzW8w@mail.gmail.com> <4EE1E714.5060908@redhat.com>
In-Reply-To: <4EE1E714.5060908@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-12-2011 08:46, Mauro Carvalho Chehab wrote:
> On 09-12-2011 07:35, Eddi De Pieri wrote:
>> Hi Mauro,
>>
>> drxk driver seems to have 2 issue with w_scan:
>>
>> - dvb-t tune error while scanning ("solved" by forcing w_scan to open
>> dvb-t fe without autoscan)
>> - dvb-t scan fail
>>
>> so... we should have an issue that when the driver release dvb-c
>> adapter drxk (or xc5000?) stay in dvb-c mode
>>
>> Can you check if you can replicate my error and if Terratec H5 have same issue?
>> follow the test:....
>>
>> I build w_scan 20111011 like you
>>
>> -unplug tuner
>> -replug tuner
>>
>> dmesg says:
>> [ 1030.370462] DVB: registering new adapter (em28xx #0)
>> [ 1030.370470] DVB: registering adapter 0 frontend 0 (DRXK DVB-C)...
>> [ 1030.370689] DVB: registering adapter 0 frontend 1 (DRXK DVB-T)...
>> [ 1030.371393] em28xx #0: Successfully loaded em28xx-dvb
>>
>> - w_scan -a /dev/dvb/adapter0/frontend1 (the autodetect of adapter is disabled)
>>
>> dmesg says:
>> [ 1117.000725] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
>> [ 1117.005404] xc5000: firmware read 12401 bytes.
>> [ 1117.005410] xc5000: firmware uploading...
>> [ 1117.416085] xc5000: firmware upload complete...
>>
>> However, like Fedrik, I don't get errors on dmesg but w_scan ends with
>>
>> ERROR: Sorry - i couldn't get any working frequency/transponder
>> Nothing to scan!!
>>
>> - w_scan -a /dev/dvb/adapter0/frontend1 -I it-All
>> no error on dmesg...
>>
>>
>> - w_scan -f t -c IT
>> Leaving autodetect turned on I get
>> [ 794.964818] drxk: Error -22 on QAMSetSymbolrate
>> [ 794.964827] drxk: Error -22 on SetQAM
>> [ 794.964832] drxk: Error -22 on Start
>> [ 795.164518] drxk: Error -22 on QAMSetSymbolrate
>> [ 795.164528] drxk: Error -22 on SetQAM
>> [ 795.164534] drxk: Error -22 on Start
>
> That's weird... SetQAM and QAMSetSymbolrate are only called for DVB-C.
>
>  From DRX-K driver, the only way to get EINVAL on QAMSetSymbolrate is when
> there would be a division by zero, e. g. symbol rate = 0 or frequency equal to 0.
>
> Did a quick test here with HVR-930C, using strace:
>
> open("/dev/dvb/adapter0/frontend0", O_RDWR|O_NONBLOCK) = 3
> ioctl(3, FE_GET_INFO, 0x635120) = 0
> write(2, "\t/dev/dvb/adapter0/frontend0 -> "..., 92 /dev/dvb/adapter0/frontend0 -> DVB-C "DRXK DVB-C": specified was DVB-T -> SEARCH NEXT ONE.
> ) = 92
> close(3) = 0
> open("/dev/dvb/adapter0/frontend1", O_RDWR|O_NONBLOCK) = 3
> ioctl(3, FE_GET_INFO, 0x635120) = 0
> write(2, "\t/dev/dvb/adapter0/frontend1 -> "..., 52 /dev/dvb/adapter0/frontend1 -> DVB-T "DRXK DVB-T": ) = 52
> write(2, "good :-)\n", 9good :-)
> ) = 9
> close(3) = 0
> ...
> open("/dev/dvb/adapter0/frontend1", O_RDWR) = 3
> write(2, "-_-_-_-_ Getting frontend capabi"..., 48-_-_-_-_ Getting frontend capabilities-_-_-_-_
> ) = 48
> ioctl(3, FE_GET_INFO, 0x635120) = 0
> ioctl(3, FE_GET_PROPERTY, 0x7fff81f5de70) = 0
> ...
> ioctl(3, FE_SET_PROPERTY, 0x7fff81f5de60) = 0
>
> So far so good, but then drxk tries to use DVB-C, instead of DVB-T:
> [ 717.260140] drxk: Error -22 on SetQAM
> [ 717.263858] drxk: Error -22 on Start
>
> It seems that there's a bug at the dvb-t on the current version.
>
> I'll try to fix it.

I got it. What happens is that, drx-k is changing the DVB type at the frontend
init, and not when FE_SET_PROPERTY is called. This causes issues with tools
like w_scan that opens both devices.

The enclosed patch should fix it. I can't actually test DVB-T here, but
w_scan is properly switching from/to DVB-T/DVB-C now:

$ dmesg|grep SetO|grep DVB
[ 5003.825868] drxk: SetOperationMode: DVB-C Annex C
[ 5004.944909] drxk: SetOperationMode: DVB-T
[ 5054.158016] drxk: SetOperationMode: DVB-C Annex C
[ 5073.899228] drxk: SetOperationMode: DVB-T

-

[media] drxk: Switch the delivery system on FE_SET_PROPERTY

The DRX-K doesn't change the delivery system at set_properties,
but do it at frontend init. This causes problems on programs like
w_scan that, by default, opens both frontends.

Instead, explicitly set the format when set_parameters callback is
called.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 95cbc98..c8e0921 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1847,6 +1847,7 @@ static int SetOperationMode(struct drxk_state *state,
  		*/
  	switch (oMode) {
  	case OM_DVBT:
+		dprintk(1, ": DVB-T\n");
  		state->m_OperationMode = oMode;
  		status = SetDVBTStandard(state, oMode);
  		if (status < 0)
@@ -1854,6 +1855,8 @@ static int SetOperationMode(struct drxk_state *state,
  		break;
  	case OM_QAM_ITU_A:	/* fallthrough */
  	case OM_QAM_ITU_C:
+		dprintk(1, ": DVB-C Annex %c\n",
+			(state->m_OperationMode == OM_QAM_ITU_A) ? 'A' : 'C');
  		state->m_OperationMode = oMode;
  		status = SetQAMStandard(state, oMode);
  		if (status < 0)
@@ -6183,7 +6186,10 @@ static int drxk_c_init(struct dvb_frontend *fe)
  	dprintk(1, "\n");
  	if (mutex_trylock(&state->ctlock) == 0)
  		return -EBUSY;
-	SetOperationMode(state, OM_QAM_ITU_A);
+	if (state->m_itut_annex_c)
+		SetOperationMode(state, OM_QAM_ITU_C);
+	else
+		SetOperationMode(state, OM_QAM_ITU_A);
  	return 0;
  }
  
@@ -6219,14 +6225,6 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
  		return -EINVAL;
  	}
  
-	if (state->m_OperationMode == OM_QAM_ITU_A ||
-	    state->m_OperationMode == OM_QAM_ITU_C) {
-		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-			state->m_OperationMode = OM_QAM_ITU_C;
-		else
-			state->m_OperationMode = OM_QAM_ITU_A;
-	}
-
  	if (fe->ops.i2c_gate_ctrl)
  		fe->ops.i2c_gate_ctrl(fe, 1);
  	if (fe->ops.tuner_ops.set_params)
@@ -6235,6 +6233,22 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
  		fe->ops.i2c_gate_ctrl(fe, 0);
  	state->param = *p;
  	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+
+	/*
+	 * Make sure that the frontend is on the right state
+	 */
+
+	if (fe->ops.info.type == FE_QAM) {
+		if (fe->dtv_property_cache.rolloff == ROLLOFF_13) {
+			state->m_itut_annex_c = true;
+			SetOperationMode(state, OM_QAM_ITU_C);
+		} else {
+			state->m_itut_annex_c = false;
+			SetOperationMode(state, OM_QAM_ITU_A);
+		}
+	} else
+		SetOperationMode(state, OM_DVBT);
+
  	Start(state, 0, IF);
  
  	/* printk(KERN_DEBUG "drxk: %s IF=%d done\n", __func__, IF); */
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index a05c32e..85a423f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -263,6 +263,8 @@ struct drxk_state {
  	u8     m_TSDataStrength;
  	u8     m_TSClockkStrength;
  
+	bool   m_itut_annex_c;      /* If true, uses ITU-T DVB-C Annex C, instead of Annex A */
+
  	enum DRXMPEGStrWidth_t  m_widthSTR;    /**< MPEG start width */
  	u32    m_mpegTsStaticBitrate;          /**< Maximum bitrate in b/s in case
  						    static clockrate is selected */



