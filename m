Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38802.mail.mud.yahoo.com ([209.191.125.93])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1KdqQl-000572-24
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 19:58:12 +0200
Date: Thu, 11 Sep 2008 10:57:36 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: Andreas Oberritter <obi@linuxtv.org>
In-Reply-To: <48C9363C.6070801@linuxtv.org>
MIME-Version: 1.0
Message-ID: <708306.32642.qm@web38802.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiple frontends on a single adapter support
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




--- On Thu, 9/11/08, Andreas Oberritter <obi@linuxtv.org> wrote:

> From: Andreas Oberritter <obi@linuxtv.org>
> Subject: Re: [linux-dvb] Multiple frontends on a single adapter support
> To: 
> Cc: linux-dvb@linuxtv.org
> Date: Thursday, September 11, 2008, 6:16 PM
> Christophe Thommeret wrote:
> > Uri Shkolnik said:
> > "Some of the hardware devices which using our
> chipset have two tuners per 
> > instance, and should expose 1-2 tuners with 0-2 demux
> (TS), since not all DTV 
> > standard are TS based, and when they are (TS based),
> it depends when you are 
> > using two given tuners together (diversity  mode, same
> content) or each one 
> > is used separately (different frequency and
> modulation, different content, 
> > etc.)."
> > 
> > 
> > 
> > So, here are my questions:
> > 
> > @Steven Toth:
> > What do you think of Andreas' suggestion? Do you
> think it could be done that 
> > way for HVR4000 (and 3000?) ?
> > 
> > @Uri Shkolnik:
> > Do you mean that non-TS based standards don't make
> use of multiplexing at all?
> > 
> 
> I guess diversity mode should be transparent to the user,
> so such a
> device would register only one frontend (and thus only one
> demux) per
> set of tuners used in diversity mode.
> 
> While your statements about non-TS based standards make
> sense, those
> standards would require further work to be covered by a
> future API. In
> this special case, however, we're discussing correct
> usage of the
> current (TS based) demux API.
> 
> Regards,
> Andreas
> 


Regarding the diversity mode - Need to be kept flexible, a device can switch mode (between using a given set of tuners as input for single content or use each tuner for different content)

Regarding Non-TS - I must disagree, there are several posts on this ML that contradict your assumptions, and (much) more important, CMMB after two months of service has much bigger deployment than DVB-H, DVB-T2 and DVB-S2 putting together. T-DMB (DAB) also has much bigger audience.

The optimum is to support all DTV standards :-) , but facing the reality, we must set some priority, and I think the priority should be base on the current users number, and the forecast of DTV standards "market share".

Uri


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
