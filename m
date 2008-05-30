Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4UFg6j3011003
	for <video4linux-list@redhat.com>; Fri, 30 May 2008 11:42:06 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4UFfudk025910
	for <video4linux-list@redhat.com>; Fri, 30 May 2008 11:41:56 -0400
Received: by py-out-1112.google.com with SMTP id a29so2029pyi.0
	for <video4linux-list@redhat.com>; Fri, 30 May 2008 08:41:55 -0700 (PDT)
Message-ID: <f50b38640805300841q1a4f05c3udbf0d0f7f19cdb6e@mail.gmail.com>
Date: Fri, 30 May 2008 11:41:54 -0400
From: "Jason Pontious" <jpontious@gmail.com>
To: "David Engel" <david@istwok.net>, video4linux-list@redhat.com
In-Reply-To: <20080530145830.GA7177@opus.istwok.net>
MIME-Version: 1.0
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re: Kworld 115-No Analog Channels
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, May 30, 2008 at 10:58 AM, David Engel <david@istwok.net> wrote:

> On Thu, May 29, 2008 at 06:57:03PM -0400, Jason Pontious wrote:
> > After getting upgraded to the latest v4l-dvb repository I am no longer
> able
> > to get any analog channels from my Kworld 115. (I finally broke down and
> > installed 2.6.25 kernel in Ubuntu).
>
> Which drivers are you really using, 2.6.25 or latest v4l-dvb from
> Mercurial?
>
> > Before I was getting analog channels via the top rf input.  Now I get no
> > channels regardless if i set atv_input tuner_simple module setting.
>  Digital
> > channels are not affected just analog in this.  I get no errors from
> dmesg.
> >
> > Any Ideas?
>
> I ran into a similar (probably the same) problem last week.  My search
> of the list archives revealed a known tuner detection regression in
> 2.6.25.  It's supposed to be fixed in Mercurial but I didn't test it
> because it was simpler to just go back to 2.6.24.x.  I don't know why
> the fix hasn't made it into 2.6.25.x yet.
>
> David
> --
> David Engel
> david@istwok.net



I am using the current v4l-dvb from mercurial as the latest there now has a
feature to allow you to select the rf input for analog channels which I
would like to have.  I upgraded to 2.6.25 in Ubuntu because of the way
Ubuntu is currenlty handling their kernel modules doesn't allow for an easy
compile of the drivers from mercurial.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
