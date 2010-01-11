Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <Andre.Weidemann@web.de>) id 1NUGhj-0002R0-6U
	for linux-dvb@linuxtv.org; Mon, 11 Jan 2010 10:36:55 +0100
Received: from fmmailgate02.web.de ([217.72.192.227])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NUGhi-0000Ew-Pt; Mon, 11 Jan 2010 10:36:54 +0100
Message-ID: <4B4AEBF2.4040102@web.de>
Date: Mon, 11 Jan 2010 10:14:26 +0100
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20bec30b1001101748i681c2d60ib26253112915306d@mail.gmail.com>
In-Reply-To: <20bec30b1001101748i681c2d60ib26253112915306d@mail.gmail.com>
Subject: Re: [linux-dvb] help!
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
On 11.01.2010 02:48, huimei deng wrote:

> I am making the stv0903(support DVB-S/S2) driver.


Such a driver already exists. It is the stv090x driver, which covers =

both, the stv0900 and the stv0903 driver.

> I would like to to get some help what is wrong.
> Or any experience on this is welcome.


The driver is already contained in the 2.6.31 kernel series.
An up-to-date version can be found here:

http://jusst.de/hg/stv090x/

Regards,
  Andr=E9

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
