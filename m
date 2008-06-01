Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m517IuPU026314
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 03:18:56 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m517IkVZ027317
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 03:18:46 -0400
Received: by yw-out-2324.google.com with SMTP id 5so215869ywb.81
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 00:18:45 -0700 (PDT)
Message-ID: <37219a840806010018m342ff1bh394248e62e0a8807@mail.gmail.com>
Date: Sun, 1 Jun 2008 03:18:45 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "David Engel" <david@istwok.net>
In-Reply-To: <20080530145830.GA7177@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
Cc: video4linux-list@redhat.com, Jason Pontious <jpontious@gmail.com>
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
>> After getting upgraded to the latest v4l-dvb repository I am no longer able
>> to get any analog channels from my Kworld 115. (I finally broke down and
>> installed 2.6.25 kernel in Ubuntu).
>
> Which drivers are you really using, 2.6.25 or latest v4l-dvb from
> Mercurial?
>
>> Before I was getting analog channels via the top rf input.  Now I get no
>> channels regardless if i set atv_input tuner_simple module setting.  Digital
>> channels are not affected just analog in this.  I get no errors from dmesg.
>>
>> Any Ideas?
>
> I ran into a similar (probably the same) problem last week.  My search
> of the list archives revealed a known tuner detection regression in
> 2.6.25.  It's supposed to be fixed in Mercurial but I didn't test it
> because it was simpler to just go back to 2.6.24.x.  I don't know why
> the fix hasn't made it into 2.6.25.x yet.

Which fix?  What problem does it fix?  More details, please :-)

-Mike

P.S. ...  I respond quicker if you cc me.  ;-)  (I should have added
that to my last email, not this one)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
