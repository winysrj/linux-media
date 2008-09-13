Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1KeeoD-0002cm-QQ
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 01:45:47 +0200
Message-ID: <48CC501F.20609@singlespoon.org.au>
Date: Sun, 14 Sep 2008 09:43:27 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: Joe Djemal <joe.djemal@btconnect.com>,
	"linux-dvb >> linux dvb" <linux-dvb@linuxtv.org>
References: <mailman.757.1221287462.834.linux-dvb@linuxtv.org>
	<200809130945.11500.joe.djemal@btconnect.com>
In-Reply-To: <200809130945.11500.joe.djemal@btconnect.com>
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 44, Issue 60
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

Hi,
     there is a good book on kernel development by Robert Love - Linux 
Kernel Development. I read about two thirds of it. Lots of useful 
information but I found it difficult to get a wide viewpoint of the 
process. It would be great to have beside you as a reference. Looking on 
Amazon - I wanted to check the details - there are several other books 
including linux device drivers by Rubini.

HTH

Cheers Paul

Joe Djemal wrote:
> I concur with the below. I can code in quite a few languages including 
> assembly languages and I asked for a pointer on where to get started with 
> learning how to make a Linux driver and there was complete silence as there 
> was with my previous inquiry.
>
> Come on guys, I've been Googling but where do I start?
>
> Joe
>
>
>   
>> Message: 5
>> Date: Sat, 13 Sep 2008 16:28:10 +1000
>> From: Paul Chubb <paulc@singlespoon.org.au>
>> Subject: [linux-dvb] why opensource will fail
>> To: linux dvb <linux-dvb@linuxtv.org>
>> Message-ID: <48CB5D7A.3040403@singlespoon.org.au>
>> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>>
>> Hi,
>>      now that I have your attention:-{)=
>>
>> I believe that this community has a real problem. There appears to be
>> little willingness to help and mentor newcomers. This will limit the
>> effectiveness of the community because it will hinder expansion of
>> people who are both willing and able to work on the code. Eventually
>> this issue  will lead to the community dying simply because you have
>> people leaving but few joining.
>>
>> The card I was working on has been around for  a while now. There have
>> been three attempts so far to get it working with Linux. Two in this
>> community and one against the mcentral.de tree. Both attempts in this
>> community have failed not because of a lack of willingness of the people
>> involved to do the hard yards but because of the inability of the
>> community to mentor and help newcomers.
>>
>> The third attempt by a Czech programmer succeeded, however it is
>> dependent on the mcentral.de tree and the author appears to have made no
>> attempt to get the patch into the tree. The original instructions to
>> produce a driver set are in Czech. However instructions in english for
>> 2.6.22 are available - ubuntu gutsy. I will soon be putting up
>> instructions for 2.6.24 - hardy. They may even work  for later revisions
>> since the big issue was incompatible versioning.
>>
>> I understand from recent posts to this list that many in the community
>> are disturbed by the existence of mcentral.de. Well every person from
>> now on who wants to run the Leadtek Winfast DTV1800H will be using that
>> tree. Since the card is excellent value for what it is, there should be
>> lots of them. Not helping newcomers who are trying to add cards has led
>> and will lead to increased fragmentation.
>>
>> And before you say or think that we are all volunteers here, I am a
>> volunteer also. I have spent close to 3 weeks on this code and it is
>> very close to working. The biggest difference between working code in
>> the mcentral.de tree and the patch I was working on is the firmware that
>> is used.
>>
>> Finally you might consider that if few developers are prepared to work
>> on the v4l-dvb tree, then much of the fun will disappear because those
>> few will have to do everything.
>>
>> Cheers Paul
>>     
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
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
