Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47766 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3AaU33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 15:29:29 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so2305231wgb.25
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 12:29:28 -0800 (PST)
Message-ID: <1359664162.1976.13.camel@router7789>
Subject: Re: af9035 test needed!
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andre Heider <a.heider@gmail.com>,
	Jose Alberto Reguero <jareguero@telefonica.net>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Date: Thu, 31 Jan 2013 20:29:22 +0000
In-Reply-To: <510A78D8.7030602@iki.fi>
References: <50F05C09.3010104@iki.fi>
	 <CAHsu+b8UAh5VD_V4Ub6g7z_5LC=NH1zuY77Yv5nBefnrEwUHMw@mail.gmail.com>
	 <510A78D8.7030602@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-01-31 at 15:59 +0200, Antti Palosaari wrote:
> On 01/31/2013 03:04 PM, Andre Heider wrote:
> > Hi,
> >
> > On Fri, Jan 11, 2013 at 7:38 PM, Antti Palosaari <crope@iki.fi> wrote:
> >> Could you test that (tda18218 & mxl5007t):
> >> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_tuner
> >
> > I got a 'TerraTec Cinergy T Stick Dual RC (rev. 2)', which is fixed by
> > this series.
> > Any chance to get this into 3.9 (I guess its too late for the USB
> > VID/PID 'fix' for 3.8)?
> 
> Thank you for the report! There was someone else who reported it working 
> too. Do you want to your name as tester for the changelog?
> 
> I just yesterday got that TerraTec device too and I am going to add dual 
> tuner support. Also, for some reason IT9135 v2 devices are not working - 
> only v1. That is one thing I should fix before merge that stuff.
Hi Antti,

I am going to acknowledge this development, so you are free to copy
any code from the it913x and it913x-fe driver to get this working.

My time is very limited at the moment, so I will try to do testing when
possible.

Once everything is stable enough the dvb-usb-it913x and it913x-fe
modules can be removed.

Acked-by: Malcolm Priestley <tvboxspy@gmail.com>

Regards


Malcolm

