Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASFXNvI022374
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 10:33:23 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASFX9RG008733
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 10:33:10 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1462799wfc.6
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 07:33:09 -0800 (PST)
Message-ID: <26aa882f0811280733j3d22c025ud2d8857554caf61b@mail.gmail.com>
Date: Fri, 28 Nov 2008 10:33:09 -0500
From: "Jackson Yee" <jackson@gotpossum.com>
To: video4linux-list@redhat.com
In-Reply-To: <82224.60450.qm@web39708.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82224.60450.qm@web39708.mail.mud.yahoo.com>
Subject: Re: Unable to achieve 30fps using 'read()' in C
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

Wei,

You will only get half rate or worse using read() because there is no
buffer queue for the frames. Please use streaming IO to get all of the
frames that your device produces as in the API example:

http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/a16706.htm

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

On Fri, Nov 28, 2008 at 3:02 AM, wei kin <kin2031@yahoo.com> wrote:
> Hi all, I am new in v4l programming. What I did in my code is I used 'read( )' in C programming to read images from my Logitech Quickcam Express. My problem is I can't get 30frames per second, what I got is just 5fps when I loop and read for 200times. Do anyone know why is it under performance? Thanks
>
> Rgds,
> nik2031

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
