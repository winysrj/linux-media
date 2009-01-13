Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <37219a840901130600i659f8f77x43f7e04c063dff48@mail.gmail.com>
Date: Tue, 13 Jan 2009 09:00:14 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Uri Shkolnik" <urishk@yahoo.com>
In-Reply-To: <123177.82279.qm@web110805.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <123177.82279.qm@web110805.mail.gq1.yahoo.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Introduction
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

On Mon, Jan 12, 2009 at 10:33 AM, Uri Shkolnik <urishk@yahoo.com> wrote:
> Mauro,
>
> My name is Uri Shkolnik, I work at Siano Mobile Silicon as a software architect.
>
> I tried to get in touch with you lately, but I had probably used the wrong email address, so forgive me for contacting by replying to a post of yours to the one of the LinuxTV mailing lists...
>
> Siano develops DTV chip-sets (multi-standards, multi-interfaces) which are used by Siano's many customers and partners.
> Couple of years ago, our Linux support was minimal, but that situation has changed, and proximately a year ago, we started to get more an more demand for Linux kernel support, and we started to offer a minimal set of drivers.
>
> At the beginning, we used the excellent services given to us by Michael Krufky, and actually everything we want to publish went through him.
>
> Recently, the number of Siano-based Linux projects and products increased significantly.
>
> With the fast growing number of customers and projects, the number of additional interfaces, DTV standards and changes fast growth we needed a different approach.
>
> On mid-November, we took the second approach which is suggested at the README.patches file, and submitted the patches to the linux-dvb mailing list, till today, except some people who took those patches and apply them locally on their systems, nothing has been done with those patches, and the main mercurial tree has not been updated with them.
>
> The current state is that a huge gap has been opened between the LinuxTV repository (and from it to the Linux kernel git) offering and what we have at Siano.
>
> We would like to close this gap ASAP and maintain an on-going, easy synchronizing process.
>
> It seems that the best method to archive this goal is to have maintainer permissions on media/dvb/siano directory.


Thank you for your email, Uri.

First off, I'd like to thank Uri and Siano Mobile Silicon for their
ongoing involvement and contributions to the DVB subsystem of the
Linux kernel.

I've been very busy lately, and haven't had as much time to have the
same presence on the mailing lists as I had in the past.  Nonetheless,
I am still rather actively working within the v4l-dvb development
tree.

Uri has sent a patch series to me already a few weeks ago.  I haven't
yet checked the series that he sent this morning, to see whether or
not these are the same patches that I already have.

I am already in the process of reviewing the patch series, and it
might take two weeks or so before I will be able to post a merged tree
with feedback.

Please be patient, Uri -- We want to keep the code in sync with the
Siano code as much as possible.  Please just understand that the
review / testing / merge process takes some time.

I will be in touch again shortly.

Best Regards,

Mike Krufky

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
