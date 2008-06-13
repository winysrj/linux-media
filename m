Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1K7GeQ-0005g0-E6
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 23:17:39 +0200
Received: by wr-out-0506.google.com with SMTP id 50so2432563wra.13
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 14:17:33 -0700 (PDT)
Message-ID: <4852E3BE.3070106@googlemail.com>
Date: Fri, 13 Jun 2008 22:16:46 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: Steven Dorigotti <steven.dorigotti@tvblob.com>
References: <873CB0CE-12F6-4967-9E2A-697CFBAD425F@tvblob.com>
In-Reply-To: <873CB0CE-12F6-4967-9E2A-697CFBAD425F@tvblob.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] opening dvr for writing
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

Steven Dorigotti wrote:
> Hello,
> 
> 
>    If the open() mode is changed to RDWR instead of WRONLY, errno  
> changes to "Operation not supported".

The only 2 supported modes are O_RDONLY and O_WRONLY.

in dmxdev.c around line 160.

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
