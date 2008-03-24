Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Jdpyt-0007wd-OD
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 17:57:08 +0100
Received: by rv-out-0910.google.com with SMTP id b22so1830641rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 09:56:58 -0700 (PDT)
Message-ID: <d9def9db0803240956p10b26d0bs93763253c7902806@mail.gmail.com>
Date: Mon, 24 Mar 2008 17:56:58 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Aidan Thornton" <makosoft@googlemail.com>
In-Reply-To: <c8b4dbe10803240803q78371b16k552360fb3e68714c@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206210385.19509.3.camel@localhost>
	<1206220314.19863.4.camel@localhost>
	<c8b4dbe10803240803q78371b16k552360fb3e68714c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] now that v4l-dvb-makomk will not work on 2.6.24
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

On 3/24/08, Aidan Thornton <makosoft@googlemail.com> wrote:
> On 3/22/08, Simon Kenyon <simon@koala.ie> wrote:
> >
> > On Sat, 2008-03-22 at 18:26 +0000, Simon Kenyon wrote:
> > > will anything be done about merging em28xx support into the mainline?
> > > it has been quite a while since markus picked up his ball and went off
> > > to play elsewhere
> > >
> > > is it really that hard to merge?
> >
> > by that i really mean em2880-dvb
> > --
> > simon
>
> Hi,
> I think the broad answer is no, it's probably not particularly hard to
> merge, at least not from a technical point of view. It's relatively short,
> and most of the changes required to stuff like the zl10353 driver are
> already there because of other xc3028-based cards that need them. I assume
> the main issue is that no-one wants to do it.
>

There's overall alot to do and that's a reason why I'm not even trying
to push a merge at this time. Documentation and the mailinglist is
available on mcentral.de it will give a deep insight about what's
going on at the moment.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
