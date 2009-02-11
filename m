Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1BNLa3V006777
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 18:21:36 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1BNL04L013914
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 18:21:01 -0500
Received: by rv-out-0506.google.com with SMTP id f6so115244rvb.51
	for <video4linux-list@redhat.com>; Wed, 11 Feb 2009 15:21:00 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 12 Feb 2009 10:21:00 +1100
Message-ID: <78877a450902111521y860c1c7ifef1800f53204488@mail.gmail.com>
From: Gilles GIGAN <gilles.gigan@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Comments on controls
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

Hi everyone,
I have a couple of comments / suggestions regarding the part on controls of
the V4L2 api:
Some controls, such as pan relative and tilt relative are write-only, and
reading their value makes little sense. Yet, there is no way of knowing
about this, but to try read a value and be greeted with EINVAL or similar.
There is already a read-only flag (V4L2_CTRL_FLAG_READ_ONLY) in struct
v4l2_query. Does it make sense to add another one for write-only controls ?
The extended controls Pan / Tilt  reset are defined in the API as boolean
controls. Shouldnt these be defined as buttons instead, as they dont really
hold a state (enabled/disabled) ?
Cheers,
Gilles
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
