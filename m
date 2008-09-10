Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <glenn.l.mcgrath@gmail.com>) id 1KdGYp-00051X-SS
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 05:40:09 +0200
Received: by ti-out-0910.google.com with SMTP id w7so1551553tib.13
	for <linux-dvb@linuxtv.org>; Tue, 09 Sep 2008 20:40:03 -0700 (PDT)
Message-ID: <141058d50809092040m6ccbcer2ff26cf109a63682@mail.gmail.com>
Date: Wed, 10 Sep 2008 13:40:03 +1000
From: "Glenn McGrath" <glenn.l.mcgrath@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1221007328.2647.53.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<1220993974.17270.22.camel@localhost>
	<d9def9db0809091414t5953e696s521aa2f7525d182d@mail.gmail.com>
	<1221007328.2647.53.camel@morgan.walls.org>
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

On Wed, Sep 10, 2008 at 10:42 AM, Andy Walls <awalls@radix.net> wrote:
>
> This leads into something I've been thinking about the past few days
> that's probably worth discussion out loud:
>
> What are the attributes to measure for comparing APIs or API proposals?
> How can each attribute be measure objectively (if possible)?
> What are the units for each measurement attribute?
> What weight should be given to each attribute?
>
> I've seen several suggestions in the threads already for attributes that
> could be considered in a comparison:
>
> 1. Complexity (internal to the kernel)
> 2. Complexity (visible to the application)
> 3. Extensibility/Future adaptability
> 4. Implementation maturity (if one exists already)
> 5. Number of currently supported devices
> 6. Number of applications already using an implementation
> 7. Status of an implementation in the kernel (already there, leverages
> or consistent with another API, etc.)
> 8. Ease of use for applications
> 9. Elegance/Beauty
>
> I'm sure I've missed some that were discussed, but it doesn't seem that
> everything in the list above all are relevant to an API comparison, and
> there could very well be things missing from the list.
>
> I was going to look for some CS journal article which may provide
> insight into metrics for performing such a comparison, but I haven't
> found the time.
>
>
> But I was thinking it reasonable that metrics, that get the most weight
> in an evaluation, be in line with the purpose of an API:
>
>   Provide a well defined interface, that is consistent over time, which
>   applications can call and whose source code can remain insulated from
>   differences and changes in the underlying service, for some
>   (unspecified) period of time into the future.
>
> (I made that up.)
>
>
> That leads me to think that maybe the most important measures should be:
>
> 1. Projected invariance of the application facing side over time.
>
> 2. The amount of application code that would be forced to change given
> forseeable changes or growth in the API due to change or growth in the
> underlying service.
>
> 3. The transparency of differences in the underlying service (e.g.
> capture devices from different manufacturers or using different
> chipsets) to the applications calling the API.
>
> 4. The functionality provided to applications to deal with differences
> that cannot be made transparent to the application.
>
> 5. The feasibility of maintaining the desirable properties of an API
> while kernel software maintenance move forward.
>
>
> Beauty, complexity, existing implementations (out of kernel), and ease
> of use don't really rank, given my made up definition of an API.
> (libX11 isn't an easy to use API, but it has stood the test of time.)
>
> Given the back and forth on the list, I thought some discussion on how
> one might perform a technical evaluation of an API may be productive.
> The list conversations on certain point aspects of API proposals, would
> benefit from rough concensus on how API "goodness" should be measured in
> the first place, instead of arguing over perceptions/measurements that
> may not be that important to a "good" API.
>
>
> Regards,
> Andy

Well said, but can the goodness of an API even be measured ?

The more i learn about programming the more i think software
blueprints (to avoid saying design) are created rather than designed,
and that deep down this is a discussion of science vs art.

For example, to many the 5 measurable attributes you specify come
under the subjective value of beauty, people will quickly decide if
they personally like an API or not, and that is likely to determine
how useful it is.

If you do find any references on measuring an API (or a design) i
would love to read them.


Glenn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
