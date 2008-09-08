Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KcjDK-0002Um-N2
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 18:03:45 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6V00LYKWL72LX0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 08 Sep 2008 12:03:07 -0400 (EDT)
Date: Mon, 08 Sep 2008 12:03:06 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48C5091F.3050807@koala.ie>
To: Simon Kenyon <simon@koala.ie>
Message-id: <48C54CBA.6050405@linuxtv.org>
MIME-version: 1.0
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com> <20080904204709.GA32329@linuxtv.org>
	<d9def9db0809041632q54b734bcm124018d8e0f72635@mail.gmail.com>
	<48C1380F.7050705@linuxtv.org> <48C42851.8070005@koala.ie>
	<d9def9db0809071252x708f1b1ch6c23cb3d2b5796e9@mail.gmail.com>
	<48C5091F.3050807@koala.ie>
Cc: DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Simon Kenyon wrote:
> Markus Rechberger wrote:
>> On Sun, Sep 7, 2008 at 9:15 PM, Simon Kenyon <simon@koala.ie> wrote:
>>   
>>> Steven Toth wrote:
>>>     
>>>> A big difference between can and will, the em28xx fiasco tells us this.
>>>>
>>>>       
>>> just wondering if your tree will go any way towards resolving that
>>> little problem?
>>>     
>> I don't see any fiasco nor problem here, it's more comfortable to have
>> the em28xx in an extra
>> tree and do ongoing development with it. People who followed the
>> development  during the last
>> few years know that newer things got added and newer chips are
>> supported by it, it will continue
>> to evolve anyway.
>>
>> The driverwork is currently around 30% of it, patching applications
>> and providing full support from
>> the driver till the endapplications is what everything's focussing on
>> mcentral.de not just driver only
>> development.
>>
>> We do dedicated application support for several customers too (analog
>> tv, radio, dvb integration in their
>> business applications).
>> There are many new products coming up, adding support for them is on
>> the roadmap.
>>
>> Markus
>>
>>   
> i have had the device for a while now
> i originally got it because the wiki showed that support was being worked on
> then that all changed and you moved your stuff elsewhere
> 
> i really don't understand your rationale. i really don't.
> i'm not trying to start a flame war, but your arguments for having your 
> own tree and doing stuff user side makes no sense
> 
> let my try to explain:
> 
> you say:
> 
>  > it is more comfortable to have the em28xx in an extra tree
> 
> it may very well be comfortable for you. but it is impossible for me
> i have lots of different devices. i can choose between using your tree 
> and having support for one of them.
> or i change choose the linuxtv.org tree and have supoort for all the 
> other. how is that "more comfortable"?
> i really don't understand that argument
> 
> you then say:
> 
>  > newer things get added and newer chips are supported by it
> 
> how does that help me? it doesn't, as far as i can see
> 
> next you say:
> 
>  > the driverwork is currently around 30% of it, patching applications 
> and providing full support from the driver till the...
> 
> apart from the little speedbump that is multiproto vs. s2api most apps 
> don't need "supporting". they are already supported by their respective 
> communities.
> 
>  > we do dedicated application support for several customers...
> 
> now i think we get to the heart of the matter.
> you have built up a nice little business providing support for the 
> various devices. you have customers who (in my humble opinion 
> misguidedly) think that by having support in your tree that they can 
> proudly boast "linux supported". all i can say is well done. 
> congratulations on building a sucessful business.
> 
> but please do not mistake that for providing linux support for the 
> em28xx devices in linux. what you are providing and "linux support of 
> the em28xx class of devices" are not one and the same thing. for better 
> or worse, linux support means that at some point (and it may well be one 
> year from now) it will be in the kernel.
> have you not seen all the software that has come and gone because linus 
> will not put it in the tree. right now the only route to doing that is 
> to get it in the linuxtv.org tree. from there it stands some chance of 
> making it into the kernel. i seriously doubt that any other approach has 
> any chance of success.
> 
> this may not be of concern or interest to you. well so be it. but it is 
> important to me.

Good comments Simon, and I largely agree with you.

I've tried to help mediate on issues like this in the past, trying to 
get the em28xx tree back to linuxtv.org and in the master repo. But, 
people are people and the major players fundamentally disagree about 
major issues. We can't find a way to resolve this - and I don't think it 
will ever be resolved.

Pity, because Hauppauge sold a lot of em28xx based products, as did many 
other companies.

- Steve





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
