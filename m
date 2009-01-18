Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web110804.mail.gq1.yahoo.com ([67.195.13.227])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1LOVTP-0008BA-SS
	for linux-dvb@linuxtv.org; Sun, 18 Jan 2009 12:05:49 +0100
Date: Sun, 18 Jan 2009 03:05:12 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
To: =?iso-8859-1?Q?St=E5le_Helleberg_/_drc=2Eno?= <staale@drc.no>
In-Reply-To: <20090116101702.149275vsbwc7y45q@91.189.121.183>
MIME-Version: 1.0
Message-ID: <161813.29307.qm@web110804.mail.gq1.yahoo.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Siano subsystem (DAB/DMB support) library for linux?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>




--- On Fri, 1/16/09, St=E5le Helleberg / drc.no <staale@drc.no> wrote:

> From: St=E5le Helleberg / drc.no <staale@drc.no>
> Subject: Re: Siano subsystem (DAB/DMB support) library for linux?
> To: urishk@yahoo.com
> Date: Friday, January 16, 2009, 11:17 AM
> Quoting "Uri Shkolnik" <urishk@yahoo.com>:
> =

> >
> >
> >
> > --- On Thu, 1/15/09, St=E5le Helleberg / drc.no
> <staale@drc.no> wrote:
> >
> >> From: St=E5le Helleberg / drc.no
> <staale@drc.no>
> >> Subject: Siano subsystem (DAB/DMB support) library
> for linux?
> >> To: urishk@yahoo.com
> >> Cc: staale.helleberg@gmail.com
> >> Date: Thursday, January 15, 2009, 1:16 AM
> >> Dear Uri,
> >>
> >> Firstly, let me thank you and Siano for your
> effort in
> >> making your products available for Linux users. It
> is much
> >> appreciated, and much has changed since I
> contacted Siano
> >> early last year regarding a similar request.
> >>
> >> I contact you to ask if it's possible to get a
> copy of
> >> your library and headers for talking with the
> subsystem in
> >> C/C++. I've downloaded and applied the patches
> - and the
> >> module loads in dmb mode and looks promising.
> >>
> >> The reason for this request is that I'm
> currently
> >> studying the DAB standard for a another project. I
> need to
> >> log and analyze the complete datastream from the
> air - to
> >> study and understand the building blocks. I will
> try to
> >> create a parser, but I can't promise that I
> will
> >> succeed. If you have any samples regarding use of
> the API
> >> (tuning to frequency, opening/reading/closing etc)
> and other
> >> documentation, it will also be much appreciated.
> >>
> >> Thank you in advance,
> >>
> >> Best Regards
> >>
> >> Staale Helleberg
> >> drc.no
> >
> >
> > Dear Staale,
> >
> > Please find the requested files at our ftp site.
> >
> > Address: fx.siano-ms.com
> > Username: sms_linux
> > Password: sms_linux
> >
> >
> > Best regard,
> >
> > Uri Shkolnik
> >
> >
> >
> >
> =

> =

> Dear Uri,
> =

> Thank you again for the library and information. I made a
> small  =

> testprogram yesterday - and was able to communicate, tune
> and receive  =

> dab/dmb services with next to no problems :)  Very well
> done!
> =

> As mentioned in my earlier request, for my project I need
> access to  =

> the unmodifed incomming bitstream (without
> modification/filtering).  =

> I'm sorry to say that I could not find any functions in
> the headers  =

> that could be used. Do you have any tips on how to achieve
> this?
> =

> Thanks in advance
> =

> Best Regards,
> =

> Staale Helleberg
> drc.no

I re-checked with our DAB team, and the answer is that you can't get the ra=
w multiplex.

Sorry,

Uri


      =


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
