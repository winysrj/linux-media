Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.ispdone.com ([69.39.47.46] helo=smtp-auth0.ispdone.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <purevw@wtxs.net>) id 1KM6Fu-0007gl-M7
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 21:13:40 +0200
Received: from [192.168.123.110] (net-69-39-58-36.texascom.net [69.39.58.36]
	(may be forged)) (authenticated bits=0)
	by smtp-auth0.ispdone.com (8.13.1/8.13.1) with ESMTP id m6P0Cwwi018870
	for <linux-dvb@linuxtv.org>; Thu, 24 Jul 2008 19:12:59 -0500
From: Ronnie Bailey <purevw@wtxs.net>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 14:12:58 -0500
Message-Id: <1216926778.7984.2.camel@Opto.Bailey>
Mime-Version: 1.0
Subject: [linux-dvb] Problem with newest download?
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

Hi all,
   I tried to install the newest v4l-dvb this morning and I come up with
an error during "make". I was just curious if there is a problem with
the downloaded files. Here is an excerpt of the output that shows the
errors:


> /v4l-dvb/v4l/cpia2_core.c:36:24: error: token "=" is not valid in preprocessor expressions
> /v4l-dvb/v4l/cpia2_core.c:901:24: error: token "=" is not valid in preprocessor expressions
> /v4l-dvb/v4l/cpia2_core.c:924:24: error: token "=" is not valid in preprocessor expressions
> /v4l-dvb/v4l/cpia2_core.c:958:24: error: token "=" is not valid in preprocessor expressions
> make[5]: *** [/v4l-dvb/v4l/cpia2_core.o] Error 1
> make[4]: *** [_module_/v4l-dvb/v4l] Error 2
> make[3]: *** [sub-make] Error 2
> make[2]: *** [all] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.25.11-0.1-obj/x86_64/default'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/v4l-dvb/v4l'
> make: *** [all] Error 2

Thanks,
Ronnie Bailey


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
