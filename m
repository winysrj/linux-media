Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1K258o-00021J-NG
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 15:59:35 +0200
Received: by fg-out-1718.google.com with SMTP id e21so146795fga.25
	for <linux-dvb@linuxtv.org>; Fri, 30 May 2008 06:59:30 -0700 (PDT)
Message-ID: <48400833.60909@gmail.com>
Date: Fri, 30 May 2008 15:59:15 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1212079844.26238.22.camel@rommel.snap.tv>
	<483EED5A.7080200@iki.fi>
In-Reply-To: <483EED5A.7080200@iki.fi>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] Oops in tda10023
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

Antti Palosaari schrieb:
> Sigmund Augdal wrote:
>> using latest hg v4l-dvb on a 2.6.20 kernel.
> 
> I did some changes recently to tda10023 (needed for Anysee driver). I 
> wonder if these errors start coming after that? Those changes are 
> committed to master only few days ago, 05/26/2008.

I think the oops occurs, because tda10023_writereg() fails in tda10023_attach(). If 
tda10023_writereg fails, an error message is printed. In this case, 
state->frontend.dvb->num is accessed, but it isn't initialized yet.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
