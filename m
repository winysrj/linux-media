Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.175])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1K7Gjc-0006n2-Og
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 23:23:01 +0200
Received: by ug-out-1314.google.com with SMTP id m3so158666uge.20
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 14:22:27 -0700 (PDT)
Message-ID: <4852E4E5.3070004@googlemail.com>
Date: Fri, 13 Jun 2008 22:21:41 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
References: <873CB0CE-12F6-4967-9E2A-697CFBAD425F@tvblob.com>
	<4852E3BE.3070106@googlemail.com>
In-Reply-To: <4852E3BE.3070106@googlemail.com>
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

Andrea wrote:
> Steven Dorigotti wrote:
>> Hello,
>>
>>
>>    If the open() mode is changed to RDWR instead of WRONLY, errno  
>> changes to "Operation not supported".
> 
> The only 2 supported modes are O_RDONLY and O_WRONLY.
> 
> in dmxdev.c around line 160.

sorry...

... unless the device has the capability DMXDEV_CAP_DUPLEX which I can't really see what it is.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
