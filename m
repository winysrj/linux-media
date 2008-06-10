Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2506.carrierzone.com ([64.29.147.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxdreas@launchnet.com>) id 1K6BFQ-0003U2-N4
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 23:19:21 +0200
Received: from hal9001 (208-201-228-169.adsl.dynamic.launchnet.com
	[208.201.228.169] (may be forged)) (authenticated bits=0)
	by mail2506.carrierzone.com (8.13.6.20060614/8.13.1) with ESMTP id
	m5ALJA4D025419
	for <linux-dvb@linuxtv.org>; Tue, 10 Jun 2008 21:19:13 GMT
From: Andreas <linuxdreas@launchnet.com>
To: linux-dvb@linuxtv.org
Date: Tue, 10 Jun 2008 14:19:09 -0700
References: <de8cad4d0806101321x659cdec7n77714ba6e69cb563@mail.gmail.com>
	<484EE2EC.40501@linuxtv.org>
In-Reply-To: <484EE2EC.40501@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806101419.09700.linuxdreas@launchnet.com>
Subject: Re: [linux-dvb] HVR-1600 multiple cards question
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Am Dienstag, 10. Juni 2008 13:24:12 schrieb Steven Toth:
> Brandon Jenkins wrote:
> > Greetings,
> >
> > I currently have 3 HVR-1600 cards installed in my system. I am able to
> > get analog signal on all 3, but the ATSC scanning does not return any
> > data on the third card. I have swapped cables with a known working
> > card, but this does not resolve the issue.
> >
> > 2 of the cards are brand new, dmesg output seems to indicate no
> > issues. Does anyone know if there is an issue with 3 HD tuners? Is
> > there a method of trouble shooting I should follow?
>
> Remove the two working cards and test the failing card, report back.

I don't know if it would help in this case, but it is generally a good idea =

to change PCI slots as well.

-- =

Gru=DF
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
