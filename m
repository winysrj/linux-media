Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SKcHw6031342
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 16:38:17 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9SKbueT027547
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 16:37:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 28 Oct 2008 21:37:49 +0100
References: <490525EA.4020608@rogers.com>
	<37219a840810281129k3a713b75w6419b7b5c526df2f@mail.gmail.com>
	<20081028192739.GA23476@linuxtv.org>
In-Reply-To: <20081028192739.GA23476@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810282137.49214.hverkuil@xs4all.nl>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>,
	CityK <cityk@rogers.com>
Subject: Re: [linux-dvb] Announcement: wiki merger and some loose ends
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

On Tuesday 28 October 2008 20:27:39 Johannes Stezenbach wrote:
> On Tue, Oct 28, 2008 at 02:29:00PM -0400, Michael Krufky wrote:
> > What we would like to do is leave the video4linux and linux-dvb
> > mailing lists as user lists, create a new -devel mailing list, and
> > redirect v4l-dvb-maintainer to the new list.  (Probably hosted on
> > vger, but that hasnt yet been determined)
> >
> > The devel list would be an open list for developers only.  Any
> > tech-support related stuff would remain on the lists that are still
> > used today.
> >
> > Specifically, we wanted to move the "v4l-dvb-maintainer" list to
> > somewhere with spam filtering and turn this into a list where all
> > development discussions and pull requests can take place.  We want
> > a separation between user requests and developer discussion, so
> > merging everything into a single list is not the direction that we
> > want to take.
>
> Personally I'm generally not in favour of splitting an
> open source community in "users" and "developers", but
> I guess I'm the odd man out with that POV...

I think that keeping only one list will generate too much traffic. I 
find it useful to have separate user and devel lists (provided people 
do read the user list and not just the devel list).

> However, similar to that there should be ONE developer
> list, I think there should be ONE user list, and not
> two. Maybe we should just shut linux-dvb down and ask
> users to subscribe to the video4linux list? Or do
> people think it's still useful to have distinct lists
> for analog and digital?

I'm very much in favor of having one v4l-dvb-user and one v4l-dvb-devel 
list. I've always disliked it that there were separate lists. Certainly 
the average user doesn't care whether his card is digital or analog or 
both, so one user list is very much desired IMHO.

> Either way, IMHO you can't go wrong with moving v4l-dvb-maintainer
> to vger so if you agree I'd like to encourage you to go forward with
> that.

I agree as well. As far as I am concerned we should end up with two 
lists on vger: v4l-dvb-user and v4l-dvb-devel. Should be a nice 
improvement, certainly for the video4linux list which is still with 
redhat.com and with hard to access archives.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
