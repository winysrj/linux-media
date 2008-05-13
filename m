Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [203.200.233.138] (helo=nkindia.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gurumurti@nkindia.com>) id 1Jvu4D-0006Ok-FN
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 14:57:18 +0200
Received: from nkindia.com (localhost.localdomain [127.0.0.1])
	by nkindia.com (8.13.7/8.13.7) with ESMTP id m4DDEKOD021992
	for <linux-dvb@linuxtv.org>; Tue, 13 May 2008 18:44:20 +0530
Message-ID: <48030.203.200.233.131.1210684460.squirrel@203.200.233.138>
Date: Tue, 13 May 2008 18:44:20 +0530 (IST)
From: "Gurumurti Laxman Maharana" <gurumurti@nkindia.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] [Fwd: inserting user PIDs in TS]
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




Hi all
I would like to know that can we insert user defined PIDs into the TS
stream. how should i go about? What standard should i follow? How should I
format the the packets ( segment - section etc...).
can any body help in this regard.
Thanks with regards.
guru


> 2008/5/12 Gurumurti Laxman Maharana <gurumurti@nkindia.com>:
>>  I am looking for information EPG format. Can any body guide me in this
>>  regard. How EPGs are formated and streamed along with the programs.
>>  Thanks with regards.
>
> Electronic Programme Guide is an application, so you can implement it
> on your own.
>
> If you want to read about Service Information (SI) in DVB (data you
> see in EPG comes from SI) start with  ETSI EN 300 468[1] and Event
> Information Table (EIT) section. All DVB specifications are available
> from dvb.org[2].
>
> [1] I'm not sure if they like deep links, but just put spec name to
> Google to get URL to PDF
> [2] http://www.dvb.org/technology/standards/
>
> --
> Krzysztof Burghardt <krzysztof@burghardt.pl>
> http://www.burghardt.pl/
>


-- 
guru



-- 
GURUMURTI


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
