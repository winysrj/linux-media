Return-path: <mchehab@gaivota>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33210 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1ELDsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 23:48:23 -0400
Subject: Re: IR remote control autorepeat / evdev
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4DCB39AF.2000807@redhat.com>
Date: Wed, 11 May 2011 23:48:19 -0400
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Content-Transfer-Encoding: 7bit
Message-Id: <7E0935B5-0C85-439A-AB55-172FD4230730@wilsonet.com>
References: <4DC61E28.4090301@iki.fi> <20110510041107.GA32552@barra.redhat.com> <4DC8C9B6.5000501@iki.fi> <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <4DCB213A.8040306@redhat.com> <4DCB2BD9.6090105@iki.fi> <4DCB336B.2090303@redhat.com> <4DCB39AF.2000807@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On May 11, 2011, at 9:36 PM, Mauro Carvalho Chehab wrote:

> Em 12-05-2011 03:10, Mauro Carvalho Chehab escreveu:
>> Em 12-05-2011 02:37, Anssi Hannula escreveu:
> 
>>> I don't see any other places:
>>> $ git grep 'REP_PERIOD' .
>>> dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
>>> d->props.rc.legacy.rc_interval;
>> 
>> Indeed, the REP_PERIOD is not adjusted on other drivers. I agree that we
>> should change it to something like 125ms, for example, as 33ms is too 
>> short, as it takes up to 114ms for a repeat event to arrive.
>> 
> IMO, the enclosed patch should do a better job with repeat events, without
> needing to change rc-core/input/event logic.
> 
> -
> 
> Subject: Use a more consistent value for RC repeat period
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> The default REP_PERIOD is 33 ms. This doesn't make sense for IR's,
> as, in general, an IR repeat scancode is provided at every 110/115ms,
> depending on the RC protocol. So, increase its default, to do a
> better job avoiding ghost repeat events.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Yeah, I definitely like this change, and I think it should do some
good. I've been pointing a number of people at ir-keytable and its
ability to tweak these values from userspace. Most people have been
bumping REP_PERIOD up a bit, but also REP_DELAY down a bit, so that
repeats actually kick in a bit sooner. I'm fine with leaving 500 as
the default there though, and letting individual drivers adjust it
if they really want.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com



