Return-path: <mchehab@gaivota>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46010 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab1AFVyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 16:54:44 -0500
Received: by qyk12 with SMTP id 12so19056991qyk.19
        for <linux-media@vger.kernel.org>; Thu, 06 Jan 2011 13:54:44 -0800 (PST)
References: <e95cvd7ycvmoq6jolupfigs0.1293494109547@email.android.com> <4D195584.6020409@redhat.com> <1293545649.2728.28.camel@morgan.silverblock.net> <4D19F809.3010409@redhat.com> <1293574691.7187.6.camel@localhost>
In-Reply-To: <1293574691.7187.6.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <D58022DE-5943-4412-9E97-45A59316CF42@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 0/8] Fix V4L/DVB/RC warnings
Date: Thu, 6 Jan 2011 16:54:53 -0500
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Dec 28, 2010, at 5:18 PM, Andy Walls wrote:

> On Tue, 2010-12-28 at 12:45 -0200, Mauro Carvalho Chehab wrote:
>> Em 28-12-2010 12:14, Andy Walls escreveu:
>>> On Tue, 2010-12-28 at 01:12 -0200, Mauro Carvalho Chehab wrote:
>>>> Em 27-12-2010 21:55, Andy Walls escreveu:
>>>>> I have hardware for lirc_zilog.  I can look later this week.
>>>> 
>>>> That would be great!
>>> 
>>> It shouldn't be hard to fix up the lirc_zilog.c use of adap->id but it
>>> may require a change to the hdpvr driver as well.
>>> 
>>> As I was looking, I noticed this commit is incomplete:
>>> 
>>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=07cc65d4f4a21a104269ff7e4e7be42bd26d7acb
>>> 
>>> The "goto" was missed in the conditional compilation for the HD-PVR:
>>> 
>>> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/staging/lirc/lirc_zilog.c;h=f0076eb025f1a0e9d412080caab87f627dda4970#l844
>>> 
>>> You might want to revert the trivial commit that removed the "done:"
>>> label.  When I clean up the dependence on adap->id, I may need the
>>> "done:" label back again.
>>> 
>>> 
>> Argh! this is not a very nice code at all...
>> 
>> I think that the proper way is to apply the enclosed patch. After having it
>> fixed, the dont_wait parameter can be passed to the driver via platform_data.
>> So, we should add a field at struct IR for it.
> 
> Well there is one more exception in lirc_zilog for the HD-PVR that also
> relies on adapter->id.
> 
> lirc_zilog only handles Hauppauge adapters with that Z8 microcontroller
> (PVR-150's, HVR-1600's, etc.) and the HD-PVR is the only device that
> requires these quirky exceptions AFAIK.
> 
> It's probably better just to let lirc_zilog cleanly know it is dealing
> with an HD-PVR and let it handle.  I'm working on it this evening and
> will post something soon.

Thanks much for working on this admittedly crappy lirc code, and apologies
for the relative radio silence of late. The holiday break didn't afford
nearly as much (okay, any) time for IR work like I'd hoped. :\

Trying to catch up now though, and I do have an hdpvr to beat on with
some of the patches I'm seeing floated on the list.

-- 
Jarod Wilson
jarod@wilsonet.com



