Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38801.mail.mud.yahoo.com ([209.191.125.92])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1Kdua9-00026F-Rw
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 00:24:12 +0200
Date: Thu, 11 Sep 2008 15:23:35 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>, free_beer_for_all@yahoo.com
In-Reply-To: <164710.35297.qm@web46108.mail.sp1.yahoo.com>
MIME-Version: 1.0
Message-ID: <247734.79799.qm@web38801.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
Reply-To: urishk@yahoo.com
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




--- On Thu, 9/11/08, barry bouwsma <free_beer_for_all@yahoo.com> wrote:

> From: barry bouwsma <free_beer_for_all@yahoo.com>
> Subject: Re: [linux-dvb] Multiproto API/Driver Update
> To: "linux-dvb" <linux-dvb@linuxtv.org>, urishk@yahoo.com
> Date: Thursday, September 11, 2008, 11:51 PM
> --- On Mon, 9/8/08, Uri Shkolnik <urishk@yahoo.com>
> wrote:
> 
> > First I would like to present myself (I'm new to
> this forum)
> 
> A hearty Welcome from my side, and I hope you have a
> pleasant
> stay.  Please help yourself to the refreshments from the
> bar,
> and have a kipper.  ;-)
> 

Thanks :-)

> 
> > I don't know what should be done next, which API
> (and
> > sub-system) should be added first, second, ... (or not
> at
> > all?). I have my own views (CMMB getting much more
> audience
> > than DVB-H and ISDB-T more than the DAB family). 
> 
> Of course, this will depend on your location -- in some
> parts
> of Europe, DVB-H is available as an (subscription) option
> and
> DAB is widespread from the provider-point-of-view.
> 
> It is from my perspective in Europe that I write, where
> ISDB-T
> is not used, but DAB hardware is relatively difficult to
> find.
> Still, DAB services have been widely available for a longer
> time than DVB-T has been operating.
> 
I'm not so sure. As I see it, if it depends on number of users DVB-H comes last after CMMB and ISDB-T.

> 
> > One point regarding Siano non-DVB offering - With
> Michael
> > Krufky's help, I'm trying to find a way to add
> > Siano's non-DVB(-T) offering into the kernel's
> code
> > base (till now we supply a proprietary sources
> directly to
> > our customers).
> 
> When you say `customers', do you mean business
> customers,
> for example, TerraTec, which has incorporated your device
> into the Cinergy Piranha, which I have, and for which the
> TerraTec-supplied 'Doze media player can sort-of
> successfully
> play the available DAB stations?  Or do you mean,
> `end-users'
> (fnarr) such as myself, who want to use this device under
> Linux, for more than DVB-T?
> 

Siano does not manufacture devices. So 'business customers' will fit. 

I know the TerraTec device you refer to, and theoretically it can be used as DAB radio receiver. The current LinuxTV lacks the code to support it.
  
> 
> Here is my biggest question, which probably could be
> answered
> if I used a Real Web Browser.
> 
> My Internet access is mostly through a SSH connection to a
> text-
> only web-browser on a trusted host, usually on a borrowed
> connection.  So I don't have access to Javascript
> links, or
> other non-text offerings -- and often I have no access at
> all,
> so I've sort of adopted a UUCP-like way of
> `working', for some
> values of `work'.
> 
> 
> In Mr. Krufky's work, I've seen reference to
> Siano-provided
> drivers as an alternative to those which he's
> painstakingly
> adapted and included in the mainstream.  Unfortunately for
> me,
> the link is to the main webpage, and from there, normal
> links
> lead nowhere interesting.  There are plenty of Javascript
> links
> that I can't follow.  So, I haven't found anything
> which might
> help me to answer my further questions myself, and for
> that,
> I must apologise.

You can ask any question you like to, I'll gladly help you with anything I can. 

> 
> 
> >  Of course it will be somewhat specific code
> > by the fact that it'll match Siano's chipset
> instead
> > of be more generic.
> 
> I don't see this as a real problem, because I don't
> know
> how to weave a generic API from the DAB/DAB+ specs that
> I've read.
> 

It's quite simple actually. 
There is a open source module from Siano that enable DAB @ Linux. The problem is that this module is not a part of DVB and does not communicates with DVB in any way, but it uses its own character devices in order to communicate with user space applications. It may be converted of course to something that uses DVB, and also be more generic.

> 
> I was hoping to find a diagram of the demodulation process
> for DAB streams, from the OFDM RF carrier (handled by the
> hardware) to the mp2/AAC+ audio decoding (in Linux, handled
> by a userspace software player).  Unfortunately, I could
> not
> find anything...

I'm not sure I understand you, so -
1) You always get the digital output from the device (in case of DAB it a framed stream). I don't know any hardware that pipe out the raw modem output.
2) If you refer to the frontend parameters (for DAB family), I can supply you with those.
3) FIB parsing (this is part of the control scheme that is used by DAB) - you get a stream of data frames contain it. Siano offers binary library (user space) that parses it and gives simple API to know what are the available services.


> 
> Had I found something, I would ask you, if it is not
> obvious
> from freely-available code to customers, just where in the
> chain of decoding, your hardware outputs a stream.  I mean,
> if I supply a channel number such as 12C (VHF), would I be
> seeing the entire multiplex from which I could extract one
> particular service, or can I expect something more
> specific?
> 
DAB is not a multiplex... 
> 
> I suspect that I would likely find that with different
> devices (of the few that are available), I'd be tapping
> into the demodulation-demultiplexing chain at different
> points, therefore needing to be able to tweak the devices
> differently appropriate to where I tap into the chain.
> 



> 
> But then, I really don't know what I'm talking
> about.
> 
> 
> thanks,
> barry bouwsma


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
