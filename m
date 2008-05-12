Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <krzysztof.burghardt@gmail.com>) id 1JvW8F-0006lN-Qf
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 13:23:53 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1883405fka.1
	for <linux-dvb@linuxtv.org>; Mon, 12 May 2008 04:23:48 -0700 (PDT)
Message-ID: <80bd11420805120423x3e715fcneb2ced033aeaada7@mail.gmail.com>
Date: Mon, 12 May 2008 13:23:47 +0200
From: "Krzysztof Burghardt" <krzysztof@burghardt.pl>
To: "Gurumurti Laxman Maharana" <gurumurti@nkindia.com>
In-Reply-To: <63380.123.201.45.12.1210590505.squirrel@203.200.233.138>
MIME-Version: 1.0
Content-Disposition: inline
References: <63380.123.201.45.12.1210590505.squirrel@203.200.233.138>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [Fwd: EPG format]
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

2008/5/12 Gurumurti Laxman Maharana <gurumurti@nkindia.com>:
>  I am looking for information EPG format. Can any body guide me in this
>  regard. How EPGs are formated and streamed along with the programs.
>  Thanks with regards.

Electronic Programme Guide is an application, so you can implement it
on your own.

If you want to read about Service Information (SI) in DVB (data you
see in EPG comes from SI) start with  ETSI EN 300 468[1] and Event
Information Table (EIT) section. All DVB specifications are available
from dvb.org[2].

[1] I'm not sure if they like deep links, but just put spec name to
Google to get URL to PDF
[2] http://www.dvb.org/technology/standards/

-- 
Krzysztof Burghardt <krzysztof@burghardt.pl>
http://www.burghardt.pl/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
