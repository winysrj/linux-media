Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.211.177]:54088 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZHDDCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 23:02:31 -0400
Received: by ywh7 with SMTP id 7so4695275ywh.21
        for <linux-media@vger.kernel.org>; Mon, 03 Aug 2009 20:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A739DD6.8030504@iol.it>
References: <4A6F8AA5.3040900@iol.it>
	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
	 <4A7140DD.7040405@iol.it>
	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
	 <4A729117.6010001@iol.it>
	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
	 <4A739DD6.8030504@iol.it>
Date: Mon, 3 Aug 2009 23:02:31 -0400
Message-ID: <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 31, 2009 at 9:43 PM, Valerio Messina<efa@iol.it> wrote:
> Devin Heitmueller ha scritto:
>>
>> Ah, good news:  the patch I wrote that adds support for the remote
>> control is still around:
>>
>> http://linuxtv.org/hg/~dheitmueller/v4l-dvb-terratec-xs/rev/92885f66ac68
>>
>> I will prep this into a new tree and issue a pull request when I get
>> back in town on Sunday.
>
> hi,
> I tried to apply the patch, recompile, install and reboot.
> Same results, IR does not send digit to text editor or Kaffeine.
>
> What other can I do for further help/testing?
>
> Valerio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Valerio,

Please try the following:

hg clone http://kernellabs.com/hg/~dheitmueller/ttxs-remote
cd ttxs-remote
make
make install
reboot

Then see if the remote control works.  If not, I will give you some
commands to turn on the logging.  This should work though since I had
tested it myself when I had the device in question a couple of weeks
ago.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
