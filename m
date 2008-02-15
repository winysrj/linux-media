Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FIMsjb032618
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:22:54 -0500
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FIMVs9016081
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 13:22:31 -0500
Received: by wx-out-0506.google.com with SMTP id t16so764443wxc.6
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 10:22:26 -0800 (PST)
Message-ID: <1e5fdab70802151022k3477f538j3ce0b56d7b462d6c@mail.gmail.com>
Date: Fri, 15 Feb 2008 10:22:25 -0800
From: "Guillaume Quintard" <guillaume.quintard@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080215104945.4e6fe998@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
	<20080207181136.5c8c53fc@gaivota>
	<1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
	<20080211104821.00756b8e@gaivota>
	<1e5fdab70802141534o194c79efu1ed974734878c052@mail.gmail.com>
	<20080215104945.4e6fe998@gaivota>
Cc: video4linux-list@redhat.com
Subject: Re: Question about saa7115
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

On Fri, Feb 15, 2008 at 4:49 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Thu, 14 Feb 2008 15:34:22 -0800
>  At the current drivers, most of the API functions are handled by the bridge
>  driver. So, only a subset of saa7115 features is needed for those devices. As a
>  rule, we generally try not to add code on kernel drivers that aren't used by
>  other kernel drivers.
>

uh, sorry, but what is a bridge driver ? I've never heard of it, and
could find any help on the web.

>  Yet, some functions shouldn't be on saa7115, like, for example:
>         buffer handling - specific to the way it is connected;
>         audio control and decoding - should be associated to an audio chip;
>
>  I don't know the implementation details of your driver. If you intend to submit
>  your driver for its addition on kernel, feel free to propose the addition of
>  new features to saa7115, and post to the list. Maybe your job will help also
>  other users (for example, saa7115 driver doesn't work with Osprey 560
>  - I'm not sure where's the issue).

sure, I'll do that, once it'll be ready, and there's a long way to go
before that happens :-)

regards.

-- 
Guillaume

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
