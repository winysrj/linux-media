Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n38Du4iU003888
	for <video4linux-list@redhat.com>; Wed, 8 Apr 2009 09:56:04 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.189])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n38DtMcJ007265
	for <video4linux-list@redhat.com>; Wed, 8 Apr 2009 09:55:23 -0400
Received: by fk-out-0910.google.com with SMTP id e30so76957fke.3
	for <video4linux-list@redhat.com>; Wed, 08 Apr 2009 06:55:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b3095c50904060807h697ad42cwde338a673c1776f5@mail.gmail.com>
References: <b3095c50904060807h697ad42cwde338a673c1776f5@mail.gmail.com>
Date: Wed, 8 Apr 2009 17:55:21 +0400
Message-ID: <208cbae30904080655o160bad8t7e08730955104668@mail.gmail.com>
From: Alexey Klimov <klimov.linux@gmail.com>
To: Juan Diego <juantascon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question
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

Hello, Juan

On Mon, Apr 6, 2009 at 7:07 PM, Juan Diego <juantascon@gmail.com> wrote:
> Hi, my name is Juan Diego
>
> I would like to make some tests using some v4l applications and I
> would like to know if there is a way to create a "virtual° v4l device
> using a video file to act as a camera
>
> thanks for your help
> bye

Well, i don't sure if i understand you correctly..
Vasily Levin (mail: vasaka at gmail.com) posted V4L2 loopback device
code in maillist to review. I don't know if his code was merged.
Probably this site can help you:
http://code.google.com/p/v4l2loopback/

The patch is here http://www.spinics.net/lists/linux-media/msg03630.html
Anyway, you can contact him by e-mail.

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
