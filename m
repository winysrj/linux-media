Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.krastelcom.ru ([88.151.248.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpr@krastelcom.ru>) id 1K4Bxq-0006Gd-8j
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 11:40:59 +0200
Message-Id: <22F7D555-1DAA-4B47-8BFB-BB6E5B167C62@krastelcom.ru>
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: Gregor Fuis <gujs.lists@gmail.com>
In-Reply-To: <4847B3F0.1030501@gmail.com>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Thu, 5 Jun 2008 13:40:54 +0400
References: <4847B3F0.1030501@gmail.com>
Cc: Mailing list for VLC media player developers <vlc-devel@videolan.org>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] multiproto and vlc
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

That's because vlc is relocking every 10 secs.

Regards,
Vladimir

On Jun 5, 2008, at 1:37 PM, Gregor Fuis wrote:

> Hello
>
> I am using the latest multiproto from Manu's repository with KNC1  
> DVB-S2
> card. I patched drivers with multiproto-support-old-api.dif patch  
> which
> enables drivers for older DVB api. When I watch programs with vlc i  
> get
> a lot of discontinuity error. I was measuring how frequently they are
> appearing and came to an interesting finding. It looks like they are
> appearing in every 10 seconds (+- 1 second).
>
> But if I use szap to select channel and then open dvr0, the stream is
> working great and without any errors.
>
> szap and vlc are both compiled for old api. VLC is version 0.8.6h on
> Ubuntu 8.04 compiled by me. If I use latest hg drivers with KNC1 DVB-S
> card vlc is working without problems.
>
> Can somebody help me find where the problem could be in vlc or
> multiproto drivers when vlc is accessing dvb card directly. Is there  
> any
> event in drivers or VLC which is occurring every 10 seconds, that it
> could have some effect on card. Probably it should be something in the
> drivers, because VLC is working great with hg drivers and dvb-s card.
>
> Thanks!
>
> Best Regards,
> Gregor
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
