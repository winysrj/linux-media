Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from firefly.xen.no ([193.71.199.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tlan@firefly.xen.no>) id 1K0PBv-0005FZ-5U
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 00:59:52 +0200
Date: Mon, 26 May 2008 00:59:47 +0200
From: Thomas =?iso-8859-1?Q?Lang=E5s?= <thomas@langaas.org>
To: Thomas =?iso-8859-1?Q?Lang=E5s?= <thomas@langaas.org>
Message-ID: <20080525225947.GA10411@firefly.xen.no>
References: <20080525133454.GA30316@firefly.xen.no>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080525133454.GA30316@firefly.xen.no>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Drivers for Technotrend CT-3650 CI (USB 2.0-device)
Reply-To: thomas@langaas.org
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

Thomas Lang=E5s:
> I just got this device, and I see there's a driver called ttusb2 that
> seems to be what I need (with some modifications, I suspect). =


This seems to be the "contents" of the USB-device:
* TDA8274AHN (silicon ic tuner)
* TDA10023HT (DVB-C)
* TDA10048HN (DVB-T)

There's also a Cypress-device (which I guess is the usb-controller), but
I forgot to take a note of the specific version when I was checking out
the insides of my box :|

-- =

Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
