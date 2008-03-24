Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1JdoD7-0003v4-CV
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 16:03:44 +0100
Received: by wr-out-0506.google.com with SMTP id c30so1818535wra.14
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 08:03:36 -0700 (PDT)
Message-ID: <c8b4dbe10803240803q78371b16k552360fb3e68714c@mail.gmail.com>
Date: Mon, 24 Mar 2008 15:03:35 +0000
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Simon Kenyon" <simon@koala.ie>
In-Reply-To: <1206220314.19863.4.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206210385.19509.3.camel@localhost>
	<1206220314.19863.4.camel@localhost>
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

On 3/22/08, Simon Kenyon <simon@koala.ie> wrote:
>
> On Sat, 2008-03-22 at 18:26 +0000, Simon Kenyon wrote:
> > will anything be done about merging em28xx support into the mainline?
> > it has been quite a while since markus picked up his ball and went off
> > to play elsewhere
> >
> > is it really that hard to merge?
>
> by that i really mean em2880-dvb
> --
> simon

Hi,
I think the broad answer is no, it's probably not particularly hard to merge, at least not from a technical point of view. It's relatively short, and most of the changes required to stuff like the zl10353 driver are already there because of other xc3028-based cards that need them. I assume the main issue is that no-one wants to do it.

(Also, I finally got around to backporting the changes required to make v4l-dvb-makomk work on 2.6.24 - I was hoping it'd be obsolete by now, but I'm guessing not. It wasn't as bad as I was expecting, but it's only going to get worse, since the code in there is still just as outdated.)

Aidan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
