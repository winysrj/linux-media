Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1L7apc-0002wG-Vn
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 20:22:49 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2195320fga.25
	for <linux-dvb@linuxtv.org>; Tue, 02 Dec 2008 11:22:45 -0800 (PST)
Message-ID: <49358B01.2010701@googlemail.com>
Date: Tue, 02 Dec 2008 20:22:41 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <492168D8.4050900@googlemail.com>
	<19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
In-Reply-To: <19a3b7a80812020834t265f2cc0vcf485b05b23b6724@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH]Fix a bug in scan,
 which outputs the wrong frequency if the current tuned transponder
 is scanned only
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

Christoph Pfister schrieb:
> 2008/11/17 e9hack <e9hack@googlemail.com>:
>> Hi,
>>
>> if the current tuned transponder is scanned only and the output needs the frequency of the
>> transponder, it is used the last frequency, which is found during the NIT scanning. This
>> is wrong. The attached patch will fix this problem.
> 
> Any opinion about this patch? It seems ok from a quick look, so I'll
> apply it soon if nobody objects.

After some more investigation, my patch has some problems:

1)Usually the patch is only necessary for transponders, which transmits NIT data of other
transponders (DVB-C only?).

2)It will not work with DVB-S. On DVB-S the returned frequency from frontend is the
LNB-IF. It must be convert to the transponder frequency depend on the LNB configuration.
Scan can't read the LNB configuration from frontend. It must trust the given parameters.

3)On DVB-S, the reported frequency from frontend contains the offset from zigzag scan. If
the offset is greater than 2kHz, scan can't find the correct frequency within the NIT data.

3)The reported frequency from many frontends contains a measured offset. If the offset is
  greater than 2kHz, see above.

Depend on this 4 points, scan should not report any transponder infos, if the current
transponder is scanned only (scan does not tune itself) and if the output format must
contain the frequency of the transponder.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
