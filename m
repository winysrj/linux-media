Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JQKSd-0000Zj-0e
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 11:39:59 +0100
Received: by fg-out-1718.google.com with SMTP id 22so699362fge.25
	for <linux-dvb@linuxtv.org>; Sat, 16 Feb 2008 02:39:58 -0800 (PST)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 16 Feb 2008 11:39:51 +0100
References: <20080120194031.47ad683c@jeff.localdomain>
	<47B03CBA.3080302@gmail.com>
	<200802162131.02775.peter_s_d@fastmail.com.au>
In-Reply-To: <200802162131.02775.peter_s_d@fastmail.com.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802161139.51508.christophpfister@gmail.com>
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

Am Samstag 16 Februar 2008 schrieb Peter D.:
> On Monday 11 February 2008, Bruce Schultz wrote:
> > On 21/01/08 08:13, Peter D. wrote:
> > > On Monday 21 January 2008, Bruce Schultz wrote:
<snip>
> > >> I can confirm that the au-Brisbane scan file needs to change. It works
> > >> now for me with the same channel 7 line that Jeff included above. Scan
> > >> wasn't finding channel 7 without the change.
> > >
> > > Did you just change fec_hi, or did you change the Guard Interval as
> > > well?  The quoted web page states that the GI is now 1/16.  (It is
> > > possible that your card is smart enough to sort out GI by itself,
> > > but not fec_hi.)
> >
> > Sorry about the belated reply.... Yes, I changed the GI to 1/16.
>
> Bruce,
>
> That's OK.
>
> Do you feel competent to submit an updated file for Brisbane?

I've already updated the files in the repo (the au-* files containing the 
string "seven"), including the 1/8-->1/16 change for Brisbane.

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
