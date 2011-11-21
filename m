Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55829 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KUV2p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:28:45 -0500
Received: by wwe3 with SMTP id 3so6165467wwe.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:28:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbyPPJe_ONV5bOXx_r+cwNd43eyThyRrawA0Gi1JydQV=Q@mail.gmail.com>
References: <CAHFNz9+e0K__EWdc=ckHURjjYMbez22=xup0d7=H7k2xQNVnyw@mail.gmail.com>
	<CAOcJUbyPPJe_ONV5bOXx_r+cwNd43eyThyRrawA0Gi1JydQV=Q@mail.gmail.com>
Date: Tue, 22 Nov 2011 02:58:44 +0530
Message-ID: <CAHFNz9Lt11cy9kJtAaVWDRs5tQ938caupB-Tm0Ju6woBF3USUg@mail.gmail.com>
Subject: Re: PATCH 04/13: 0004-TDA18271-Allow-frontend-to-set-DELSYS
From: Manu Abraham <abraham.manu@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/22/11, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Thank you, Manu... After the Linux Kernel Summit in Prague, I had
> intentions of solving this exact problem, but you did it first -- good
> job!
>
> I have reviewed the patch to the tda18271 driver, and the changes make
> good sense to me.  I have one question, however:
>
> Perhaps my eyes have overlooked something -- I fail to see any code
> that defines the new "set_state" callback or any code that calls this
> new callback within dvb-core (assuming dvb_frontend.c)  I also can't
> find the structure declaration of the "tuner_state" struct... ... is
> this patch missing from your series, or did I just overlook it?

I guess more like that. The data structure existed for quite a long
while in dvb_frontend.h and hence you don't find any new changes. Only
delivery and modulation added to it.

>
> That missing patch is what interests me most.  Once I can see that
> missing code, I'd like to begin discussion on whether we actually need
> the additional callback, or if it can simply be handled by the
> set_params call.  Likewise, I'm not exactly sure why we need this
> affional "struct tuner_state" ...  Perhaps the answer will be
> self-explanatory once I see the code - maybe no discussion is
> necessary :-P
>
> But this does look good to me so far.  I'd be happy to provide my
> "reviewed-by" tag once I can see the missing code mentioned above.

The callback is used from within a demodulator context as usual and hence.
eg:

 	/* program tuner */
-	if (fe->ops.tuner_ops.set_params)
-		fe->ops.tuner_ops.set_params(fe, params);
+	tstate.delsys = SYS_DVBC_ANNEX_AC;
+	tstate.frequency = c->frequency;
+
+	if (fe->ops.tuner_ops.set_state) {
+		fe->ops.tuner_ops.set_state(fe,
+					    DVBFE_TUNER_DELSYS    |
+					    DVBFE_TUNER_FREQUENCY,
+					    &tstate);
+	} else {
+		if (fe->ops.tuner_ops.set_params)
+			fe->ops.tuner_ops.set_params(fe, params);
+	}


Best Regards,
Manu
