Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m91IOctR016483
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 14:24:38 -0400
Received: from topnetmail3.outgw.tn (topnetmail3.outgw.tn [193.95.97.76])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m91IOP5A007014
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 14:24:25 -0400
Received: from mail1.topnet.tn (smtp.topnet.tn [213.150.176.204])
	by tounes-27.ati.tn (Postfix) with ESMTP id C66E625B0154
	for <video4linux-list@redhat.com>;
	Wed,  1 Oct 2008 20:24:21 +0200 (CEST)
From: Nicolas <progweb@free.fr>
To: David Ellingsworth <david@identd.dyndns.org>
In-Reply-To: <30353c3d0810010928u2a4f17d7y2f922905659982ec@mail.gmail.com>
References: <30353c3d0809301604p393ee1bbh29d8b9f3be424f22@mail.gmail.com>
	<34E2ED35C2EB67499BA8591290AF20D506B237@pnd-iet-msg.wipro.com>
	<30353c3d0810010928u2a4f17d7y2f922905659982ec@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 01 Oct 2008 20:24:20 +0200
Message-Id: <1222885460.5488.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, mchehab@redhat.com
Subject: Re: mic issue in usb webcam
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

Hi,

I'm the maintener of the stk11xx project. stk11xx can't integrated to
kernel tree, because I use image process in the driver (bayer2rgb /
bayer2yuv...). But stk11xx support several camera who aren't supported
by stkwebcam.

So, stkwebcam uses the work from this project (for the device 174f:a311)

As far as I'm concerned, I have never seen a camera (based on the syntek
chipsets) used the mic interface. Whereas the syntek chipsets have a USB
audio interface.

The mic is plugged to the sound card (by hardware).

So it's quiet difficult to make the devel and add the audio support ;
because we haven't datasheet and we can't make tests.

Regards,

Nicolas VIVIEN

Le mercredi 01 octobre 2008 à 12:28 -0400, David Ellingsworth a écrit :
> On Wed, Oct 1, 2008 at 2:59 AM,  <desktop1.peg@wipro.com> wrote:
> > Hi I m using Logitech webcam in RHEL5.0, its working fine but the
> > inbuilt mic is not working when I record a video. Pls find a solution.
> >
> 
> The mic input is not currently supported by the driver. I do not own a
> camera that works with this driver and am therefore unable to make any
> additions to it nor do I have any interest in doing so at this time.
> The patches I recently submitted merely correct issues I identified
> while reviewing the driver's source. If you want mic support you will
> either have to add support yourself or persuade Jamie, the official
> maintainer, to do so.
> 
> Regards,
> 
> David Ellingsworth
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
-- 
Nicolas VIVIEN

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
