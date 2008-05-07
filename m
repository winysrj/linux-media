Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JtmiP-00075o-HU
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 18:42:16 +0200
Received: by fg-out-1718.google.com with SMTP id e21so266669fga.25
	for <linux-dvb@linuxtv.org>; Wed, 07 May 2008 09:40:02 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
Date: Wed, 7 May 2008 18:39:59 +0200
References: <481EBD4D.1070905@chaosmedia.org>
	<200805051300.09840.christophpfister@gmail.com>
	<481EF3C5.3060308@chaosmedia.org>
In-Reply-To: <481EF3C5.3060308@chaosmedia.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805071839.59714.christophpfister@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] libdvbapi multiproto patch ?
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

Am Montag 05 Mai 2008 13:47:17 schrieb ChaosMedia > WebDev:
> Christoph Pfister wrote:
> > No. Only libdvben50221 + the ca part of libdvbapi are used.
>
> okay thx, what's libdvben50221 compared to libdvbapi ? Are those two
> libs only used for CAM purposes ?

Yes, those are for cam stuff.

> Anyways, i've checked DvbStream::tuneDvb and seen it uses the frontend
> declarations directly.
> Good thing if i don't have to mess with a lib in the middle..
>
> I'll see if i can manage to use some fancy macros and keep ifdef out of
> the main code.
>
> thx
> Marc

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
