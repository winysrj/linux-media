Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KiXeV-0002lh-KR
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 18:55:48 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Wed, 24 Sep 2008 18:54:41 +0200
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<37219a840809150842l3a6260j4b57f14026e5c40a@mail.gmail.com>
	<200809191258.35827.julian@jusst.de>
In-Reply-To: <200809191258.35827.julian@jusst.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809241854.42271@orion.escape-edv.de>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
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

Julian Scheel wrote:
> Michael,
> 
> On Monday 15 September 2008 17:42:06 Michael Krufky wrote:
> > In summary, the bottom line is this:
> >
> > Manu did a great job with the multiproto API, people were happy using
> > it, and all of the LinuxDVB developer community was happy with the
> > work that was done, and we all wanted to merge it ~ two years ago.
> >
> > Back then, Manu said that it wasnt ready, so for some time we waited
> > for him in hopes that he would agree that it was ready for merge.
> >
> > As more months went by, Manu was asked if he would be merging his
> > changes, and he kept answering to the effect of "it's not ready yet,
> > but should be in a few weeks"
> >
> > Months and months and months went by since then, with an occasional
> > ping to Manu, with the reply "not ready yet" ...
> >
> > Two years is a very long time to wait for a new API, especially
> > considering that it was functional from the start.  It was looking
> > like Manu may not have had any intention at all to merge his work into
> > the master v4l/dvb development repository --  It should be not be
> > surprising at all that Steven Toth felt the need to come up with his
> > own solution.
> >
> > Steven posted a proposal for his API expansion solution, and he
> > received positive feedback.  Immediately, Manu broke out of his
> > silence and sent in a pull request.
> >
> >
> > Is there malice here??  No.  There is development, and developers
> > looking to move forward.  Nobody is at fault.
> >
> >
> > I have posted the above just to clarify what the "politics" actually
> > are, here.  The only real politics going around are those that are
> > accusing others of politics themselves.
> >
> > Had Manu been willing to merge his work earlier, this would have all
> > been a non-issue.  However, now there is an alternative proposal on
> > the table, which appears to be more robust and may have more potential
> > that the multiproto proposal.
> >
> > Does that mean multiproto is disqualified?   Absolutely not.
> >
> > Does the fact that multiproto was there first mean that it will be
> > merged without question now that it is suddenly available?  No, not
> > necessarily.
> >
> > What does it mean?  It means that now there are two proposals on the
> > table.  Two ways to solve a problem using different ideas and methods.
> >
> > The end users that have piped into the discussion are mostly concerned
> > with which API demonstration repository already contains support for
> > their device.  This should have no bearing whatsoever on the decision
> > of the linuxDVB API extension.  All drivers will be ported to
> > whichever solution is decided upon.
> >
> > Now is the time to examine these solutions from a developer point of
> > view, in terms of how this affects kernel developers and application
> > developers alike.  There is no reason to rush into things just because
> > a pull request has been made -- the outcome of this decision is highly
> > important, and we will have to live with the decision for a good long
> > time.
> 
> Thanks for your version of the history. I just have to say I can't really 
> agree with the way you describe the history. To point this out I looked up 
> some of the old threads...
> 
> So everything started in 2005 with initial proposals for a DVB-S2 extension of 
> the API by Marcel. In early 2006 there were some discussions about it on the 
> lists:
> http://thread.gmane.org/gmane.linux.drivers.dvb/23914/focus=24030
> http://thread.gmane.org/gmane.linux.drivers.dvb/24239
> 
> At that thought not much (if any) capable hardware was available, so the idea 
> was put off for the moment.
> Then in April 2006 Manu started to work at the things and provided a first 
> draft based on the changes from Marcel:
> http://thread.gmane.org/gmane.linux.drivers.dvb/25401
> 
> An initial driver for KNC cards was provided by Manu based on this API 
> proposal. After some discussions on 05 May 2006 Manu requested for a pull of 
> the API:
> http://www.linuxtv.org/pipermail/v4l-dvb-maintainer/2006-May/001006.html
> 
> Immediately followed by Johannes stating that he is not satisfied with the API 
> yet and suggested a rework:
> http://www.linuxtv.org/pipermail/v4l-dvb-maintainer/2006-May/001007.html
> 
> At that time rework began while in parallel some people (including jusst 
> technologies) started testing the first drivers. As expected they were still 
> far away from running perfect.
> 
> So it took a while to come to obvious progress. In January 2007 Manu announced 
> the mp-stb0899-c5 tree - not even the current multiproto tree - which included 
> the results of the rework. Some testing was done on that by more people.
> http://thread.gmane.org/gmane.linux.drivers.dvb/31146/focus=31159
> 
> In February Steven came up with initial support for HVR 4000 in the multiproto 
> tree.
> http://thread.gmane.org/gmane.linux.drivers.dvb/31605/focus=31644
> 
> Furthermore at this time the dvb-apps (at least parts of) were started to be 
> extended by multiproto support, so that more people (which do not write their 
> own applications...) could start testing.
> http://thread.gmane.org/gmane.linux.drivers.dvb/31726/focus=31729
> 
> In March Steven asked for the status of multiproto. Manu noted that the API 
> should be fine, but also asked Steve to look into dvb_frontend where Manu was 
> not sure of not having introduced new issues.
> http://thread.gmane.org/gmane.linux.drivers.dvb/31938/focus=32144
> 
> End of May 2007 still problems in dvb-core, which were related to the new API 
> came up and were fixed:
> http://thread.gmane.org/gmane.linux.drivers.dvb/33893
> 
> Then in Sept 2007 discussions came up how to integrate the multiproto API, 
> doing this as experimental or non-experimental.
> http://thread.gmane.org/gmane.linux.drivers.dvb/36082/focus=36411
> 
> In Oct 2007 Steven abandons his support for multiproto, due to delays caused 
> by several reasons. Political, surely also personal, but also technical.
> http://thread.gmane.org/gmane.linux.drivers.dvb/36583/focus=36670
> 
> At the same time some more sophisticated DVB-S2 featues were requestes by the 
> users:
> http://thread.gmane.org/gmane.linux.drivers.dvb/36785/focus=36789
> 
> Finally in Nov 2007 Oliver did a full review of the new code, which was 
> necessary for merging. Still he asked for more reviewers.
> http://article.gmane.org/gmane.linux.drivers.dvb/37665
> 
> In January 2008 another user-initialised thread came up:
> http://thread.gmane.org/gmane.linux.drivers.dvb/38529/focus=38544
> Still testing is obviously needed as bugs still come up.
> 
> In Apr 2008 VDR announced support for multiproto tree, so that more testing 
> can be done by many users.
> 
> End of May Manu left for travelling and personal stuff until August, just with 
> short breaks apllying some minor patches. Still some users report issues with 
> multiproro, which were not fully taken care of.
> 
> After his vacation Manu came back on this topic and did another shot at a pull 
> request.
> 
> ---
> 
> So this is how I see the history. Still 2 years is a very long time, but 
> everyone should keep in mind that introduction of DVB-S2 support has been 
> (still is) a big task with many problems. At first of course it is a big API 
> extension, which is always problematic.
> Furthermore it is an API extension for a hardware which still is not spread 
> too widely and especially was not spread in 2006. And even those who had 
> proper cards for receiving DVB-S2 still were not able to make any use out of 
> the received data. To properly do testing at user side it was really necessary 
> to at least have a way to watch some of the distributed content, just to be 
> sure it is working well.
> This was not possible for a long time due to lacing features in ffmpeg and 
> missing alternatives. Still I think the only really working way is using a 
> binary Windows codec named CoreAVC.
> 
> Keeping all this in mind two years are not too long in my eyes.
> 
> So this are just my 2 cents on this topic. All that I am interested in is a 
> properly working API with wide application and driver support. Which proposal 
> ever fits better - but decided on a technical base and not on historical or 
> personal terms.
> 
> Regards,
> Julian

Thanks for the detailed (and imho correct) description of the history.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
