Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m91GTODx029632
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 12:29:24 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m91GSPdd028430
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 12:29:06 -0400
Received: by rv-out-0506.google.com with SMTP id f6so616784rvb.51
	for <video4linux-list@redhat.com>; Wed, 01 Oct 2008 09:28:25 -0700 (PDT)
Message-ID: <30353c3d0810010928u2a4f17d7y2f922905659982ec@mail.gmail.com>
Date: Wed, 1 Oct 2008 12:28:25 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: desktop1.peg@wipro.com
In-Reply-To: <34E2ED35C2EB67499BA8591290AF20D506B237@pnd-iet-msg.wipro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0809301604p393ee1bbh29d8b9f3be424f22@mail.gmail.com>
	<34E2ED35C2EB67499BA8591290AF20D506B237@pnd-iet-msg.wipro.com>
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

On Wed, Oct 1, 2008 at 2:59 AM,  <desktop1.peg@wipro.com> wrote:
> Hi I m using Logitech webcam in RHEL5.0, its working fine but the
> inbuilt mic is not working when I record a video. Pls find a solution.
>

The mic input is not currently supported by the driver. I do not own a
camera that works with this driver and am therefore unable to make any
additions to it nor do I have any interest in doing so at this time.
The patches I recently submitted merely correct issues I identified
while reviewing the driver's source. If you want mic support you will
either have to add support yourself or persuade Jamie, the official
maintainer, to do so.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
