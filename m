Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:23317 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935858Ab0BZMqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 07:46:45 -0500
Received: by qw-out-2122.google.com with SMTP id 8so5215qwh.37
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 04:46:44 -0800 (PST)
Message-ID: <4B87C2A6.1060304@gmail.com>
Date: Fri, 26 Feb 2010 09:46:30 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Mark Purcell <msp@debian.org>
CC: Raphael Hertzog <hertzog@debian.org>,
	Brian Keck <bwkeck@gmail.com>, Simon Kenyon <simon@koala.ie>,
	owner@packages.qa.debian.org, linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org, tschmidt@debian.org,
	etobi@debian.org, steph@glondu.net
Subject: Re: You are now subscribed to linuxtv-dvb-apps
References: <E1NkarL-0004ys-VI@master.debian.org> <20100225115441.1F6482B03E@narya.x> <20100226070253.GC29018@rivendell> <201002261905.08140.msp@debian.org>
In-Reply-To: <201002261905.08140.msp@debian.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark Purcell wrote:
> On Friday 26 February 2010 18:02:53 Raphael Hertzog wrote:
>> I was expecting somehow that either the Debian maintainer or the upstream
>> maintainer of linuxtv-dvb-apps thought that it was a good idea to receive
>> Debian BTS mails on his mailing list.
> 
> Debian Maintainer (me), thinking it is good for upstream to receive user updates of frequencies of their local TV stations which we are receiving in the BTS.

Mark,

While receiving dvb-apps updates on upstream is a good idea, I don't think that
subscribing one list to the other is the proper way for it. If we use that logic,
we would need to subscribe all kernel ML's (LMML, acpi, alsa, ...) at LKML.
This would just add more traffic, mixing different subjects.

As you'll be receiving those requests and patches, the better is for you to
forward us the patches you receive and send us upstream patches based on
the reports you're receive, keeping your package in sync with upstream, while
saving us for any internal discussions that it may be pertinent only to the
Debian ML.

-- 

Cheers,
Mauro
