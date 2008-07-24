Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1KM6iy-0001Lj-OJ
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 21:43:42 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1776044fga.25
	for <linux-dvb@linuxtv.org>; Thu, 24 Jul 2008 12:43:37 -0700 (PDT)
Message-ID: <4888DB67.6060103@gmail.com>
Date: Thu, 24 Jul 2008 21:43:35 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1216926778.7984.2.camel@Opto.Bailey>
In-Reply-To: <1216926778.7984.2.camel@Opto.Bailey>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] Problem with newest download?
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

Ronnie Bailey schrieb:
> Hi all,
>    I tried to install the newest v4l-dvb this morning and I come up with
> an error during "make". I was just curious if there is a problem with
> the downloaded files.

Search for '#if LINUX_VERSION_CODE => KERNEL_VERSION(2,6,27)' and replace it with '#if 
LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)'. '=>' is a typo.

-Hartmut


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
