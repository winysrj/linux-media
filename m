Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NElfik003887
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 10:47:41 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2NElMFx010944
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 10:47:22 -0400
Received: by yw-out-2324.google.com with SMTP id 3so1233932ywj.81
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 07:47:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237816050.3833.20.camel@T60p>
References: <1237575285.26159.2.camel@T60p>
	<412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
	<1237578912.26159.13.camel@T60p>
	<412bdbff0903201302ib6758a8ue76a8dd235cfa4cb@mail.gmail.com>
	<1237579738.26159.16.camel@T60p>
	<412bdbff0903201314r5105d373ofe6614ee08431d4b@mail.gmail.com>
	<1237816050.3833.20.camel@T60p>
Date: Mon, 23 Mar 2009 10:47:21 -0400
Message-ID: <412bdbff0903230747i1ebc4487x2636369e6b20ce8f@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mikhail Jiline <misha@epiphan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U
	grabbers
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

On Mon, Mar 23, 2009 at 9:47 AM, Mikhail Jiline <misha@epiphan.com> wrote:
> Here is the output from the version with em28xx_i2c_hash hint. Update patch is below.
<snip>

Ok, that looks better.  You should no longer need the "card=" line
with that patch.

Did you verify that both video inputs were working as expected?  Also,
did you confirm the audio support works?  If so, please remove the
"valid        = EM28XX_BOARD_NOT_VALIDATED", submit a final patch, and
I will check it in.

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
