Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <489AA9AF.2060803@iinet.net.au>
Date: Thu, 07 Aug 2008 15:52:15 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: David <dvb-t@iinet.com.au>
References: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com><4897AC24.3040006@linuxtv.org>	<20080805214339.GA7314@kryten><20080805234129.GD11008@brainz.yelavich.home>	<4899020C.50000@linuxtv.org>	<41A3723BDBA947399F2CBD960E4AFB94@mce>	<48996623.4010703@iinet.net.au>	<0BBC9497950E4ECA878D1D018B090B61@mce>	<489A7B4A.4080206@iinet.net.au>
	<C5551D141EAB485E8EB2F1D8E43B6676@mce>
	<489A9D74.5090501@iinet.net.au>
	<42DDE4283DB94F2580D473D5B1954CB5@mce>
In-Reply-To: <42DDE4283DB94F2580D473D5B1954CB5@mce>
Cc: patrick.claven@manildra.com.au, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
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


The point is that the developers are trying to incorporate Chris's work 
into the
main v4l-dvb driver.

Chris's original firmware requirements were:
dvb-usb-bluebird-01.fw xc3028-dvico-au-01.fw dvb-usb-bluebird-02.fw

whereas now it needs:
xc3028-v27.fw

It seems that the "new" firmware doesn't work as of yet for Australia, 
for this device.

IIRC, Chris had an "offset" for Australia.

Regards,
Timf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
