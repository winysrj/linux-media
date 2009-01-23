Return-path: <linux-media-owner@vger.kernel.org>
Received: from wienczny.de ([83.246.72.188]:50186 "EHLO wienczny.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZAWOkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 09:40:41 -0500
Received: from fugo.wienczny.de (ip-78-94-92-8.unitymediagroup.de [78.94.92.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by wienczny.de (Postfix) with ESMTPSA id D5E8B15EF3
	for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 15:33:28 +0100 (CET)
From: Stephan Wienczny <Stephan@wienczny.de>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Which firmware for cx23885 and xc3028?
Date: Fri, 23 Jan 2009 15:33:26 +0100
References: <1232715400.13587.12.camel@novak.chem.klte.hu>
In-Reply-To: <1232715400.13587.12.camel@novak.chem.klte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901231533.28021.Stephan@wienczny.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Try to extract the firmware using this Script:

<linux-source>/Documentation/video4linux/extract_xc3028.pl

A howto is included the header of the script.

Best regards
Stephan Wienczny

Am Freitag 23 Januar 2009 13:56:40 schrieb Levente Novák:
> I am trying to make an AverMedia AverTV Hybrid Express (A577) work under
> Linux. It seems all major chips (cx23885, xc3028 and af9013) are already
> supported, so it should be doable in principle.
>
> I am stuck a little bit since AFAIK both cx23885 and xc3028 need an
> uploadable firmware. Where should I download/extract such firmware from?
> I tried Steven Toth's repo (the Hauppauge HVR-1400 seems to be built
> around these chips as well) but even after copying the files
> under /lib/firmware it didn't really work. I tried to specify different
> cardtypes for the cx23885 module. For cardtype=2 I got a /dev/video0 and
> a /dev/video1 (the latter is of course unusable, I don't have a MPEG
> encoder chip on my card) but tuning was unsuccesful. All the other types
> I tried either didn't work at all or only resulted in dvb devices
> detected. For the moment, I am fine without DVB, and are interested
> mainly in analog devices.
>
> Maybe I should locate the windows driver of my card and extract the
> firmware files from it? If so, how do I proceed?
>
> Thanks in advance!
>
> Levente
>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

