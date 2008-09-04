Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <burns.me.uk@googlemail.com>) id 1KbAo4-0005NP-TW
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 11:07:14 +0200
Received: by yw-out-2324.google.com with SMTP id 3so303441ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 04 Sep 2008 02:07:08 -0700 (PDT)
Message-ID: <b4057d410809040207n685bb5eejb20d6ace653a2798@mail.gmail.com>
Date: Thu, 4 Sep 2008 10:07:08 +0100
From: "Andy Burns" <linuxtv.lists@burns.me.uk>
To: linux-dvb@linuxtv.org
In-Reply-To: <141058d50809032204o7b8a70d9jc3fa64b4e2f9ef3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <141058d50809030655i680f7937o3aa657601d1910a0@mail.gmail.com>
	<48BE98CC.1080600@linuxtv.org>
	<141058d50809032204o7b8a70d9jc3fa64b4e2f9ef3@mail.gmail.com>
Subject: Re: [linux-dvb] Fine tuning app ?
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

2008/9/4 Glenn McGrath <glenn.l.mcgrath@gmail.com>:

> I did a lot of digging and found i need to check somewhere within
> 125kHz of the center frequency (usually center +125kHz is best), if i
> just check the center frequency my tv card doesnt even get a lock.

Don't know if it's relevant or useful, but in the UK each MUX is
transmitted with a channel offset of either -167kHz, zero, or +167kHz,
to avoid "overspill" to adjacent analogue channels (though I believe
they will persist after DSO) the details are available per transmitter
from the OFCOM site, e.g. Crystal Palace

http://www.ofcom.org.uk/static/reception_advice/digital_trans_guide/show_transmitter.asp-siteID=66.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
