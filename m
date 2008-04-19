Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3JDoRPe012587
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:50:27 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3JDn5ik007077
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:49:53 -0400
Received: by ti-out-0910.google.com with SMTP id 11so187102tim.7
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 06:49:03 -0700 (PDT)
Message-ID: <998e4a820804190643o1956fb6dxa90748fc6b6a8cbd@mail.gmail.com>
Date: Sat, 19 Apr 2008 21:43:01 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804181621560.5725@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
	<998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
	<Pine.LNX.4.64.0804132124100.6622@axis700.grange>
	<998e4a820804161747m6d8377b1k7481aaff7d081259@mail.gmail.com>
	<Pine.LNX.4.64.0804171824130.6716@axis700.grange>
	<998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
	<Pine.LNX.4.64.0804181621560.5725@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

Thanks I will try according to what you said. Mybe I can find why I
have this problem.But a driver come from MontaVista can also work
well.No frame is dropped.

Now I find MontaVista driver have a problem.I execute VIDIOC_REQBUFS
failed After I execute VIDIOC_STREAMOFF and munmap() .This time
soc-camera driver can work well.You can give me some advice.

thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
