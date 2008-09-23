Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from potassium.iops.versanet.be ([212.53.4.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Jo@requestfocus.be>) id 1Ki4wE-0000hC-SP
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 12:16:12 +0200
From: "Jo Heremans" <Jo@requestfocus.be>
To: "'Jaap Crezee'" <jaap@jcz.nl>, <linux-dvb@linuxtv.org>
References: <48D8A4FF.9010502@jcz.nl> <48D8B08B.6090602@konto.pl>
	<48D8BBED.3010109@jcz.nl>
In-Reply-To: <48D8BBED.3010109@jcz.nl>
Date: Tue, 23 Sep 2008 12:15:54 +0200
Message-ID: <000601c91d65$600989b0$201c9d10$@be>
MIME-Version: 1.0
Content-Language: nl-be
Subject: Re: [linux-dvb] TT Budget S2-3200 CI: failure with CAM module
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

>>> Again, when I remove the CAM module, everything works fine (as for 
>>> FTA channels...). Tools like dvbdate, dvbtraffic and mplayer 
>>> /dev/dvb/adapter0/dvr0 work fine.
>
>I just created a patch to add a budget-ci module param to the driver to
disable the CI interface at module load time. 
>This way I can still use the card when the CAM module is inserted.
>Maybe it is good enough to integrated it with the current hg tree?
>
>> I've got SkystarHD+CI Slot+Aston 2.18 and it works OK (for decoding 
>> some channels like HBO/MINIMINI I must wait very long time, but it 
>> works)
>
>I have waited long enough (more than 6 hours) and still no results.
>Anyone got it working with a TT S2-3200 and AstonCrypt CAM module?
>
>regards,
>
>
>Jaap Crezee

I have a TT S2-3200 working with the original tv-vlaanderen cam (same as the
canal-digital cam)
I use the liplianindvb tree

Jo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
