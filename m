Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kh40R-0006By-1A
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2008 17:04:19 +0200
Message-ID: <48D510E8.7080900@linuxtv.org>
Date: Sat, 20 Sep 2008 11:04:08 -0400
From: Steven Toth <stoth@linuxtv.org>
MIME-Version: 1.0
To: Jonathan Coles <jcoles0727@rogers.com>
References: <48D059AE.1060307@rogers.com>	<bb72339d0809161837w58ce1256g519306a029e36294@mail.gmail.com>
	<48D4DE00.90005@rogers.com>
In-Reply-To: <48D4DE00.90005@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Questions on v4l-dvb driver instructions
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

Jonathan Coles wrote:
> Perhaps I have some other misconfiguration in my system. With the wget 
> command I must use the --no-proxy option. Otherwise, I get "Error 
> parsing proxy URL http://:8080/: Invalid host name." Very strange that 
> port 8080 is assumed when the standard port is 80.
> 
> I couldn't find an equivalent no-proxy option for hg.
> 
> Thanks.

Please don't top-post, it's aainst to policy of the mailing list.

See below.

> 
> Owen Townend wrote:
>> 2008/9/17 Jonathan Coles <jcoles0727@rogers.com>:
>>   
>>> Your instructions at http://linuxtv.org/repo/ for obtaining v4l-dvb say
>>> to execute:
>>>
>>> hg clone http://linuxtv.org/hg/v4l-dvb
>>>
>>> But this returns
>>>
>>> abort: error: Name or service not known
>>>
>>> Perhaps there is a mistake in the instructions.
>>>     
>> copy and pasting that line here works fine:
>>
>> % hg clone http://linuxtv.org/hg/v4l-dvb
>> destination directory: v4l-dvb
>> requesting all changes
>> adding changesets
>> ...etc
>>
>>   
>>> It seems this checkout step is not really required, as you can download
>>> the tarball from a link on the page at the URL.
>>>     
>> One advantage of using mercurial over the tarball is the ability to
>> run `hg pull` and `hg update` rather than re download the entire set.
>>
>>   
>>> I also find it confusing that you mention dvb-apps, but don't talk about
>>> compiling it. Is it needed? Optional? An alternative?
>>>     
>> dvb-apps AFAIK are optional. I have not yet needed them in normal
>> operation of a tuner card.
>>
>>   
>>> Are there additional steps not presented here? I was unable to get my
>>> Hauppage HVR-950 to work on Ubuntu 8.04. Does this package support that
>>> device?
>>>     
>> Do you have the firmware for the device as well as the driver?
>>
>> On the mythtv-users list there was a success story using one of these
>> tuners. It details how they got it working before going into issues
>> using two of them:
>> http://www.gossamer-threads.com/lists/mythtv/users/349205?search_string=HVR-950;#349205
>> He was using the mcentral repository, and Edgy but the steps are
>> otherwise the same.
>>
>> Hope this helps,
>> cheers,
>> Owen.

Read this, it will probably help :)

http://www.selenic.com/mercurial/hgrc.5.html

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
