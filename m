Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 14 Oct 2008 10:57:42 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48F42D5C.7090908@linuxtv.org>
To: Andreas Oberritter <obi@linuxtv.org>
Message-id: <48F4B366.7050508@linuxtv.org>
MIME-version: 1.0
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48CE7838.2060702@linuxtv.org> <23602.1221904652@kewl.org>
	<48D51000.3060006@linuxtv.org> <25577.1221924224@kewl.org>
	<20080921234339.18450@gmx.net> <8002.1222068668@kewl.org>
	<20080922124908.203800@gmx.net> <10822.1222089271@kewl.org>
	<48D7C15E.5060509@linuxtv.org> <20080922164108.203780@gmx.net>
	<20022.1222162539@kewl.org> <20080923142509.86330@gmx.net>
	<4025.1222264419@kewl.org> <4284.1222265835@kewl.org>
	<20080925145223.47290@gmx.net> <18599.1222354652@kewl.org>
	<Pine.LNX.4.64.0809261117150.21806@trider-g7>
	<21180.1223610119@kewl.org>
	<20081010132352.273810@gmx.net> <48EF7E78.6040102@linuxtv.org>
	<30863.1223711672@kewl.org> <48F0AA35.6020005@linuxtv.org>
	<773.1223732259@kewl.org> <48F0AEA3.50704@linuxtv.org>
	<989.1223733525@kewl.org> <48F0B6C5.5090505@linuxtv.org>
	<1506.1223737964@kewl.org> <48F0E516.303@linuxtv.org>
	<20081011190015.175420@gmx.net> <48F36B32.5060006@linuxtv.org>
	<48F42D5C.7090908@linuxtv.org>
Cc: Hans Werner <HWerner4@gmx.de>, fabbione@fabbione.net,
	linux-dvb <linux-dvb@linuxtv.org>, scarfoglio@arpacoop.it
Subject: Re: [linux-dvb] Multi-frontend patch merge (TESTERS FEEDBACK) was:
 Re: [PATCH] S2API: add multifrontend
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

Andreas Oberritter wrote:
> Hello Steve,
> 
> Steven Toth wrote:
>> I'm mutating the subject thread, and cc'ing the public mailing list into 
>> this conversion. Now is the time to announce the intension to merge 
>> multi-frontend patches, and show that we have tested and are satisfied 
>> with it's reliability across many trees.
>>
>> (For those of you not familiar with the patch set, it adds 
>> 'multiple-frontends to a single transport bus' support for the HVR3000 
>> and HVR4000, and potentially another 7134 based design (the 6 way medion 
>> board?).
> 
> is this code still using more than one demux device per transport bus, or
> has it already been changed to make use of the DMX_SET_SOURCE command?

Yes.

I'm glad you mentioned this, I discussed this at LPC with a number of 
people.

The current code that's being tested in the mfe tree's implements 
multiple demux devices, that has not changed.

Speaking with two other devs at LPC we discussed changing this approach 
(and the current approach for many dual channel boards), to having a 
unified single adapter device, with either multiple demux devices or 
not. As a basic discussion topic the ideal had a lot of support.

A good example of this in the current kernel (without any MFE patches) 
is the current cx23885 driver, that registers adapter0 and adapter1 with 
two different ATSC frontends. I question (and argue) that it should 
really be /dev/dvb/adapter0/demux{0,1}

The same is also true for the for the multi-frontend patches, it should 
probably change (as part of an overall adapterX overhaul) to match the 
LinuxTV DVB API and register only one demux device.

That's a much larger project, and has not been addressed yet. Many users 
will probably also argue that it's unimportant work, when application 
are currently working.

My opinion is that we would review the adapter usage and determine 
whether we need or want to change that. If we do change it we should 
probably add some better application interfaces from the adapter inode - 
In a model similar to the S2API has done for frontends. Applications 
would then be able to query board specific details in a way that cannot 
be easily done now.

However, regardless of my opinions, it would be a mistake to hold back a 
merge of the current multi-frontend patches. Instead, we should merge 
the large number of MFE patches and start a larger adapter level 
discussion and slowly evolve with smaller patches. (We'll need someone 
to draft an RFC).

Are you volunteering to address this larger subject?

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
