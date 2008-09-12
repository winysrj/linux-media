Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KdySq-0006FV-Mh
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 04:32:54 +0200
From: Andy Walls <awalls@radix.net>
To: Glenn McGrath <glenn.l.mcgrath@gmail.com>
In-Reply-To: <141058d50809092040m6ccbcer2ff26cf109a63682@mail.gmail.com>
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<1220993974.17270.22.camel@localhost>
	<d9def9db0809091414t5953e696s521aa2f7525d182d@mail.gmail.com>
	<1221007328.2647.53.camel@morgan.walls.org>
	<141058d50809092040m6ccbcer2ff26cf109a63682@mail.gmail.com>
Date: Thu, 11 Sep 2008 22:32:37 -0400
Message-Id: <1221186757.2648.78.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to measure API "goodness"?
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

On Wed, 2008-09-10 at 13:40 +1000, Glenn McGrath wrote:
> On Wed, Sep 10, 2008 at 10:42 AM, Andy Walls <awalls@radix.net> wrote:
> >
> > This leads into something I've been thinking about the past few days
> > that's probably worth discussion out loud:
> >
> > What are the attributes to measure for comparing APIs or API proposals?
> > How can each attribute be measure objectively (if possible)?
> > What are the units for each measurement attribute?
> > What weight should be given to each attribute?

> > Given the back and forth on the list, I thought some discussion on how
> > one might perform a technical evaluation of an API may be productive.
> > The list conversations on certain point aspects of API proposals, would
> > benefit from rough concensus on how API "goodness" should be measured in
> > the first place, instead of arguing over perceptions/measurements that
> > may not be that important to a "good" API.
> >
> >
> > Regards,
> > Andy
> 
> Well said,

Thank you.


>  but can the goodness of an API even be measured ?


IMO, sure.  Objective, consistent, and (reasonably) repeatable
assessment may be tricky.

Is it worth the work?  Maybe not.  I depends on the payoff.



> The more i learn about programming the more i think software
> blueprints (to avoid saying design) are created rather than designed,
> and that deep down this is a discussion of science vs art.

I suspect that had this API project started by going through a thorough
development waterfall:

   High Level Requirements capture
   High Level Design
   High Level Design Review
   Functional allocation/breakdown

      Detailed Requirements capture
      Detailed Design
      Test Development
      Detailed Design Review
      Code
      Compile
      Code Review
      Unit Test
   
   Integration Test
   System Test


then all these list discussions would have been moot and there would
only be the one, well reviewed API, *especially* with the proper parties
participating in the design reviews.

Although it may still have been 2 years to get something... ;)


On art vs. engineering:

Software development can be undertaken as a rigorous engineering
discipline, but doing so can take all the enjoyment out of it for the
developers.

Treating software development as an undisciplined art yields results and
schedules that are difficult to reliably predict, manage, and control;
so managing the project costs and software quality becomes a real
problem.



> For example, to many the 5 measurable attributes you specify come
> under the subjective value of beauty,

Actually I'd imagine the attributes would end up being assessed/scored
subjectively by individuals.  With enough people, with a minimum level
of experience, performing an assessment, averaging the subjective scores
for one attribute and computing a variance would come close to a good
objective assessment of an API against any particular attribute.

I'd also contend that beauty is a natural consequence of scoring high on
a majority of the attributes and not the other way around.  But I agree
with you that there is a correlation.



>  people will quickly decide if
> they personally like an API or not, and that is likely to determine
> how useful it is.

I'll agree.  There are subsets of people in any assessment with their
own agendas or interests.  In this case, I can hypothesize groups with
differing motivations that may wish to add weight to certain other
attributes for calling an API good:


1. users: usually want the API to support their particular hardware as
soon as possible with minimal effort on their part

2. kernel devs: may want an API that is easy to adopt and maintain,
especially on the "inward facing" side.  Also want to enhance the linux
kernel functionality in the long run.

3. people with some financial interest in supporting customers or
employers:  may want their customer's or employer's hardware and user
apps supported as soon as possible.

4. application writers: may often prefer an API with minimal complexity
to use that also doesn't force them to rework a lot of existing code.


The hypothesized groups above have desires to satisfy differing short to
mid terms goals.  An API ideally should be selected to guarantee gains
in the long term. IMO



> If you do find any references on measuring an API (or a design) i
> would love to read them.

I haven't had time to look yet.  Crazy week at work.  I doubt I'll find
anything anyway. :P


Regards,
Andy


> Glenn



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
