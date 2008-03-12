Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from s3.cableone.net ([24.116.0.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vanessaezekowitz@gmail.com>) id 1JZIpk-00076m-OF
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 05:44:57 +0100
Received: from [72.24.208.253] (unverified [72.24.208.253])
	by S3.cableone.net (CableOne SMTP Service S3) with ESMTP id
	148185814-1872270
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 21:44:19 -0700
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: linux-dvb@linuxtv.org
Date: Tue, 11 Mar 2008 23:42:26 -0500
References: <6c5f4a970803112050rd276f77ud4da4c3b9e6cf1f5@mail.gmail.com>
In-Reply-To: <6c5f4a970803112050rd276f77ud4da4c3b9e6cf1f5@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803112342.27292.vanessaezekowitz@gmail.com>
Subject: Re: [linux-dvb] KWorld ATSC 120 - Ubuntu DVB drivers?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tuesday 11 March 2008 10:50:43 pm TaRDy eyedontcheat wrote:

> I asked on IRC about the KWorld ATSC 120 tuner and was told it isn't
> supported currently however it could be made to work.  I was also informed
> that all the pre-requisites are finally there, and all that is needed is
> glue code.

This card is not yet supported, but the individual chips on it do have driver code.  Mauro is working on the driver while I do the testing, since I also have one of these cards.

Right now though, the composite and S-video inputs work fine in the mainstream kernel (2.6.24 and up).  I believe recent additions to the v4l-dvb repository have already incorporated the code changes that make the FM radio work, also.

The TV tuner code isn't ready, but its close.  Specifically, the analog TV side is already partially working (we've got reliable video, just no audio yet), and the ATSC/digital tuner *wants* to work, but something is tripping us up.  I have a feeling that it'll be working fairly soon.

SO if you can justify getting the card before the driver is ready, please do so - more testers are always appreciated.

-- 
"Life is full of happy and sad events.  If you take the time
to concentrate on the former, you'll get further in life."
Vanessa Ezekowitz  <vanessaezekowitz@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
