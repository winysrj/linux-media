Return-path: <mchehab@pedra>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:58047 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab1FLWSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 18:18:16 -0400
Date: Mon, 13 Jun 2011 00:15:00 +0200 (CEST)
From: Juergen Lock <nox@jelal.kn-bremen.de>
Message-Id: <201106122215.p5CMF0Xr069931@triton8.kn-bremen.de>
To: crope@iki.fi
Subject: Re: [PATCH] [media] af9015: setup rc keytable for LC-Power LC-USB-DVBT
In-Reply-To: <4DF52828.2070701@iki.fi>
References: <20110612202512.GA63911@triton8.kn-bremen.de>
Cc: linux-media@vger.kernel.org, hselasky@c2i.net
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In article <4DF52828.2070701@iki.fi> you write:
>I assume device uses vendor reference design USB ID (15a4:9016 or 
>15a4:9015)?
>
Yeah 15a4:9016.

>About the repeating bug you mention, are you using latest driver 
>version? I am not aware such bug. There have been this kind of incorrect 
>behaviour old driver versions which are using HID. It was coming from 
>wrong HID interval.
>
>Also you can dump remote codes out when setting debug=2 to 
>dvb_usb_af9015 module.

 That doesn't seem to work here so maybe my version is really too old
to have that fix.  (But the keytable patch should still apply I guess?)

 Thanx, :)
	Juergen
