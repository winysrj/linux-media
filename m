Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1KpeDL-0002sD-Mg
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 09:21:10 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1927534wfd.17
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 00:21:03 -0700 (PDT)
Message-ID: <854d46170810140021m12afb219ta6286c1109fd5bcb@mail.gmail.com>
Date: Tue, 14 Oct 2008 09:21:02 +0200
From: "Faruk A" <fa@elwak.com>
To: "Harald Becherer" <harald.becherer@gmx.de>
In-Reply-To: <20081014014428.103770@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081014014428.103770@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend TT-3650 CI
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

> I cannot go through all the repositories on http://www.linuxtv.org/hg
> Does one exist with (alpha, beta,...) TechnoTrend TT-3650 CI support?
>
> Cheers,
>
> Harald
>

Hi Harald!

You can find how to get this card working here
http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI

but it won't work with kaffeine, you need to patch kaffeine to support
multiproto or patch the drivers with old api patch
which can be found here on this list.

bye
Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
