Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1JurX9-0002eo-Mg
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 18:02:54 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1253318fga.25
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 09:02:48 -0700 (PDT)
Message-ID: <4825C724.1020001@gmail.com>
Date: Sat, 10 May 2008 18:02:44 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <482560EB.2000306@gmail.com>	<200805101717.23199@orion.escape-edv.de>
	<200805101727.55810@orion.escape-edv.de>
In-Reply-To: <200805101727.55810@orion.escape-edv.de>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021 and
 stv0297
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

Oliver Endriss schrieb:
> Argh, I just checked the API 1.0.0. spec:
> | FE READ UNCORRECTED BLOCKS
> | This ioctl call returns the number of uncorrected blocks detected by the device
> | driver during its lifetime. For meaningful measurements, the increment
> | in block count during a speci c time interval should be calculated. For this
> | command, read-only access to the device is suf cient.
> | Note that the counter will wrap to zero after its maximum count has been
> | reached
> 

First you read a very old spec, now you read an old spec. This description is no longer a 
part of the spec. In the current spec 
(http://linuxtv.org/downloads/linux-dvb-api-v4/linux-dvb-api-v4-0-3.pdf), many necessary 
descriptions are missing.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
