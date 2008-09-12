Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48CAAE6E.7060806@linuxtv.org>
Date: Fri, 12 Sep 2008 14:01:18 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Steven Toth <stoth@hauppauge.com>
References: <263027.23563.qm@web46116.mail.sp1.yahoo.com>
	<48CA6BBB.5010802@hauppauge.com>
In-Reply-To: <48CA6BBB.5010802@hauppauge.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Siano ISDB [was: Re: S2API - Status - Thu Sep 11th]
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

Steven Toth wrote:
> barry bouwsma wrote:
>> --- On Fri, 9/12/08, Steven Toth <stoth@linuxtv.org> wrote:
>>
>>  
>>> mkrufky spent some time adding S2API isdb-t support to the siano
>>> driver, that's working pretty well - tuning via the S2API app.
>>>
>>> http://linuxtv.org/hg/~mkrufky/sms1xxx-isdbt-as-dvbt/
>>>     
>>
>> Just a first quick feedback, the following will need to be
>> frobbed appropriately:
>>
>>     204         if (id < DEVICE_MODE_DVBT || id >
>> DEVICE_MODE_DVBT_BDA) {
>>     205                 sms_err("invalid firmware id specified %d", id);
>>     206                 return -EINVAL;
>>
>> In order to enable ISDB modes, one will need to specify
>> module parameter `default_mode=5' or =6, whichever, and,
>> hmmm, looks like I gotta hunt down a firmware too.
>>
>>   
> Correct, that tree expects a module option to load the firmware, you
> might want to check this code snippet in the other tree. The other
> detects the delivery system and reloads the firmware on the fly. 

Actually, I did not yet push up the auto-firmware load patch -- I saw a
bug here in my tests, so I'll push that one up after I get back and fix it.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
