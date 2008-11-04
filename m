Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA48Lmhs013217
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 03:21:48 -0500
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA48LXUB003773
	for <video4linux-list@redhat.com>; Tue, 4 Nov 2008 03:21:34 -0500
Message-ID: <4910070D.6000901@hhs.nl>
Date: Tue, 04 Nov 2008 09:25:49 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Colin Brace <cb@lim.nl>
References: <490F2730.9090703@lim.nl> <490F4ABB.1050608@hhs.nl>
	<1225746037211-1451395.post@n2.nabble.com>
In-Reply-To: <1225746037211-1451395.post@n2.nabble.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] xawtv 'webcam' & uvcvideo webcam: ioctl error
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

Colin Brace wrote:
> 
> Hans de Goede wrote:
>> I think I do, xawtv contains a few v4l2 handling bugs. This patch fixes
>> them 
>> and most likely fixes your issue:
>> http://cvs.fedoraproject.org/viewvc/devel/xawtv/xawtv-3.95-fixes.patch?revision=1.1
>>
> 
> Thanks, Hans. I downloaded and applied that patch to the source. However
> when I go to compile it, 'make' returns an error:
> 

Well these errors are completely unrelated from the patch I've send you. xawtv 
has been unmaintained upstream for a while, so you want to start with the 
sources as provided by your distro, not with an pristine upstream tarbal.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
