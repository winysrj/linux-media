Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx19.lb01.inode.at ([62.99.145.21] helo=mx.inode.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e.peinlich@inode.at>) id 1JXFrV-0007xK-Sv
	for linux-dvb@linuxtv.org; Thu, 06 Mar 2008 14:10:20 +0100
Received: from [85.124.58.196] (port=7036 helo=[10.0.2.30])
	by smartmx-19.inode.at with esmtpa (Exim 4.50) id 1JXFqw-0002BW-Ar
	for linux-dvb@linuxtv.org; Thu, 06 Mar 2008 14:09:42 +0100
Message-ID: <47CFED19.7080404@inode.at>
Date: Thu, 06 Mar 2008 14:09:45 +0100
From: Ernst Peinlich <e.peinlich@inode.at>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200801252245.58642.dkuhlen@gmx.net> <47C3D206.9020507@web.de>
In-Reply-To: <47C3D206.9020507@web.de>
Subject: Re: [linux-dvb] TT Connect S2-3600
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

Andr=E9 Weidemann schrieb:
> Dominik Kuhlen wrote:
>> Hi all,
>>
>> Manus multiproto HG tree (jusst.de/hg/multiproto) and the attached =

>> patch make the pctv452e work with DVB-S2 and DVB-S :)
>
> Hi all,
> I took Dominiks patch and added support for the TT connect S2-3600.
>
> The S2-3600 is tuning to DVB-S and DVB-S2 but I still got some image =

> distortions. I'm quite sure I got the correct firmware for the S2-3600 =

> but I only did some quick testing last night.
> The patch may still have some quirks... so use at your own risk.
>
> If anyone should volunteer to try the attached patch, please make sure =

> to apply the patch for the PCTV 452e first!
> The firmware for the S2-3600 can be found here:
> http://ilpss8.dyndns.org/dvb-usb-tt-connect-s2-3600-01.fw
>
> I will also have a PCTV 452e for testing at the end of the week. So I =

> can test both USB boxes with the driver.
>
>  Andr=E9
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
Hi

I have the same problems, but only on DVBS on DVBS2 its works ok.

ernst

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
