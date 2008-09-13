Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1Kebi6-0005iL-RY
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 22:27:16 +0200
Message-ID: <48CC219C.9010007@singlespoon.org.au>
Date: Sun, 14 Sep 2008 06:25:00 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: free_beer_for_all@yahoo.com, linux dvb <linux-dvb@linuxtv.org>
References: <466191.65236.qm@web46110.mail.sp1.yahoo.com>
In-Reply-To: <466191.65236.qm@web46110.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] Why I need to choose better Subject: headers [was:
	Re: Why (etc.)]
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

Barry,
I drew the line at porting the xc3028 tuner module from mcentral.de into 
v4l-dvb, so no didn't solve the firmware issues. If you know what you 
are doing it should be trivial work - just linking in yet another tuner 
module and then calling it like all the others. For me because I don't 
know the code well it would take a week or two.

The other issue is that with the state of relationship between Markus 
Rechberger and the community I don't want to be in the middle of that.

Cheers Paul

barry bouwsma wrote:
> --- On Sat, 9/13/08, Paul Chubb <paulc@singlespoon.org.au> wrote:
>
>   
>> around 2.6.22. At some stage the functionality in videobuf_core.c was 
>> replaced by video-buf-dvb.c. This meant that when you compile against 
>> the 2.6.22 headers it works fine but still loads the videobuf_core 
>> module from the previous module set. Once you get to 2.6.24 it still 
>> loads videobuf_core, however now you get a lot of symbol issues when it 
>> loads and ultimately the driver for the card didn't work. This was 
>>     
>
> Ah, thanks.  I've seen this (in the list) often and ignored it
> as a newbie error.  (I ignore most things anyway)
>
> Now I'm trying to hack* around something comparable in a diff
> which has strangely disappeared from my screen, but may be
> videodev.c --> v4l2-dev.c  which probably will/has cause(d)
> issues.
>
> * `hack' should be translated as, looking at the diffs, wishing
> I had had more sleep, even if it had meant missing all the doku on
> Chairman Humph (for those in the know) that I should have instead
> recorded for later viewing, and wondering if a `make-it-compile'
> hack is enough...  Am I making sense?  Should I sleep?
>
>
>   
>> 2) The v4l-dvb tree has complex firmware loading logic in tuner-xc2028.c 
>>
>> So either could be fixed, and I fixed the first. I could have fixed the 
>> second by investing more time.
>>     
>
> Just to be clear -- did you fix the firmware issue, or the issue
> with migration of, and changes to, source files, which in my
> hum^Wignorant opinion, would be the more difficult one in general?
>
>
>   
>>  But I don't think that is why people talk 
>> about incompatibility between the two.
>>     
>
> It's helpful to me, nonetheless.  I am sympathetic to the fork,
> as my `production' (were I to produce anything; in reality, I
> mean that it's been several years operating with only power
> failures requiring attention, otherwise generally running with
> full CPU load) machine is 2.6.14 and has loads of hacks which
> I need to apply to a more recent kernel, should I find a stable
> one (perhaps the hardware of my development machine is suspect
> here, as I now have nearly a week uptime on the same kernel
> which would typically freeze/panic within a few hours -- watch
> it wedge solid before I can send this, again), and much of the
> code which I've hacked (UFS large fragment size filesystem,
> ISA ethernet and others) has or may have suffered substantial
> rewriting since I got it working...  That second sentence was long...
>
>
> thanks for your feedback!
> barry bouwsma
>
>
>       
>
>
>   


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
