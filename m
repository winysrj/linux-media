Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DMomj2018280
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 17:50:48 -0500
Received: from mail.isp.novis.pt (onyx.ip.pt [195.23.92.252])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DMoPco023695
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 17:50:26 -0500
From: Ricardo Cerqueira <v4l@cerqueira.org>
To: linux-dvb-maintainer@linuxtv.org
In-Reply-To: <Pine.LNX.4.58.0802131349400.6264@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
	<Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
	<20080213155352.06d966cd@gaivota>
	<Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
	<1202935004.17260.54.camel@localhost.localdomain>
	<Pine.LNX.4.58.0802131349400.6264@shell2.speakeasy.net>
Date: Wed, 13 Feb 2008 22:50:18 +0000
Message-Id: <1202943018.4064.37.camel@frolic>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
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

On Wed, 2008-02-13 at 13:53 -0800, Trent Piepho wrote:
> On Wed, 13 Feb 2008, Ricardo Cerqueira wrote:
> > On Wed, 2008-02-13 at 10:45 -0800, Trent Piepho wrote:
> > > On Wed, 13 Feb 2008, Mauro Carvalho Chehab wrote:
> > > > On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
> > > > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > >
> > Read the code that was actually committed: here's a helpful link:
> >
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=41a93616082af630e7242cba766a161d7847560b
> 
> I did.  Looks like there is a race on access to core->active_ref.

You're right, I missed that. A patch has already been sent to the
V4L/DVB list.

> You could also CC the relevant parties.  Unless you're hoping they won't
> notice something.

Sorry, but no. I actively try *not* to send duplicate e-mails to people
unless they specifically request it.

--
RC


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
