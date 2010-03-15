Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51175 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936628Ab0COUU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 16:20:27 -0400
Received: by wyb38 with SMTP id 38so1684896wyb.19
        for <linux-media@vger.kernel.org>; Mon, 15 Mar 2010 13:20:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mightyiampresence@gmail.com
In-Reply-To: <001485f274c8d0242a0481dc90a9@google.com>
References: <bf87febf1003151317y4f15ef1fs1c1de6bca03602da@mail.gmail.com>
	 <001485f274c8d0242a0481dc90a9@google.com>
Date: Mon, 15 Mar 2010 22:20:25 +0200
Message-ID: <bf87febf1003151320v2d9e33bfwf1fc0a4b15257dc0@mail.gmail.com>
Subject: Fwd: Delivery Status Notification (Failure)
From: Shahar Or <email@shahar-or.co.il>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, only text this time :)

---------- Forwarded message ----------
From: Mail Delivery Subsystem <mailer-daemon@googlemail.com>
Date: Mon, Mar 15, 2010 at 10:17 PM
Subject: Delivery Status Notification (Failure)
To: mightyiampresence@gmail.com


Delivery to the following recipient failed permanently:

    linux-media@vger.kernel.org

Technical details of permanent failure:
Google tried to deliver your message, but it was rejected by the
recipient domain. We recommend contacting the other email provider for
further information about the cause of this error. The error that the
other server returned was: 550 550 5.7.1 Content-Policy reject msg:
The message contains HTML subpart, therefore we consider it SPAM or
Outlook Virus.  TEXT/PLAIN is accepted.! BF:<U 0.498823>;
S936641Ab0COURI (state 18).

----- Original message -----

MIME-Version: 1.0
Received: by 10.216.178.70 with SMTP id e48mr24691wem.0.1268684226676; Mon, 15
       Mar 2010 13:17:06 -0700 (PDT)
In-Reply-To: <20100315191239.54f4c6fa@tele>
References: <bf87febf1003151024k7987318bv6f76a40c4d7daeee@mail.gmail.com>
        <20100315191239.54f4c6fa@tele>
Date: Mon, 15 Mar 2010 22:17:06 +0200
Message-ID: <bf87febf1003151317y4f15ef1fs1c1de6bca03602da@mail.gmail.com>
Subject: Re: [Spca50x-devs] 17a1:0118
From: Shahar Or <mightyiampresence@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: SPCA50x Linux Device Driver Development
<spca50x-devs@lists.sourceforge.net>, rcml@lecurie.org,
       ropers <ropers@gmail.com>, Jean-Yves Lamoureux
<jylam@lnxscene.org>, linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001485f274c8a9ca510481dc90b5

On Mon, Mar 15, 2010 at 8:12 PM, Jean-Francois Moine <moinejf@free.fr>wrote:

> On Mon, 15 Mar 2010 19:24:24 +0200
> Shahar Or <email@shahar-or.co.il> wrote:
>
> > I have a non-supported one, with the ID 17a1:0118. Data attached.
> >
> > I am willing to cooperate with anything that I can, including testing
> > patches.
> >
> > I've noticed there's one here related:
> >
> http://lists-archives.org/spca50x-devs/01649-patch-for-17a1-0128-xpx-jpeg-webcam-tascorp.html
> >
> > I can also send the cam over by mail, if that is necessary.
> >
> > I'm subscribed to the list.
>
> Hello Shahar,
>
> A driver for this webcam is available (you may find it in the last
> gspca version that I have just uploaded - 2.9.6 - the subdriver is
> 'gspca_tasc.ko').
>
> The only problem is that nobody could yet decode the images! (Jens,
> Jean-Yves, any news?)
>
> About the list, all the linux video stuff is hosted at LinuxTv.org and
> the linux-media mailing-list at vger.kernel.org (see Cc:).
>
> Best regards.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>

Yo, I've installed 2.6.9 and tested with vlc. Theres no image but
/dev/video0 exists. Here's dmesg attached.

BTW, I didn't get the part in the README about "If you used a distribution
from a LinuxTv mercurial repository,[...]".
