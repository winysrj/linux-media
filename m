Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MIGUx1021097
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 14:16:30 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8MIGKvK009930
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 14:16:20 -0400
Message-ID: <48D7E121.50002@hhs.nl>
Date: Mon, 22 Sep 2008 20:17:05 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
References: <48D7DAE1.7040204@gmail.com>
In-Reply-To: <48D7DAE1.7040204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: m560x driver devel <m560x-driver-devel@lists.sourceforge.net>,
	video4linux-list@redhat.com
Subject: Re: [GSPCA] A couple of questions
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

Erik Andrén wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> I've begun the working investigating the possibility of converting the
> m5602 driver to the gspca framework.

Great! You rock, really you do :)

> I currently have the following questions:
> 1) From my understanding each driver implementing the gspca framework
> has a static list of v4l2 controls. In the m5602 driver, each sensor has
> its own set of v4l2 controls with different resolutions.
> Is there a obious solution to this problem?
> 

Yes and no, for now the solution is to make your sd_desc non const and update 
the ctrls member to point to the right array. In the future I want to add a 
const struct sd_desc *sensor_ctrls to the main gspca struct, which you can then 
set at probe time, as there are more subdrivers with this issue.

Feel free todo that now in your patch if that suits you. My idea is to have per 
bridge controls in sd_desc, and per sensor controls in gspca_dev.

> 2) In the sd_desc struct, is it necessary to implement the dq_callback
> or does the gspca driver automagically requeue buffers?

There is no need to implement this, its just a callback for when you want todo 
something each frame from a non interrupt contexts (like software autoexposure).

Don't hesitate to ask more questions!

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
