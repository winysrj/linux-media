Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KIQ6hQ030007
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 14:26:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9KIPtTE025401
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 14:25:56 -0400
Date: Mon, 20 Oct 2008 20:25:36 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: David Ellingsworth <david@identd.dyndns.org>
Message-ID: <20081020182536.GA1750@daniel.bse>
References: <48FC8DF1.8010807@linos.es> <20081020161436.GB1298@daniel.bse>
	<48FCB94C.90505@linos.es>
	<30353c3d0810201023j3464c9b5udc58b0c0966ad0f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30353c3d0810201023j3464c9b5udc58b0c0966ad0f2@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: bttv 2.6.26 problem
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

On Mon, Oct 20, 2008 at 01:23:25PM -0400, David Ellingsworth wrote:
> On Mon, Oct 20, 2008 at 1:01 PM, Linos <info@linos.es> wrote:
> > Daniel Glöckner escribió:
> >>  vmm.height=352;
> >>  vmm.width=288;

D'oh!
I swapped width and height..

> I believe the changes Daniel suggested would have to be applied to the
> source of helix producer in order to work.

I didn't test helix producer, but with my simple test app and correct
width and height it works.

> None the less, the proper
> fix would be to fix the associated bug in the driver which is the real
> cause of the problem.

Agreed

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
