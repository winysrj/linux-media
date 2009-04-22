Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3MGwvnr022701
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 12:58:57 -0400
Received: from mail-gx0-f158.google.com (mail-gx0-f158.google.com
	[209.85.217.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3MGwc2c029448
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 12:58:38 -0400
Received: by gxk2 with SMTP id 2so152581gxk.3
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 09:58:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bfa9a8f30904062239l2d096accj47c1fb8d50eafcf7@mail.gmail.com>
References: <bfa9a8f30904062239l2d096accj47c1fb8d50eafcf7@mail.gmail.com>
Date: Wed, 22 Apr 2009 12:58:37 -0400
Message-ID: <412bdbff0904220958r64185be1v6ac1fd31c3e5014@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Christopher Pascoe <linuxdvb@itee.uq.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: No scan with DViCo FusionHDTV DVB-T Dual Express
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

On Tue, Apr 7, 2009 at 1:39 AM, Christopher Pascoe
<linuxdvb@itee.uq.edu.au> wrote:
> (Hopefully this email will join the thread - I just joined the list briefly
> so I could post.)
>
> I had a few minutes while stuck on a bus and had a look at the code in
> v4l-dvb tip.  It appears that the driver there has at least two problems -
> it resets the wrong (or no) tuner in the callback and it potentially locks
> up the I2C bus through tinkering with the zl10353's gate_control logic.  The
> first alone would cause an "incorrect readback of firmware version" message
> after the first tune.  The second would explain the device subids
> disappearing and your having to use card=11 for the board to be found.
>
> Try the patch at
> http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/dual-digital-express-dvb-t-fix-20090407-1.patch.
>  It probably addresses these two issues (it's not even compile tested,
> so
> if it doesn't build I'm sure you get the idea) and see if it makes any
> difference.
>
> Regards,
> Chris

Hello Christopher,

I was in the process of getting a tree together so I could issue a
PULL request for this patch.  However, it seems that the server
referenced above hosting the patch is now showing network timeouts.

Could you please re-send the patch to the list directly?  I've got the
Tested-By line from the user (John Knops) and am working on getting an
SOB by stoth so I can issue the PULL request.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
