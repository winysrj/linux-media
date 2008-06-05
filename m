Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m559vsvC008430
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 05:57:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m559vh3T012655
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 05:57:43 -0400
Date: Thu, 5 Jun 2008 06:57:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080605065726.64ef79f2@gaivota>
In-Reply-To: <200805311720.51821.tobias.lorenz@gmx.net>
References: <200805311720.51821.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 6/6] si470x: pri... vid.. controls
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

Hi Tobias,

I've applied patches 1 to 5. However, I have some comments about patch 6.

On Sat, 31 May 2008 17:20:51 +0200
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:

> Hi Mauro,
> 
> I better resend this patch with a scrambled header...
> "private video controls" is regarded as suspicious header by the spam filter of video4linux-list.
> 
> This patch brings the following changes:
> - private video controls
>   - to control seek behaviour
>   - to module parameters
>   - corrected access rights of module parameters
>   - separate header file to let the user space know about it

I don't like very much the usage of priv controls. They generally are not
really board specific, but something that belongs to a certain group of devices.

For example, tea5767 and tea5761 also are capable of doing seek forward/seek
backward. Also, we're currently lacking a control for de-emphasis. So, maybe
some of the controls are generic enough to a radio class of controls.

I think that some of the controls you've added already have a non private one
(for example, AGC).

Also, controls not documented tend to not be implemented at userspace apps. So,
the better is to discuss a little bit about each control you're proposing, and
adding they at the API description (even the private ones).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
