Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1KTwXL-0002Il-3K
	for linux-dvb@linuxtv.org; Fri, 15 Aug 2008 12:28:06 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1243571nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 15 Aug 2008 03:27:59 -0700 (PDT)
Message-ID: <de8cad4d0808150327r2d4fc067t54a87c9a4bba1bc@mail.gmail.com>
Date: Fri, 15 Aug 2008 06:27:59 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <de8cad4d0808141950p6eedb295hb4d2076b25137651@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <de8cad4d0808140908r7b1e7a04xc3d907da69fd3549@mail.gmail.com>
	<48A4C9DE.5060503@linuxtv.org>
	<de8cad4d0808141818i1d0b9c56m648457941248a68e@mail.gmail.com>
	<48A4E1FB.3050700@linuxtv.org>
	<de8cad4d0808141950p6eedb295hb4d2076b25137651@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - mxl5005s - QAM scanning
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

On Thu, Aug 14, 2008 at 10:50 PM, Brandon Jenkins <bcjenkins@tvwhere.com> wrote:
> On Thu, Aug 14, 2008 at 9:55 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> Brandon Jenkins wrote:
>>> On Thu, Aug 14, 2008 at 8:12 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>>>
>>>> Brandon Jenkins wrote:
>>>>
>>>>> Greetings all,
>>>>>
>>>>> The last time I tried scanning for QAM it didn't work. If I recall, it
>>>>> would be a while before the driver could be looked at. Has there been
>>>>> any change in status worth testing out again?
>>>>>
>>>> I have an HVR1600 model 74041 -- When I scan for QAM channels, I find the same channels that I find when I scan using any other QAM256-capable device.
>>>>
>>>> So yes, it's worth testing again.
>>>>
>>>> You wrote that email at noon, and now is eight hours later -- did you test it yet?
>>>>
>>>> -Mike
>>>>
>>>>
>>>
>>> Actually I did. Unfortunately, no change for usable scans. For me
>>> there was a change in the scan results when the driver went from
>>> mxl500x to mxl5005s back in May. (I think it was May) Since then I
>>> have been using my roof top antenna. However, now that VZ has moved to
>>> all digitlal channels I would like to see what I actually get via QAM
>>> again.
>>>
>>> I did find 40 services during a scan, but there were no associated
>>> PIDs. When it functioned, I was getting 80+ services.
>>>
>>> dumping lists (40 services)
>>> [01d6]:411000000:QAM_256:2031:2030:470
>>> [0078]:411000000:QAM_256:2058:2057:120
>>> [009a]:411000000:QAM_256:2044:2043:154
>>> [0105]:411000000:QAM_256:2035:2034:261
>>> [0064]:411000000:QAM_256:2062:2061:100
>>> [0091]:411000000:QAM_256:2053:2052:145
>>> [0097]:411000000:QAM_256:2049:2047:151
>>> [00c3]:411000000:QAM_256:2039:2038:195
>>> [00d9]:417000000:QAM_256:2000:1999:217
>>> [00a6]:417000000:QAM_256:2012:2011:166
>>> [008d]:417000000:QAM_256:2017:2016:141
>>> [00cd]:417000000:QAM_256:2004:2003:205
>>> [00a8]:417000000:QAM_256:2008:2007:168
>>> [0070]:417000000:QAM_256:2022:2021:112
>>> [0110]:417000000:QAM_256:1992:1991:272
>>> [0068]:417000000:QAM_256:2027:2026:104
>>> [00dd]:417000000:QAM_256:1996:1995:221
>>> [01d7]:423000000:QAM_256:2042:2041:471
>>> [007c]:423000000:QAM_256:2062:2061:124
>>> [00eb]:423000000:QAM_256:2055:2054:235
>>> [0140]:423000000:QAM_256:2050:2049:320
>>> [00d5]:423000000:QAM_256:2059:2058:213
>>> [0142]:423000000:QAM_256:2047:2046:322
>>> [0104]:423000000:QAM_256:2038:2037:260
>>> [006e]:429000000:QAM_256:2034:2033:110
>>> [00ee]:429000000:QAM_256:2013:2012:238
>>> [00ba]:429000000:QAM_256:2022:2021:186
>>> [00e5]:429000000:QAM_256:2017:2016:229
>>> [00f2]:429000000:QAM_256:2009:2008:242
>>> [0087]:429000000:QAM_256:2027:2026:135
>>> [00ae]:435000000:QAM_256:1629:1628:174
>>> [008f]:435000000:QAM_256:1639:1638:143
>>> [00b4]:435000000:QAM_256:1625:1624:180
>>> [00d3]:435000000:QAM_256:1613:1612:211
>>> [0095]:435000000:QAM_256:1634:1633:149
>>> [00df]:435000000:QAM_256:1608:1607:223
>>> [00c1]:435000000:QAM_256:1621:1620:193
>>> [00c7]:435000000:QAM_256:1617:1616:199
>>> [0266]:711000000:QAM_256:6141:6142:614
>>> [026a]:711000000:QAM_256:6181:6182:618
>>>
>>> Subsequent scan in SageTV only turned up 1 SD channel.
>>>
>> This does not look like a tuning issue -- Unfortunately, it seems that
>> there isn't much "in the clear" on yourdigital cable  provider.
>>
>> Are you able to see any additional channels in the clear using some
>> other product?
>>
>>> During the scan, the following appears in dmesg:
>>>
>>> [52241.432909] DVB: frontend 0 frequency 4294967295 out of range
>>> (54000000..858000000)
>>> [52241.543936] DVB: frontend 0 frequency 4294967295 out of range
>>> (54000000..858000000)
>>> [52254.018384] DVB: frontend 0 frequency 53000000 out of range
>>> (54000000..858000000)
>>>
>>> FTR - This was tested on Hauppauge model 74041, rev C5B2
>>>
>> Those first two look like application bugs.  The driver knows better
>> than to try to tune a number out of range like that.
>>
>> -Mike
>>
> Mike,
>
> The errors appear using scan and in SageTV. They could be using the
> same implementation though. If there is another tool I should be try,
> please let me know. I no longer have any other cards, but when the
> driver first switched over I had a Fusion5 GoldRT and an HVR-1800
> installed which were able pick up channels without issue using QAM. I
> still have a pull from the Mercurial source before it became broken,
> however it no longer compiles with an error in cx18-i2c.
>
> My cable service is Verizon's FiOS-TV which is FTTH and converted at
> the premises via an ONT to coax, phone, and ethernet. I can hook it up
> to the straight feed in the morning and run the test again, but the
> signal should be pretty clean.
>
> Thanks for the comments.
>
> Brandon
>

I hooked my cable feed directly into one of the cards this morning and
detected 376 services. I took a look at the splitter VZ installed and
it looks to be rated at 11db per port. I put a normal 3.5 db splitter
on and am still able to receive channels.

I guess the signal was too weak for scanning.

Thanks for the help!

Brandon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
