Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail1.syd.koalatelecom.com.au ([123.108.76.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter_s_d@fastmail.com.au>) id 1JQKKF-0008Lh-JA
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 11:31:20 +0100
From: "Peter D." <peter_s_d@fastmail.com.au>
To: Bruce Schultz <bruce.schultz@gmail.com>
Date: Sat, 16 Feb 2008 21:31:02 +1100
References: <20080120194031.47ad683c@jeff.localdomain>
	<200801210913.45283.peter_s_d@fastmail.com.au>
	<47B03CBA.3080302@gmail.com>
In-Reply-To: <47B03CBA.3080302@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802162131.02775.peter_s_d@fastmail.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Update to au-Melbourne scan list
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Monday 11 February 2008, Bruce Schultz wrote:
> On 21/01/08 08:13, Peter D. wrote:
> > On Monday 21 January 2008, Bruce Schultz wrote:
> >> On 20/01/08 20:47, Peter D. wrote:
> >>> On Sunday 20 January 2008, Jeff Bailes wrote:
> >>>> Hi,
> >>>> 	Back in November, channel Seven changed their fec_hi from 2/3 to
> >>>> 3/4 causing scans to not pick it up
> >>>> (
> >>>> http://www.dba.org.au/index.asp?sectionID=39&newsID=982&display=news
> >>>> ). The new entry in the au-Melbourne file for channel seven should
> >>>> be: # Seven
> >>>> T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> >>>>
> >>>> I attached the complete updated file anyway.
> >>>> 	Jeff
> >>>
> >>> They are a pain.
> >>>
> >>> Anyway, according to the web site that you quoted, all tuners that
> >>> comply with Australian standards will cope without adjustment.
> >>> Unfortunately not all tuners comply with Australian standards.  :-(
> >>>
> >>> Presumably all au-tuning_files should have their channel 7 entry
> >>> updated. Can this be done at the data base end, or do all files have
> >>> to be re-submitted?  Also the GI in Brisbane is noted as changing as
> >>> well.
> >>
> >> I can confirm that the au-Brisbane scan file needs to change. It works
> >> now for me with the same channel 7 line that Jeff included above. Scan
> >> wasn't finding channel 7 without the change.
> >
> > Did you just change fec_hi, or did you change the Guard Interval as
> > well?  The quoted web page states that the GI is now 1/16.  (It is
> > possible that your card is smart enough to sort out GI by itself,
> > but not fec_hi.)
>
> Sorry about the belated reply.... Yes, I changed the GI to 1/16.

Bruce, 

That's OK.  

Do you feel competent to submit an updated file for Brisbane?  


-- 
sig goes here...
Peter D.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
