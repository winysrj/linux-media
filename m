Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33919 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1FVGOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 02:14:06 -0400
Received: by fxm17 with SMTP id 17so409867fxm.19
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 23:14:04 -0700 (PDT)
Date: Wed, 22 Jun 2011 08:13:59 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	Jarod Wilson <jarod@wilsonet.com>
Cc: Antti Palosaari <crope@iki.fi>, stybla@turnovfree.net,
	Sascha =?ISO-8859-1?B?V/xzdGVtYW5u?= <sascha@killerhippy.de>,
	linux-media@vger.kernel.org,
	Thomas Holzeisen <thomas@holzeisen.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: RTL2831U driver updates
Message-ID: <20110622081359.6d55979a@grobi>
In-Reply-To: <4E017EE7.9040902@hoogenraad.net>
References: <4DF9BCAA.3030301@holzeisen.de>
	<4DF9EA62.2040008@killerhippy.de>
	<4DFA7748.6000704@hoogenraad.net>
	<4DFFC82B.10402@iki.fi>
	<4E002EBD.6050800@hoogenraad.net>
	<BANLkTim76FRL+ZNapHyjgFyOvuMXxGVzJQ@mail.gmail.com>
	<4E017EE7.9040902@hoogenraad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 22 Jun 2011 07:34:31 +0200
Jan Hoogenraad <jan-conceptronic@hoogenraad.net> wrote:

> Thanks. Do you know more about this subject ?
> 
> We do have specs about the chipset, but
> 
> http://linuxtv.org/downloads/v4l-dvb-apis/remote_controllers.html#Remote_controllers_Intro
> 
> only mentions lirc, not rc-core.
> This is about where my knowledge stops, however.
> 
> rc-core is only mentioned shortly in:
> http://linuxtv.org/wiki/index.php/Remote_Controllers

I think/hope Jarod can comment on this - i just know that new remotes
should use rc-core, as this is the "new thing" for this. I'm no
developer whatsoever :)

> 
> Steffen Barszus wrote:
> > 2011/6/21 Jan Hoogenraad<jan-conceptronic@hoogenraad.net>:
> >> and add the IR remote interface, based
> >> on the LIRC framework.
> >> It actually should yield little code, and mainly requires a)
> >> understanding of LIRC and b) comparing code tables to that the
> >> in-kernel code tables can be re-used.
> >
> >
> > sorry for the noise , but i guess you mean rc-core not Lirc
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 

