Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m517KXnq027210
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 03:20:33 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m517K8xl028072
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 03:20:22 -0400
Received: by yw-out-2324.google.com with SMTP id 5so215964ywb.81
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 00:20:08 -0700 (PDT)
Message-ID: <37219a840806010020j2ff83255g32a1625ab9ab8383@mail.gmail.com>
Date: Sun, 1 Jun 2008 03:20:08 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Jason Pontious" <jpontious@gmail.com>
In-Reply-To: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
Cc: video4linux-list@redhat.com
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

On Thu, May 29, 2008 at 6:57 PM, Jason Pontious <jpontious@gmail.com> wrote:
> After getting upgraded to the latest v4l-dvb repository I am no longer able
> to get any analog channels from my Kworld 115. (I finally broke down and
> installed 2.6.25 kernel in Ubuntu).
>
> Before I was getting analog channels via the top rf input.  Now I get no
> channels regardless if i set atv_input tuner_simple module setting.  Digital
> channels are not affected just analog in this.  I get no errors from dmesg.
>
> Any Ideas?

Set tuner-simple debug=1 -- this will cause the driver to tell you
which input is being used for what purpose at driver startup.  This
should help you to debug the issue on your end.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
