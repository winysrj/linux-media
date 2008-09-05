Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 05 Sep 2008 10:32:05 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <d9def9db0809041632q54b734bcm124018d8e0f72635@mail.gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>
Message-id: <48C142E5.60307@linuxtv.org>
MIME-version: 1.0
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com> <20080904204709.GA32329@linuxtv.org>
	<d9def9db0809041632q54b734bcm124018d8e0f72635@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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

Markus Rechberger wrote:
> Hi,
> 
> On Thu, Sep 4, 2008 at 10:47 PM, Johannes Stezenbach <js@linuxtv.org> wrote:
>> On Thu, Sep 04, 2008, Manu Abraham wrote:
>>> Does it support ISDB-T, ATSC-MH, CMMB, DBM-T/H?
>>> Intentionally, no!  Experience with the old api development has proven
>>> that making blind assumptions about delivery systems is a bad idea.
>>> It's better to add in support for these when the hardware actually arrives
>>> and can be properly tested.
> 
> I have Empia ISDB-T and DMB-T/H hardware and the corresponding signal
> generator for it here,
> it's right on my roadmap and work can be started within a few days.

With all due respect, their is a big difference between can and will.

Are you committing to adding ISDB-T and DMB-T/H support, and having that 
code live at linuxtv.org?

Or, are these patches something that you'd want to keep in your 
out-of-kernel trees at mcentral.de, like your other works? (This isn't 
am opportunity to flame, it's a genuine question - I'm interested in 
your future direction plans).


> 
>> Full ACK on this one. Once an API is merged into the mailine
>> kernel we're stuck with it, no matter how ugly and broken it might be.
>> -> NEVER merge untested APIs
> 
> should be the rule but there's always an exception for it too . o (
> thinking about KVM )


We don't add API's that can't be tested, that's just a basic rule.


> 
>>> If you would like to use any of these drivers now, you may pull the
>>> tree from http://jusst.de/hg/multiproto.  Drivers may be configured
>>> with 'make menuconfig' the same as you've done with v4l.
>>>
>>> Feedback, bug reports, etc. are welcomed and encouraged!
>> I only want to add a bit of historical perspective so people
>> are aware of the reasons why Steve came up with his alternative
>> API proposal, and why a number of developers seem to support it.


Yes.


>>
>> First let's look at the timestamps:
>> http://jusst.de/hg/multiproto/log/2a911b8f9910/linux/include/linux/dvb/frontend.h
>> http://jusst.de/hg/multiproto_api_merge/log/4c62efb08ea6/linux/include/linux/dvb/frontend.h
>>
>> Then at some discussion from nearly one year ago:
>> http://article.gmane.org/gmane.linux.drivers.dvb/36643

This is a great one page email, worth reading everyone.

>>
> 
> by experience I'm sure most people won't read up the history here...

Maybe.

Manu,

The S2API tree is available on linuxtv.org for people to download and 
experiment with. It has HVR4000 DVB-S2 support, QAM, ATSC, DVB-S and 
DVB-T. These are known to work with the exercising tool. We are testing 
ISDB-T over the next few days.... It's preliminary.

I need to do some comparison for plumbers.

Why aren't you issuing a pull request that includes the 3200 drivers?

- Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
