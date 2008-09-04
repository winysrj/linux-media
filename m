Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KbOJU-0004RX-4t
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 01:32:33 +0200
Received: by wx-out-0506.google.com with SMTP id h27so49627wxd.17
	for <linux-dvb@linuxtv.org>; Thu, 04 Sep 2008 16:32:27 -0700 (PDT)
Message-ID: <d9def9db0809041632q54b734bcm124018d8e0f72635@mail.gmail.com>
Date: Fri, 5 Sep 2008 01:32:27 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
In-Reply-To: <20080904204709.GA32329@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com> <20080904204709.GA32329@linuxtv.org>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
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

Hi,

On Thu, Sep 4, 2008 at 10:47 PM, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Thu, Sep 04, 2008, Manu Abraham wrote:
>>
>> Does it support ISDB-T, ATSC-MH, CMMB, DBM-T/H?
>> Intentionally, no!  Experience with the old api development has proven
>> that making blind assumptions about delivery systems is a bad idea.
>> It's better to add in support for these when the hardware actually arrives
>> and can be properly tested.
>

I have Empia ISDB-T and DMB-T/H hardware and the corresponding signal
generator for it here,
it's right on my roadmap and work can be started within a few days.

> Full ACK on this one. Once an API is merged into the mailine
> kernel we're stuck with it, no matter how ugly and broken it might be.
> -> NEVER merge untested APIs

should be the rule but there's always an exception for it too . o (
thinking about KVM )

>
>> If you would like to use any of these drivers now, you may pull the
>> tree from http://jusst.de/hg/multiproto.  Drivers may be configured
>> with 'make menuconfig' the same as you've done with v4l.
>>
>> Feedback, bug reports, etc. are welcomed and encouraged!
>
> I only want to add a bit of historical perspective so people
> are aware of the reasons why Steve came up with his alternative
> API proposal, and why a number of developers seem to support it.
>
> First let's look at the timestamps:
> http://jusst.de/hg/multiproto/log/2a911b8f9910/linux/include/linux/dvb/frontend.h
> http://jusst.de/hg/multiproto_api_merge/log/4c62efb08ea6/linux/include/linux/dvb/frontend.h
>
> Then at some discussion from nearly one year ago:
> http://article.gmane.org/gmane.linux.drivers.dvb/36643
>

by experience I'm sure most people won't read up the history here...

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
