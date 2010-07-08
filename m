Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o68M71QO017759
	for <video4linux-list@redhat.com>; Thu, 8 Jul 2010 18:07:01 -0400
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o68M6mpo012408
	for <video4linux-list@redhat.com>; Thu, 8 Jul 2010 18:06:49 -0400
Received: by qyk38 with SMTP id 38so3794940qyk.12
	for <video4linux-list@redhat.com>; Thu, 08 Jul 2010 15:06:48 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 Jul 2010 19:06:48 -0300
Message-ID: <AANLkTilZ4-9RNbk-QLKo8KpjsxMwFEf7avg4Fjn7Kxx6@mail.gmail.com>
Subject: Multiple webcams using the same driver
From: "Vitor P." <dodecaphonic@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello, all. I'm new to this list, and I bring a question. I'm sorry if the
archives hold its answer; I swear I've tried every search I could think of
and still didn't find a definitive answer to my question.

I'm trying to build a sort of Street View car, for kicks, using cheap
webcams as the source for the images. I have gotten seven Microsoft LifeCam
VX-1000 from a friend, and proceeded to connect all of them to powered USB
hubs. They were recognized, and a couple of V4L applications were used to
test them individually; all went great.

But my use case, alas, requires them to fire simultaneously, or as close to
at the same time as possible. I couldn't: whenever I tried more than one
camera on the same bus, "libv4l2: error turning on stream: Input/output
error
libv4l2: error reading: Invalid argument
v4l2: read: Invalid argument" popped on my face. On two different buses,
fine.

Is it really not possible to use this camera (with "sonixj") in conjunction
with sister cameras of the same model?

Thanks in advance. I apologize for any mistakes and my unquestionable
ignorance.

-- 
Vitor Peres
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
