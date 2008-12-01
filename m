Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1L76w9-0002p5-LY
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 12:27:34 +0100
Date: Mon, 1 Dec 2008 12:26:55 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: =?ISO-8859-15?Q?Antti_Sepp=E4l=E4?= <a.seppala+linux-dvb@gmail.com>
In-Reply-To: <492D96AB.9020009@gmail.com>
Message-ID: <alpine.LRH.1.10.0812011226160.19122@pub1.ifh.de>
References: <492D96AB.9020009@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="579714831-1788931758-1228130815=:19122"
Cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Cablestar 2 i2c retries
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579714831-1788931758-1228130815=:19122
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by znsun1.ifh.de id mB1BQtTN020869

Hi Antti,

On Wed, 26 Nov 2008, Antti Sepp=E4l=E4 wrote:
> The reason is that the earlier version of the driver used to retry=20
> unsuccessful i2c operations. The demodulator of Cablestar 2 cards=20
> (stv0297) seems to be very dependent on these retries and adding them=20
> back fixes Cablestar detection.

Thanks a lot for your fix.

It is committed and asked to be pulled.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
--579714831-1788931758-1228130815=:19122
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--579714831-1788931758-1228130815=:19122--
