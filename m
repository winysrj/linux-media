Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n19H3CFQ007501
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 12:03:12 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.29])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n19H2ss6026895
	for <video4linux-list@redhat.com>; Mon, 9 Feb 2009 12:02:54 -0500
Received: by yx-out-2324.google.com with SMTP id 8so27955yxm.81
	for <video4linux-list@redhat.com>; Mon, 09 Feb 2009 09:02:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b24e53350902090859h6a714b2fh8cfaf8d487cecc44@mail.gmail.com>
References: <509279.77236.qm@web31601.mail.mud.yahoo.com>
	<4990525D.5020205@linuxtv.org>
	<b24e53350902090859h6a714b2fh8cfaf8d487cecc44@mail.gmail.com>
Date: Mon, 9 Feb 2009 12:02:53 -0500
Message-ID: <412bdbff0902090902l72409c75n7724062ae87b5ade@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: HVR-950Q status
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

On Mon, Feb 9, 2009 at 11:59 AM, Robert Krakora
<rob.krakora@messagenetsystems.com> wrote:
> Jon:
>
> I too ran into this problem when purchasing what I thought was an
> HVR950.  I bought several of what I thought were HVR950 and I ended up
> getting both HVR950 and HVR950Q parts in the same packaging.  After
> further investigation, the folks at Hauppauge explained the reason
> behind packaging the HVR950Q as an HVR950.  I do not want to
> miss-quote them, so please call them if you want the explanation.
> They are very "up-front".  HVR950Q analog works quite well on Windows
> machines though I do prefer and almost exclusively only build Linux
> machines.  With all due respect to Hauppauge, KWorld makes a part call
> the KWorld 330U that is basically an HVR950 with a slightly different
> front end.  However, it cannot do QAM256 (Clear QAM) but it works very
> well for 8VSB (ATSC) and NTSC.
>
> New Egg has them for only $50.  Ignore the reviews, this is a good
> part.  It is not listed as supported yet only because we have not
> fully tested the analog video and audio inputs.  Please get the latest
> V4L code from the tree at www.linuxtv.org.
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16815260006&nm_mc=OTC-Froogle&cm_mmc=OTC-Froogle-_-Video+Devices+++TV+Tuners-_-Kworld+Computer+Co.+Ltd-_-15260006
>
> Best Regards,

Robert,

Just to be clear, the user is also looking for ClearQAM, for which the
KWorld 330U does not support.

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
