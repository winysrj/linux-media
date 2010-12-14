Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60295 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370Ab0LNTGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 14:06:17 -0500
Date: Tue, 14 Dec 2010 20:08:17 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] [media] gspca core: Fix regressions gspca breaking
 devices with audio
Message-ID: <20101214200817.045422e7@tele>
In-Reply-To: <AANLkTim7iGe=tZXniHXG_33hCyiKFPZVuVDRLu43C3BQ@mail.gmail.com>
References: <cover.1291926689.git.mchehab@redhat.com>
	<20101209184236.53824f09@pedra>
	<20101210115124.57ccd43e@tele>
	<AANLkTim7iGe=tZXniHXG_33hCyiKFPZVuVDRLu43C3BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, 14 Dec 2010 20:52:43 +0200
Anca Emanuel <anca.emanuel@gmail.com> wrote:

> How can I disable the noise from camera ?
> There is no physical microphone in it.
> ( mute do not work )
	[snip]
> [  139.848996] usb 8-1: usb_probe_device
> [  139.849003] usb 8-1: configuration #1 chosen from 1 choice
> [  139.851825] usb 8-1: adding 8-1:1.0 (config #1, interface 0)
> [  139.851932] usb 8-1: adding 8-1:1.1 (config #1, interface 1)
> [  139.851992] usb 8-1: adding 8-1:1.2 (config #1, interface 2)
> [  139.898020] gspca: v2.11.0 registered
> [  139.904357] ov519 8-1:1.0: usb_probe_interface
> [  139.904362] ov519 8-1:1.0: usb_probe_interface - got id

This is an old version. May you get the last one from my web page?
(actual 2.11.15)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
