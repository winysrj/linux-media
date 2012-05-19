Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc2-s11.bay0.hotmail.com ([65.54.190.86]:47708 "EHLO
	bay0-omc2-s11.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095Ab2ESQJk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 12:09:40 -0400
Message-ID: <BAY154-W31FB3194974142616B57A9C91F0@phx.gbl>
From: Per Wetterberg <dtv00pwg@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: RE: PCTV 520e - DVB-C not working
Date: Sat, 19 May 2012 18:09:40 +0200
In-Reply-To: <4FB444E2.4020908@iki.fi>
References: <BAY154-W29D14F1C862FA852849E80C92D0@phx.gbl>
 <BAY154-W22CF587B340668D556C29BC92D0@phx.gbl>
 <4FA8260A.5070601@iki.fi>,<4FB444E2.4020908@iki.fi>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> >> Hi,
> >>
> >>
> >> I have problem getting the PCTV 520e to work with DVB-C on Linux. The
> >> video output stream is full of defects.
> >> "drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params" is
> >> printed to the dmesg log when scanning and watching DVB-C channels.
> >> I have no problems scanning and watching DVB-T.
> >>
> >>
> >> On Windows 7, both DVB-T and DVB-C works fine. So I guess its not an
> >> hardware problem or the quality of the tv signal.
> >>
> >>
> >> I have tried the drivers that came with kernel 3.3.4 and the latest
> >> media drivers built from source.
> >> The dvb-demod-drxk-pctv.fw firmware file is downloaded with the
> >> get_dvb_firmware script and copied to /lib/firmware.
> >>
> >>
> >> I can't figure out what the problem is.
> >> Has anyone got PCTV 520e with DVB-C to work on Linux?
> >>
> >>
> >> I have attached some log outputs below.
> >
> > You will need attenuator. I suspect it is LNA or some AGC :/ But guess
> > what how many times I tried to found out the reason... Feel free to hack
> > DRX-K driver.
>
> Problem found. I was LNA which is always enabled. LNA is connected to
> the demod GPIO. I will disable it since it since it is now over gaining
> strong signals.

Great!
I will be happy to test the solution. Is there a patch available?
Regards,Per 		 	   		  