Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ag-out-0708.google.com ([72.14.246.251])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <miloody@gmail.com>) id 1KO2j8-0004MW-17
	for linux-dvb@linuxtv.org; Wed, 30 Jul 2008 05:51:51 +0200
Received: by ag-out-0708.google.com with SMTP id 8so180585agc.0
	for <linux-dvb@linuxtv.org>; Tue, 29 Jul 2008 20:51:46 -0700 (PDT)
Message-ID: <3a665c760807292051t3e771e33td423ca73e8dc57d9@mail.gmail.com>
Date: Wed, 30 Jul 2008 11:51:45 +0800
From: loody <miloody@gmail.com>
To: "Andrea Venturi" <a.venturi@avalpa.com>
In-Reply-To: <488F8760.4010703@avalpa.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <mailman.5.1217347135.25488.linux-dvb@linuxtv.org>
	<488F8760.4010703@avalpa.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Where I can get the open sofware to play TS file?
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

2008/7/30 Andrea Venturi <a.venturi@avalpa.com>:
> [sorry if i break the thread but i read this list in a digest form..]
>
>>
>> Subject:
>> [linux-dvb] Where I can get the open sofware to play TS file?
>> From:
>> loody <miloody@gmail.com>
>> Date:
>> Tue, 29 Jul 2008 20:38:33 +0800
>> To:
>> linux-dvb@linuxtv.org
>>
>> To:
>> linux-dvb@linuxtv.org
>>
>>
>> Dear all:
>> I study 13818-1 recently, but I cannot understand the whole flow of
>> PCR, PTS and DTS.
>>
>
> as nico already told you, this PCR is the "tick" information that sync
> remote decoders to the clock inside the source (the TS player).
if I interpret the spec wrong, please let me know.
1. From spec 2.4.2.2. It seems we have to calculate our own pcr value.
2. if above is true, equ 2-1 ~ equ 2-5 seems used to explain how
decoder get his own pcr.
3. if 2 is true, what will be our next step,when we finish get our own
pcr(i), where i is the offset respect to previous incoming pcr TS
package, PCR(i'')
I roughly draw the picture below:

PCR TS(i'') ------- video ------ audio ------ video ------ PCR TS(i')
              ^--------------------^ pass by i bytes and PCR(i) is
obtained from spec.

4. how does encoder generate pcr packages?
Does it just put the 24Mhz clock value on the TS pcr package?
if it so, why he needs to divide 300?

appreciate your kind help,
miloody

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
